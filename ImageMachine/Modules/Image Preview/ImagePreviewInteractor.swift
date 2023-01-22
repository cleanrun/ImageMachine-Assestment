//
//  ImagePreviewInteractor.swift
//  ImageMachine
//
//  Created by cleanmac on 22/01/23.
//

import UIKit

final class ImagePreviewInteractor: ImagePreviewPresenterToInteractorProtocol {
    weak var presenter: ImagePreviewInteractorToPresenterProtocol?
    
    func createDownsampledImage(using model: ImageModel) {
        if let image = model.imageData.createDownsampledImage(to: CGSize(width: 800, height: 800)) {
            presenter?.noticeImageFetched(image)
        }
    }
}
