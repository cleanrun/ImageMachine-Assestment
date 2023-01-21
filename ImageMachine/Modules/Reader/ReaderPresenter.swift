//
//  ReaderPresenter.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import UIKit

final class ReaderPresenter: ReaderViewToPresenterProtocol {
    weak var view: ReaderPresenterToViewProtocol?
    var interactor: ReaderPresenterToInteractorProtocol
    var router: ReaderPresenterToRouterProtocol
    
    init(view: ReaderPresenterToViewProtocol,
         interactor: ReaderPresenterToInteractorProtocol,
         router: ReaderPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func detectCode(type: ReaderVM.ReaderType, _ value: String) {
        interactor.checkDetectedCode(type: type, value)
    }
    
    func showCameraNotAuthorizedAlert() {
        router.presentCameraNotAuthorizedAlert()
    }
    
}

extension ReaderPresenter: ReaderInteractorToPresenterProtocol {
    func noticeQRResultError() {
        router.presentQRResultErrorAlert()
    }
    
    func noticeQRRegistered(_ model: MachineModel) {
        router.pushToDetailData(model: model)
    }
    
    func noticeQRNotRegistered(detectedQr: Int) {
        router.presentQRNotRegisteredAlert(detectedQr: detectedQr)
    }
    
    func noticeQRDetectedForFillingNewData(detectedQr: Int) {
        // FIXME: Fill the detected QR to the input page
    }
}

extension ReaderPresenter: ReaderRouterToPresenterProtocol {
    func notifyRestartCaptureSession() {
        view?.restartCaptureSession()
    }
}
