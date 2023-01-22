//
//  AddDataRouter.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import UIKit
import PhotosUI

final class AddDataRouter: AddDataPresenterToRouterProtocol {
    weak var presenter: AddDataRouterToPresenterProtocol?
    
    static func createModule(withQrNumber: Int? = nil) -> AddDataView {
        let view = AddDataView()
        let interactor = AddDataInteractor()
        let router = AddDataRouter()
        let presenter = AddDataPresenter(qrNumber: withQrNumber,
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
    
    func presentReaderModal() {
        let vc = ReaderRouter.createModule(for: .input)
        UIApplication.shared.getTopViewController()?.present(vc, animated: true)
    }
    
    func presentPhotoPickerModal() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 10
        config.filter = .images
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        UIApplication.shared.getTopViewController()?.present(vc, animated: true)
    }
    
    func presentPhotoPickerNotAuthorizedAlert() {
        let alert = UIAlertController(title: "Missing photo library permission",
                                      message: "To add a new Machine data, please grant the photo library permission for all photos for this app.",
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go To Settings",
                                   style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                   style: .cancel)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
    func presentQRRegisteredAlert() {
        let alert = UIAlertController(title: "QR code is already registered",
                                      message: "This QR code is already registered, please change to other QR code.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                   style: .cancel)
        alert.addAction(okAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
}

extension AddDataRouter: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) { [unowned self] in
            self.presenter?.notifyFinishedPickingPhoto(results: results)
        }
    }
}
