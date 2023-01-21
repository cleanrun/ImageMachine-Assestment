//
//  AddDataPresenter.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation
import Combine
import PhotosUI

final class AddDataPresenter: AddDataViewToPresenterProtocol {
    weak var view: AddDataPresenterToViewProtocol?
    var interactor: AddDataPresenterToInteractorProtocol
    var router: AddDataPresenterToRouterProtocol
    
    @Published var name: String! = ""
    @Published var type: String! = ""
    @Published var qrNumber: Int! = 0
    @Published var maintenanceDate: Date! = Date()
    var images: CurrentValueSubject<[ImageModel], Never>! = CurrentValueSubject<[ImageModel], Never>([])
    lazy var validation: AnyPublisher<Bool, Never>! = {
        Publishers
            .CombineLatest4($name, $type, $qrNumber, images)
            .map { nameValue, typeValue, qrValue, imagesValue in
                (!nameValue!.isEmpty) && (!typeValue!.isEmpty) && (qrValue != 0) && (!imagesValue.isEmpty)
            }.eraseToAnyPublisher()
    }()
    
    init(view: AddDataPresenterToViewProtocol,
         interactor: AddDataPresenterToInteractorProtocol,
         router: AddDataPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: kQrNumberDetectedForFillingNewData, object: nil)
    }
    
    func viewDidLoadFired() {
        view?.observeInputtedFields(qrNumber: $qrNumber.eraseToAnyPublisher(),
                                   maintenanceDate: $maintenanceDate.eraseToAnyPublisher(),
                                   images: images.eraseToAnyPublisher(),
                                   validation: validation)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setQrNumber(_:)),
                                               name: kQrNumberDetectedForFillingNewData,
                                               object: nil)
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
    
    @objc func setQrNumber(_ qr: Int) {
        self.qrNumber = qr
    }
    
    func saveData() {
        let model = MachineModel(name: name, type: type, qrNumber: qrNumber, maintenanceDate: maintenanceDate)
        interactor.saveData(model: model, images: images.value)
    }
    
    func deleteImage(model: ImageModel) {
        var updatedArray = images.value
        updatedArray.removeAll(where: { $0.id == model.id })
        images.send(updatedArray)
    }
    
    func showReaderModal() {
        router.presentReaderModal()
    }
    
    func showPhotoPickerModal(authorized: Bool) {
        authorized ? router.presentPhotoPickerModal() : router.presentPhotoPickerNotAuthorizedAlert()
    }
    
}

extension AddDataPresenter: AddDataInteractorToPresenterProtocol {
    func noticeQRRegistered() {
        router.presentQRRegisteredAlert()
    }
    
    func noticeFinishSavingData() {
        router.finish()
    }
    
    func noticeConvertedImageModels(results: [ImageModel]) {
        images.send(results)
    }
}

extension AddDataPresenter: AddDataRouterToPresenterProtocol {
    func notifyFinishedPickingPhoto(results: [PHPickerResult]) {
        interactor.convertPickerResultIntoImageModels(results: results)
    }
}
