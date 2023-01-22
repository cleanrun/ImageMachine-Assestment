//
//  ImagePreviewPresenter.swift
//  ImageMachine
//
//  Created by cleanmac on 22/01/23.
//

import UIKit

final class ImagePreviewPresenter: ImagePreviewViewToPresenterProtocol {
    weak var view: ImagePreviewPresenterToViewProtocol?
    var interactor: ImagePreviewPresenterToInteractorProtocol
    var router: ImagePreviewPresenterToRouterProtocol
    
    var model: ImageModel
    @Published var image: UIImage? = nil
    
    init(model: ImageModel,
         view: ImagePreviewPresenterToViewProtocol,
         interactor: ImagePreviewPresenterToInteractorProtocol,
         router: ImagePreviewPresenterToRouterProtocol) {
        self.model = model
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoadFired() {
        interactor.createDownsampledImage(using: model)
        view?.observeImage(image: $image.eraseToAnyPublisher())
    }
    
    func dismiss() {
        router.dismiss()
    }
    
}

extension ImagePreviewPresenter: ImagePreviewInteractorToPresenterProtocol {
    func noticeImageFetched(_ image: UIImage) {
        self.image = image
    }
}
