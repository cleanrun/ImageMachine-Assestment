//
//  ReaderProtocols.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Combine

protocol ReaderViewToPresenterProtocol: AnyObject {
    /*weak*/ var view: ReaderPresenterToViewProtocol? { get set }
    var interactor: ReaderPresenterToInteractorProtocol { get set }
    var router: ReaderPresenterToRouterProtocol { get set }
    
    func detectCode(type: ReaderVM.ReaderType, _ value: String)
    
    func showCameraNotAuthorizedAlert()
}

protocol ReaderInteractorToPresenterProtocol: AnyObject {
    func noticeQRResultError()
    func noticeQRRegistered(_ model: MachineModel)
    func noticeQRNotRegistered(detectedQr: Int)
    func noticeQRDetectedForFillingNewData(detectedQr: Int)
}

protocol ReaderRouterToPresenterProtocol: AnyObject {
    func notifyRestartCaptureSession()
}

protocol ReaderPresenterToRouterProtocol: AnyObject {
    /*weak*/ var presenter: ReaderRouterToPresenterProtocol? { get set }
    
    static func createModule(for: ReaderVM.ReaderType) -> ReaderView
    
    func dismiss()
    
    func presentCameraNotAuthorizedAlert()
    func presentQRResultErrorAlert()
    func presentQRNotRegisteredAlert(detectedQr: Int)
    
    func pushToAddNewData(qrNumber: Int)
    func pushToDetailData(model: MachineModel)
}

protocol ReaderPresenterToViewProtocol: AnyObject {
    var presenter: ReaderViewToPresenterProtocol! { get set }
    
    func detectedCode(_ value: String)
    func restartCaptureSession()
}

protocol ReaderPresenterToInteractorProtocol: AnyObject {
    var dataManager: CoreDataManager { get }
    /*weak*/ var presenter: ReaderInteractorToPresenterProtocol? { get set }
    
    func checkDetectedCode(type: ReaderVM.ReaderType,
                           _ value: String)
}
