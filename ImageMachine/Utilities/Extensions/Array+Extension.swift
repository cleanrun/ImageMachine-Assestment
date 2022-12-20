//
//  Array+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

extension Array where Element == UIImage {
    
    /// Transform an array of `UIImage` objects to an array of `Data`
    /// - Returns: The transformed array containing  png `Data` objects
    func transformToData() -> [Data] {
        self.compactMap {
            $0.pngData()
        }
    }
}

extension Array where Element == Data {
    /// Transform an array of `Data` objects to an array of `UIImage`
    /// - Returns: The transformed array containing  `UIImage` objects
    func transformToUIImage() -> [UIImage] {
        self.compactMap {
            UIImage(data: $0)
        }
    }
}
