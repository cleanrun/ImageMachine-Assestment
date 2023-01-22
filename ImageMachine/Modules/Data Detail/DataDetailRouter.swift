//
//  DataDetailRouter.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation
import UIKit

final class DataDetailRouter: DataDetailPresenterToRouterProtocol {
    weak var presenter: DataDetailRouterToPresenterProtocol?
    
    static func createModule(for model: MachineModel) -> DataDetailView {
        let view = DataDetailView()
        let interactor = DataDetailInteractor()
        let router = DataDetailRouter()
        let presenter = DataDetailPresenter(model: model,
                                            view: view,
                                            interactor: interactor,
                                            router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
    
    func finish() {
        UIApplication.shared.getSelectedTabNavigationController()?.popViewController(animated: true)
    }
    
    func presentImagePreviewModal(_ image: ImageModel) {
        // FIXME: Present image preview modal
    }
    
    func presentDeleteImageAlert(_ image: ImageModel) {
        let alert = UIAlertController(title: "Delete Image",
                                      message: "Are you sure you want to delete this image?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .destructive) { [unowned self] _ in
            self.presenter?.notifyDeleteImage(image)
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
}
