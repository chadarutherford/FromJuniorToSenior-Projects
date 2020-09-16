//
//  UIView+AutoLayout.swift
//  HexClock
//
//  Created by Chad Rutherford on 9/16/20.
//

import UIKit

extension UIView {

	func pinTo(_ otherView: UIView) {
		topAnchor.constraint(equalTo: otherView.topAnchor).isActive = true
		bottomAnchor.constraint(equalTo: otherView.bottomAnchor).isActive = true
		leadingAnchor.constraint(equalTo: otherView.leadingAnchor).isActive = true
		trailingAnchor.constraint(equalTo: otherView.trailingAnchor).isActive = true
	}

}
