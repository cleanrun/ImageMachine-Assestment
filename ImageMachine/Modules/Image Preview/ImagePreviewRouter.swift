//
//  ImagePreviewRouter.swift
//  ImageMachine
//
//  Created by cleanmac on 22/01/23.
//

import UIKit

final class ImagePreviewRouter: ImagePreviewPresenterToRouterProtocol {
    static func createModule(for model: ImageModel) -> ImagePreviewView {
        let view = ImagePreviewView()
        let interactor = ImagePreviewInteractor()
        let router = ImagePreviewRouter()
        let presenter = ImagePreviewPresenter(model: model,
                                              view: view,
                                              interactor: interactor,
                                              router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
    
    func dismiss() {
        UIApplication.shared.getTopViewController()?.dismiss(animated: true)
    }
}
