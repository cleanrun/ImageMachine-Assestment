//
//  AddDataInteractor.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation
import PhotosUI

final class AddDataInteractor: AddDataPresenterToInteractorProtocol {
    @Dependency(\.dataManager) var dataManager: CoreDataManager
    weak var presenter: AddDataInteractorToPresenterProtocol?
    
    func saveData(model: MachineModel, images: [ImageModel]) {
        guard !dataManager.checkIfMachineExists(for: model.qrNumber) else {
            presenter?.noticeQRRegistered()
            return
        }

        for image in images {
            do {
                try image.imageData.storeToDisk(id: image.id)
            } catch {
                print(error.localizedDescription)
                return
            }
        }

        let imageFileNames = images.compactMap { $0.id }
        var machine = MachineModel(name: model.name, type: model.type, qrNumber: model.qrNumber, maintenanceDate: model.maintenanceDate)
        machine.setImageFileNames(names: imageFileNames)
        dataManager.saveMachine(machine)
        presenter?.noticeFinishSavingData()
    }
    
    func convertPickerResultIntoImageModels(results: [PHPickerResult]) {
        var imageArray = [ImageModel]()
        let imageItems = results.compactMap { $0.assetIdentifier }
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: imageItems, options: nil)
        fetchResult.enumerateObjects { object, index, stop in
            let imageModel = ImageModel(id: "image_\(UUID().uuidString)", imageData: object.uiImage.jpegData(compressionQuality: 0.5)!)
            imageArray.append(imageModel)
        }
        presenter?.noticeConvertedImageModels(results: imageArray)
    }
}
