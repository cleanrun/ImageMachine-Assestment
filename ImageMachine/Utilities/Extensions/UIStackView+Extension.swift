//
//  UIStackView+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        for view in subviews {
            addArrangedSubview(view)
        }
    }
}
