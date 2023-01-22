//
//  ReaderRouter.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import UIKit

final class ReaderRouter: ReaderPresenterToRouterProtocol {
    weak var presenter: ReaderRouterToPresenterProtocol?
    
    static func createModule(for type: ReaderType) -> ReaderView {
        let view = ReaderView(readerType: type)
        let interactor = ReaderInteractor()
        let router = ReaderRouter()
        let presenter = ReaderPresenter(view: view,
                                        interactor: interactor,
                                        router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
    
    func dismiss() {
        UIApplication.shared.getTopViewController()?.dismiss(animated: true)
    }
    
    func presentCameraNotAuthorizedAlert() {
        let alert = UIAlertController(title: "Missing camera permission",
                                      message: "To add a new Machine data, please grant the camera permission for this app.",
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go To Settings",
                                   style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            UIApplication.shared.getTopViewController()?.tabBarController?.selectedIndex = 0
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                   style: .cancel) { _ in
            UIApplication.shared.getTopViewController()?.tabBarController?.selectedIndex = 0
        }
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
    func presentQRResultErrorAlert() {
        let alert = UIAlertController(title: "QR Code Result Error",
                                      message: "QR Code must only contain numbers",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel) { [unowned self] _ in
            self.presenter?.notifyRestartCaptureSession()
        }
        alert.addAction(action)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
    func presentQRNotRegisteredAlert(detectedQr: Int) {
        let alert = UIAlertController(title: "QR is not registered",
                                      message: "This QR code is not registered, do you want to make a new Machine based on this QR?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { [unowned self] _ in
            self.pushToAddNewData(qrNumber: detectedQr)
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .cancel) { [unowned self] _ in
            self.presenter?.notifyRestartCaptureSession()
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
    func pushToAddNewData(qrNumber: Int) {
        // FIXME: Push to add new data page
    }
    
    func pushToDetailData(model: MachineModel) {
        // FIXME: Push to detail data page
    }
    
}
