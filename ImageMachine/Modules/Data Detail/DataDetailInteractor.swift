//
//  DataDetailInteractor.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation

final class DataDetailInteractor: DataDetailPresenterToInteractorProtocol {
    @Dependency(\.dataManager) var dataManager: CoreDataManager
    weak var presenter: DataDetailInteractorToPresenterProtocol?
    
    func retrieveImagesFromDisk(_ names: [String]) {
        let imageModels = names.compactMap {
            if let url = URL.getImageURL(id: $0) {
                if let data = NSData(contentsOf: url) {
                    return ImageModel(id: $0, imageData: Data(referencing: data))
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        presenter?.noticeImageRetrieved(imageModels)
    }
    
    func saveEdittedData(_ model: MachineModel) {
        dataManager.editMachine(model)
        presenter?.noticeDataEditted()
    }
    
    func deleteImage(_ model: ImageModel) {
        dataManager.deleteStoredImage(for: model.id)
        presenter?.noticeImageDeleted(model)
    }
}
