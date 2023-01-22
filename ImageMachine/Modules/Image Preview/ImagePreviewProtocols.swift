//
//  ImagePreviewProtocols.swift
//  ImageMachine
//
//  Created by cleanmac on 22/01/23.
//

import Foundation
import UIKit
import Combine

protocol ImagePreviewViewToPresenterProtocol: AnyObject {
    /*weak*/ var view: ImagePreviewPresenterToViewProtocol? { get set }
    var interactor: ImagePreviewPresenterToInteractorProtocol { get set }
    var router: ImagePreviewPresenterToRouterProtocol { get set }
    
    var model: ImageModel { get }
    var image: UIImage? { get set }
    
    func viewDidLoadFired()
    
    func dismiss()
}

protocol ImagePreviewInteractorToPresenterProtocol: AnyObject {
    func noticeImageFetched(_ image: UIImage)
}

protocol ImagePreviewPresenterToRouterProtocol: AnyObject {
    static func createModule(for model: ImageModel) -> ImagePreviewView
    
    func dismiss()
}

protocol ImagePreviewPresenterToViewProtocol: AnyObject {
    var presenter: ImagePreviewViewToPresenterProtocol! { get set }
    
    func observeImage(image: AnyPublisher<UIImage?, Never>)
}

protocol ImagePreviewPresenterToInteractorProtocol: AnyObject {
    /*weak*/ var presenter: ImagePreviewInteractorToPresenterProtocol? { get set }
    
    func createDownsampledImage(using model: ImageModel)
}
