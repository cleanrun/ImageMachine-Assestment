//
//  DataDetailVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 22/12/22.
//

import Foundation
import Combine
import UIKit

final class DataDetailVM: BaseVM {
    enum DetailFormType {
        case detail
        case edit
    }
    
    private weak var viewController: DataDetailVC?
    private(set) var model: MachineModel
    
    private(set) var formType: CurrentValueSubject<DetailFormType, Never>
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var qrNumber: Int = 0
    @Published var maintenanceDate: Date = Date()
    private(set) var images: CurrentValueSubject<[ImageModel], Never>
    
    init(vc: DataDetailVC? = nil, model: MachineModel) {
        self.viewController = vc
        self.model = model
        
        self.name = model.name
        self.type = model.type
        self.qrNumber = model.qrNumber
        self.maintenanceDate = model.maintenanceDate
        let imageModels = model.imageFileNames.compactMap {
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
        self.images = CurrentValueSubject(imageModels)
        self.formType = CurrentValueSubject(.detail)
    }
    
    func saveEdittedData() {
        let edittedModel = MachineModel(machineId: model.machineId,
                                        name: name,
                                        type: type,
                                        qrNumber: model.qrNumber,
                                        maintenanceDate: maintenanceDate,
                                        imageFileNames: images.value.map { $0.id } )
        dataManager.editMachine(edittedModel)
    }
    
    private func deleteImage(_ model: ImageModel) {
        var updatedImages = images.value
        updatedImages.removeAll(where: { $0.id == model.id })
        images.send(updatedImages)
        dataManager.deleteStoredImage(for: model.id)
    }
    
    func showImagePreviewModal(forImageAt indexPathRow: Int) {
        let imageData = images.value[indexPathRow].imageData
        let vc = ImagePreviewVC(imageData: imageData)
        viewController?.present(vc, animated: true)
    }
    
    private func showDeleteImageAlert(for model: ImageModel) {
        let alert = UIAlertController(title: "Delete Image",
                                      message: "Are you sure you want to delete this image?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .destructive) { [unowned self] _ in
            self.deleteImage(model)
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        viewController?.present(alert, animated: true)
    }
}

extension DataDetailVM: ImageCellDelegate {
    func onDelete(for model: ImageModel) {
        showDeleteImageAlert(for: model)
    }
}
