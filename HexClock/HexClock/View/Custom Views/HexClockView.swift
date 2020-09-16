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
	private var clockLabel: UILabel = {
		let clockLabel = UILabel()
		clockLabel.translatesAutoresizingMaskIntoConstraints = false
		clockLabel.textColor = UIColor.white
		clockLabel.textAlignment = .center
		clockLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 250, weight: .ultraLight)
		return clockLabel
	}()
	
	private lazy var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
		guard let self = self else { return }
		let now = Date()
		let (hour, minute, second) = now.timeComponents
		let hourString = String(format: "%02d", hour)
		let minuteString = String(format: "%02d", minute)
		let secondString = String(format: "%02d", second)
		
		// Set the Hex value for the clock
		self.clockLabel.text = "#" + hourString + minuteString + secondString
		
		// Animate the background color
		UIView.animate(withDuration: 1.0) {
			self.backgroundColor = UIColor.fromTime(hour: hour, minute: minute, second: second)
		}
	}
	
	
	
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
