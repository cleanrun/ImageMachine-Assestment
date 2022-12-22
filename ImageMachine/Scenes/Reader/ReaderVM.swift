//
//  ReaderVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine
import UIKit

final class ReaderVM: BaseVM {
    enum ReaderType {
        case detect
        case input
    }
    
    private weak var viewController: ReaderVC?
    let readerType: ReaderType
    
    init(vc: ReaderVC? = nil, type: ReaderType) {
        self.viewController = vc
        self.readerType = type
    }
    
    func detectHandler(_ value: String) {
        if let qrNumber = Int(value) {
            if readerType == .detect {
                if let entity = dataManager.findMachine(byQrNumber: qrNumber) {
                    routeToDetailData(with: MachineModel(from: entity))
                } else {
                    showQrNotRegisteredAlert(detectedQr: qrNumber)
                }
            } else {
                let presentingVc = viewController?.presentingViewController as! MainTabVC
                let navVc = presentingVc.viewControllers?.first as! UINavigationController
                let addDataVc = navVc.viewControllers.last as! AddDataVC
                addDataVc.viewModel.qrNumber = qrNumber
                viewController?.dismiss(animated: true)
            }
        } else {
            showQRResultErrorAlert()
        }
    }
    
    func showQRResultErrorAlert() {
        let alert = UIAlertController(title: "QR Code Result Error",
                                      message: "QR Code must only contain numbers",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel) { [unowned self] _ in
            self.viewController?.captureSession.startRunning()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
    
    private func showQrNotRegisteredAlert(detectedQr: Int) {
        let alert = UIAlertController(title: "QR is not registered",
                                      message: "This QR code is not registered, do you want to make a new Machine based on this QR?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { [unowned self] _ in
            self.routeToAddNewData(with: detectedQr)
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .cancel) { [unowned self] _ in
            self.viewController?.captureSession.startRunning()
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        viewController?.present(alert, animated: true)
    }
    
    private func routeToAddNewData(with qrNumber: Int) {
        let vc = AddDataVC(usingQr: qrNumber)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func routeToDetailData(with model: MachineModel) {
        let vc = DataDetailVC(model: model)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
