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
    
    @Published var formType: DetailFormType = .detail
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var qrNumber: Int = 0
    @Published var maintenanceDate: Date = Date()
    @Published var images: [Data] = []
    
    init(vc: DataDetailVC? = nil, model: MachineModel) {
        self.viewController = vc
        self.model = model
        
        self.name = model.name
        self.type = model.type
        self.qrNumber = model.qrNumber
        self.maintenanceDate = model.maintenanceDate
        self.images = model.images
    }
    
    func saveEdittedData() {
        let edittedModel = MachineModel(machineId: model.machineId,
                                        name: name,
                                        type: type,
                                        qrNumber: model.qrNumber,
                                        maintenanceDate: maintenanceDate,
                                        images: images)
        dataManager.editMachine(edittedModel)
    }
    
    func showImagePreviewModal(forImageAt indexPathRow: Int) {
        let imageData = images[indexPathRow]
        let vc = ImagePreviewVC(imageData: imageData)
        viewController?.present(vc, animated: true)
    }
}
