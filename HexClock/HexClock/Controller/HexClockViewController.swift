//
//  HexClockViewController.swift
//  HexClock
//
//  Created by Chad Rutherford on 9/16/20.
//

import UIKit

/// Hex Clock view controller.
class HexClockViewController: UIViewController {
	
	private let clockView = HexClockView()
	
	private lazy var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
		guard let self = self else { return }
		
		// Formatting
		let now = Date()
		let (hour, minute, second) = now.timeComponents
		let hourString = String(format: "%02d", hour)
		let minuteString = String(format: "%02d", minute)
		let secondString = String(format: "%02d", second)
		
		// Set the Hex value for the clock
		self.clockView.clockLabel.text = "#" + hourString + minuteString + secondString
		
		// Animate the background color
		UIView.animate(withDuration: 1.0) {
			self.clockView.backgroundColor = UIColor.fromTime(hour: hour, minute: minute, second: second)
		}
	}

	// MARK: UIViewController
	override func viewDidLoad() {
		view.addSubview(clockView)
		clockView.pinTo(view)
		timer.fire()
	}
}
