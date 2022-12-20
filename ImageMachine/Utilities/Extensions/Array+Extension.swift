//
//  Array+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

extension Array where Element == UIImage {
    func transformToData() -> [Data] {
        self.compactMap {
            $0.pngData()
        }
    }
}

extension Array where Element == Data {
    func transformToUIImage() -> [UIImage] {
        self.compactMap {
            UIImage(data: $0)
        }
    }
}
