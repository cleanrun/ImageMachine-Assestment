//
//  PHAsset+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 21/12/22.
//

import UIKit
import Photos

extension PHAsset {
    var uiImage: UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self,
                                  targetSize: CGSize(width: 100, height: 100),
                                  contentMode: .aspectFit,
                                  options: nil) { image, _ in
            thumbnail = image!
        }
        return thumbnail
    }
}
