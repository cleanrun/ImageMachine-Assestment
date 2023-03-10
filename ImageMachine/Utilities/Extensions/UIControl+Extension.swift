//
//  UIControl+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 21/12/22.
//

import UIKit
import Combine

protocol CombineCompatible {}

extension UIControl: CombineCompatible {}

extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControlPublisher<UIControl> {
        UIControlPublisher(control: self, event: event)
    }
}
