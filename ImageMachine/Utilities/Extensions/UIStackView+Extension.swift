//
//  UIStackView+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

extension UIStackView {
    
    /// Adds multiple views to the arranged subviews array.
    ///
    /// Use this function to add multiple views without having to use the default `addArrangedSubview(_:)` method. You could pass multiple view parameters. You need to add your views chronologically.
    /// - Parameter subviews: The views to add to the array of views arranged by the stack.
    func addArrangedSubviews(_ subviews: UIView...) {
        for view in subviews {
            addArrangedSubview(view)
        }
    }
}
