//
//  UIView+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

extension UIView {
    
    /// Adds multiple views to the subviews array
    ///
    /// Use this function to add multiple views without having to use the default `addSubview(_:)` method. You could pass multiple view parameters. You need to add your views chronologically.
    /// - Parameter views: The views to add to the array of views arranged by the superview.
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
