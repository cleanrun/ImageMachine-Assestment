//
//  UITextField+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    var textPublished: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                             object: self)
        .compactMap { notification in
            (notification.object as? UITextField)?.text
        }.eraseToAnyPublisher()
    }
}
