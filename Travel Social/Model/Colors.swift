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
        let colorTop = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 10.0 / 255.0, green: 10 / 255.0, blue: 10 / 255.0, alpha: 0.5).cgColor

        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
    }
}
