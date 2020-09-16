//
//  HexClockView.swift
//  HexClock
//
//  Created by Chad Rutherford on 9/16/20.
//

import UIKit

/// Hex Clock view.
final class HexClockView: UIView {
	
	// MARK: Properties
	let clockLabel: UILabel = {
		let clockLabel = UILabel()
		clockLabel.translatesAutoresizingMaskIntoConstraints = false
		clockLabel.textColor = .white
		clockLabel.textAlignment = .center
		clockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 250, weight: .ultraLight)
		return clockLabel
	}()
	
	// MARK: Initialization
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
}

extension HexClockView {
	private func setup() {
		translatesAutoresizingMaskIntoConstraints = false
		addSubview(clockLabel)
		clockLabel.pinTo(self)
	}
}
