//
//  DataDetailProtocols.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation
import Combine

protocol DataDetailViewToPresenterProtocol: AnyObject {
    /*weak*/ var view: DataDetailPresenterToViewProtocol? { get set }
    var interactor: DataDetailPresenterToInteractorProtocol { get set }
    var router: DataDetailPresenterToRouterProtocol { get set }
    
    var model: MachineModel! { get }
    
    var formType: CurrentValueSubject<DataDetailVM.DetailFormType, Never>! { get set }
    var name: String! { get set }
    var type: String! { get set }
    var qrNumber: Int! { get set }
    var maintenanceDate: Date! { get set }
    var images: CurrentValueSubject<[ImageModel], Never>! { get set }
    
    func viewDidLoadFired()
    
    func getCurrentFormType() -> DataDetailVM.DetailFormType
    func getImages() -> [ImageModel]
    
    func setName(_ name: String)
    func setType(_ type: String)
    func setMaintenanceDate(_ date: Date)
    func deleteImage(_ image: ImageModel)
    
    func editData()
    func saveEdittedData()
    
    func showImagePreviewModal(_ image: ImageModel)
    func showDeleteImageAlert(_ image: ImageModel)
}

protocol DataDetailInteractorToPresenterProtocol: AnyObject {
    func noticeImageRetrieved(_ models: [ImageModel])
    func noticeDataEditted()
    func noticeImageDeleted(_ model: ImageModel)
}

protocol DataDetailRouterToPresenterProtocol: AnyObject {
    func notifyDeleteImage(_ image: ImageModel)
}

protocol DataDetailPresenterToRouterProtocol: AnyObject {
    /*weak*/ var presenter: DataDetailRouterToPresenterProtocol? { get set }
    
    static func createModule(for model: MachineModel) -> DataDetailView
    
    func finish()
    
    func presentImagePreviewModal(_ image: ImageModel)
    func presentDeleteImageAlert(_ image: ImageModel)
}

protocol DataDetailPresenterToViewProtocol: AnyObject {
    var presenter: DataDetailViewToPresenterProtocol! { get set }
    
    func setFieldsInitialValue(_ model: MachineModel)
    func observeFields(formType: AnyPublisher<DataDetailVM.DetailFormType, Never>,
                       name: AnyPublisher<String?, Never>,
                       type: AnyPublisher<String?, Never>,
                       qrNumber: AnyPublisher<Int?, Never>,
                       maintenanceDate: AnyPublisher<Date?, Never>,
                       images: AnyPublisher<[ImageModel], Never>)
}

protocol DataDetailPresenterToInteractorProtocol: AnyObject {
    var dataManager: CoreDataManager { get }
    /*weak*/ var presenter: DataDetailInteractorToPresenterProtocol? { get set }
    
    func retrieveImagesFromDisk(_ names: [String])
    func saveEdittedData(_ model: MachineModel)
    func deleteImage(_ model: ImageModel)
}
