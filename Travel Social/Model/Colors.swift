//
//  Colors.swift
//  Travel Social
//
//  Created by Phan Nguyen on 11/03/2021.
//

import UIKit

class Colors {
    let gradientLayer = CAGradientLayer()

    init() {
        let colorBottom = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 0.2).cgColor
        let colorTop = UIColor(red: 0.0 / 255.0, green: 194 / 255.0, blue: 166 / 255.0, alpha: 0.2).cgColor

        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
    }
}
