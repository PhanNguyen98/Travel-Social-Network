//
//  UIAlertController+pruneNegativeWidthConstraints.swift
//  Travel Social
//
//  Created by Phan Nguyen on 05/03/2021.
//

import UIKit

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
