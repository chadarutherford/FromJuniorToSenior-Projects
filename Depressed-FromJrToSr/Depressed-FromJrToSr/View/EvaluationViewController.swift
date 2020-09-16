import UIKit

protocol EvaluationViewControllerActions {
	func findHelp(evaluation: EvaluationViewModel, from: UIViewController)
	func requestAppReview(evaluation: EvaluationViewModel, from: UIViewController)
}

class EvaluationViewController: UIViewController {
	
	var viewModel: EvaluationViewModel! {
		didSet {
			if let viewModel = viewModel {
				updateUIWithViewModel(viewModel)
			}
		}
	}
	
	@IBOutlet weak var resultLabel: UILabel!
	@IBOutlet weak var additionalLabel: UILabel!
	@IBOutlet weak var findHelpButton: UIButton!
	@IBOutlet weak var findHelpLabel: UILabel!
	
	var delegate: EvaluationViewControllerActions!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateUIWithViewModel(viewModel)
		
		NotificationCenter.default.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
	}
	
	override func accessibilityPerformMagicTap() -> Bool {
		viewDetailsTapped(self)
		return true
	}
	
	class func new(viewModel: EvaluationViewModel, delegate: EvaluationViewControllerActions) -> EvaluationViewController {
		let evaluationViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "EvaluationViewController") as! EvaluationViewController
		evaluationViewController.viewModel = viewModel
		evaluationViewController.delegate = delegate
		return evaluationViewController
	}
}

extension EvaluationViewController {
	// MARK: - Actions
	@IBAction func viewDetailsTapped(_ sender: Any) {
		guard let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EvaluationDetails") as? EvaluationDetailsViewController else {
			return
		}
		detailsViewController.viewModel = viewModel
		navigationController?.pushViewController(detailsViewController, animated: true)
	}
	
	@IBAction func findHelpTapped(_ sender: AnyObject) {
		delegate.findHelp(evaluation: viewModel, from: self)
	}
}

extension EvaluationViewController {
	// MARK: - Business Logic
	@objc private func fontSizeChanged() {
		updateUIWithViewModel(viewModel)
	}
	
	func updateUIWithViewModel(_ viewModel: EvaluationViewModel) {
		guard isViewLoaded else { return }
		
		let diagnosisText = viewModel.diagnosisText as NSString
		
		let font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: traitCollection)
		let boldFont = UIFont.boldSystemFont(ofSize: font.pointSize)
		
		let attributedDiagnosisText = NSMutableAttributedString(string: viewModel.diagnosisText,
																attributes: [.font: font])
		
		let diagnosisRange = diagnosisText.range(of: viewModel.diagnosis)
		
		attributedDiagnosisText.addAttribute(.font, value: boldFont, range: diagnosisRange)
		
		resultLabel.attributedText = attributedDiagnosisText
		additionalLabel.text = viewModel.suicidalText
		
		if viewModel.shouldDisplayFindingHelpInformation {
			findHelpButton.isHidden = false
			findHelpLabel.isHidden = false
			findHelpLabel.text = viewModel.findingHelpViewModel!.credits
		} else {
			findHelpButton.isHidden = true
			findHelpLabel.isHidden = true
		}
		
		if viewModel.shouldPromptForReview {
			delegate.requestAppReview(evaluation: viewModel, from: self)
			viewModel.didShowReviewPrompt()
		}
	}
}
