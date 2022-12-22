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
        let imageManager = PHImageManager()
        let option = PHImageRequestOptions()
        option.resizeMode = .exact
        option.deliveryMode = .highQualityFormat
        option.isSynchronous = true
        imageManager.requestImage(for: self,
                                  targetSize: PHImageManagerMaximumSize,
                                  contentMode: .default,
                                  options: option) { image, _ in
            thumbnail = image!
        }
        return thumbnail
    }
}
