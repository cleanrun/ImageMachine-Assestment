//
//  AddDataProtocols.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation
import Combine
import PhotosUI

protocol AddDataViewToPresenterProtocol: AnyObject {
    /*weak*/ var view: AddDataPresenterToViewProtocol? { get set }
    var interactor: AddDataPresenterToInteractorProtocol { get set }
    var router: AddDataPresenterToRouterProtocol { get set }
    
    var name: String! { get set }
    var type: String! { get set }
    var qrNumber: Int! { get set }
    var maintenanceDate: Date! { get set }
    var images: CurrentValueSubject<[ImageModel], Never>! { get set }
    var validation: AnyPublisher<Bool, Never>! { get set }
    
    func viewDidLoadFired()
    
    func setName(_ name: String)
    func setType(_ type: String)
    func setMaintenanceDate(_ date: Date)
    func setQrNumber(_ qr: Int)
    
    func saveData()
    func deleteImage(model: ImageModel)
    
    func showReaderModal()
    func showPhotoPickerModal(authorized: Bool)
}

protocol AddDataInteractorToPresenterProtocol: AnyObject {
    func noticeQRRegistered()
    func noticeFinishSavingData()
    func noticeConvertedImageModels(results: [ImageModel])
}

protocol AddDataRouterToPresenterProtocol: AnyObject {
    func notifyFinishedPickingPhoto(results: [PHPickerResult])
}

protocol AddDataPresenterToRouterProtocol: AnyObject {
    /*weak*/ var presenter: AddDataRouterToPresenterProtocol? { get set }
    
    static func createModule() -> AddDataView
    
    func finish()
    
    func presentReaderModal()
    func presentPhotoPickerModal()
    func presentPhotoPickerNotAuthorizedAlert()
    func presentQRRegisteredAlert()
}

protocol AddDataPresenterToViewProtocol: AnyObject {
    var presenter: AddDataViewToPresenterProtocol! { get set }
    
    func observeInputtedFields(qrNumber: AnyPublisher<Int?, Never>,
                               maintenanceDate: AnyPublisher<Date?, Never>,
                               images: AnyPublisher<[ImageModel], Never>,
                               validation: AnyPublisher<Bool, Never>)
}

protocol AddDataPresenterToInteractorProtocol: AnyObject {
    var dataManager: CoreDataManager { get }
    /*weak*/ var presenter: AddDataInteractorToPresenterProtocol? { get set }
    
    func saveData(model: MachineModel, images: [ImageModel])
    func convertPickerResultIntoImageModels(results: [PHPickerResult])
}
