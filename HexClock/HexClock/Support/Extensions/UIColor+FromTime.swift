//
//  UIColor+FromTime.swift
//  HexClock
//
//  Created by Chad Rutherford on 9/16/20.
//

import UIKit

extension UIColor {
	
	static func fromTime(hour: Int, minute: Int, second: Int) -> UIColor {
		let red   = CGFloat(hour) / 255.0
		let green = CGFloat(minute) / 255.0
		let blue  = CGFloat(second) / 255.0

		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

}
