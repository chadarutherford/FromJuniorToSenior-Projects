//
//  HexClockViewController.swift
//  HexClock
//
//  Created by Chad Rutherford on 9/16/20.
//

import UIKit

/// Hex Clock view controller.
class HexClockViewController: UIViewController {

	// MARK: UIViewController

	override func viewDidLoad() {
		let clockView = HexClockView()
		view.addSubview(clockView)
		clockView.pinTo(view)
	}

}
