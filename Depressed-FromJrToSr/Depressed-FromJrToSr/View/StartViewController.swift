import UIKit
import SafariServices
import StoreKit
import ResearchKit

class StartViewController: UIViewController, ORKTaskViewControllerDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem?.accessibilityLabel = NSLocalizedString("infobutton.accessibilityLabel", comment: "")
	}
	
	override func accessibilityPerformMagicTap() -> Bool {
		startTest(self)
		return true
	}
	
	@IBAction func startTest(_ sender: AnyObject) {
		
		let task = SelfTestTask.task()
		let taskController = ORKTaskViewController(task: task, taskRun: nil)
		taskController.delegate = self
		taskController.modalPresentationStyle = .pageSheet
		taskController.navigationBar.prefersLargeTitles = false
		taskController.navigationBar.titleTextAttributes = [
			.foregroundColor: Appearance.endeavour
		]
		present(taskController, animated: true, completion: nil)
	}
	
	// MARK: - ORKTaskViewControllerDelegate
	
	func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
		
		switch reason {
		case .completed:
			guard let results = taskViewController.result.results as? [ORKStepResult] else { return }
			
			let settings = Settings()
			settings.incrementNumberOfFinishedSurveys()
			
			let evaluation = Evaluation(stepResults: results)
			
			if let evaluation = evaluation {
				
				let findingHelpInformation = FindingHelpInformation(locale: Locale.current)
				let viewModel = EvaluationViewModel(evaluation: evaluation, findingHelpInformation: findingHelpInformation, settings: settings)
				// swiftlint:disable:next force_cast
				let evaluationViewController = EvaluationViewController.new(viewModel: viewModel, delegate: self)
				
				navigationController?.pushViewController(evaluationViewController, animated: false)
				
			}
		case .discarded:
			break
		case .failed:
			break
		case .saved:
			break
		@unknown default:
			break
		}
		
		dismiss(animated: true) {
			self.setNeedsStatusBarAppearanceUpdate()
		}
	}
	
}

extension StartViewController: EvaluationViewControllerActions {
	func findHelp(evaluation: EvaluationViewModel, from: UIViewController) {
		guard let url = evaluation.findingHelpViewModel?.url else { return }
		let safariViewController = SFSafariViewController(url: url as URL)
		safariViewController.preferredControlTintColor = Appearance.endeavour
		present(safariViewController, animated: true)
	}
	
	func requestAppReview(evaluation: EvaluationViewModel, from: UIViewController) {
		SKStoreReviewController.requestReview()
	}
}
