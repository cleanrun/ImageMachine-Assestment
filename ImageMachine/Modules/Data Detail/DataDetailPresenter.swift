//
//  DataDetailPresenter.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation
import Combine

final class DataDetailPresenter: DataDetailViewToPresenterProtocol {
    weak var view: DataDetailPresenterToViewProtocol?
    var interactor: DataDetailPresenterToInteractorProtocol
    var router: DataDetailPresenterToRouterProtocol
    
    var model: MachineModel!
    
    var formType: CurrentValueSubject<DataDetailVM.DetailFormType, Never>!
    @Published var name: String!
    @Published var type: String!
    @Published var qrNumber: Int!
    @Published var maintenanceDate: Date!
    var images: CurrentValueSubject<[ImageModel], Never>!
    
    init(model: MachineModel,
         view: DataDetailPresenterToViewProtocol,
         interactor: DataDetailPresenterToInteractorProtocol,
         router: DataDetailPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.model = model
    }
    
    func viewDidLoadFired() {
        self.formType = CurrentValueSubject(.detail)
        self.name = model.name
        self.type = model.type
        self.qrNumber = model.qrNumber
        self.maintenanceDate = model.maintenanceDate
        
        interactor.retrieveImagesFromDisk(model.imageFileNames)
        
        view?.observeFields(formType: formType.eraseToAnyPublisher(),
                            name: $name.eraseToAnyPublisher(),
                            type: $type.eraseToAnyPublisher(),
                            qrNumber: $qrNumber.eraseToAnyPublisher(),
                            maintenanceDate: $maintenanceDate.eraseToAnyPublisher(),
                            images: images.eraseToAnyPublisher()
        )
        view?.setFieldsInitialValue(model)
    }
    
    func getCurrentFormType() -> DataDetailVM.DetailFormType {
        formType.value
    }
    
    func getImages() -> [ImageModel] {
        images.value
    }
    
    func setName(_ name: String) {
        self.name = name
    }
    
    func setType(_ type: String) {
        self.type = type
    }
    
    func setMaintenanceDate(_ date: Date) {
        self.maintenanceDate = date
    }
    
    func deleteImage(_ image: ImageModel) {
        interactor.deleteImage(image)
    }
    
    func editData() {
        formType.send(.edit)
    }
    
    func saveEdittedData() {
        var model = MachineModel(machineId: model.machineId,
                                 name: name,
                                 type: type,
                                 qrNumber: model.qrNumber,
                                 maintenanceDate: maintenanceDate)
        model.setImageFileNames(names: images.value.map { $0.id } )
        interactor.saveEdittedData(model)
    }
    
    func showImagePreviewModal(_ image: ImageModel) {
        router.presentImagePreviewModal(image)
    }
    
    func showDeleteImageAlert(_ image: ImageModel) {
        router.presentDeleteImageAlert(image)
    }
    
}

extension DataDetailPresenter: DataDetailInteractorToPresenterProtocol {
    func noticeImageRetrieved(_ models: [ImageModel]) {
        images = CurrentValueSubject(models)
    }
    
    func noticeDataEditted() {
        formType.send(.detail)
    }
    
    func noticeImageDeleted(_ model: ImageModel) {
        var updatedImages = images.value
        updatedImages.removeAll(where: { $0.id == model.id })
        images.send(updatedImages)
    }
}

extension DataDetailPresenter: DataDetailRouterToPresenterProtocol {
    func notifyDeleteImage(_ image: ImageModel) {
        interactor.deleteImage(image)
    }
}
