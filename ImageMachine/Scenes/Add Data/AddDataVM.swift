//
//  AddDataVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine

final class AddDataVM: BaseVM {
    
    private weak var viewController: AddDataVC?
    
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var qrNumber: Int = 0
    @Published var maintenanceDate: Date = Date()
    @Published var images: [UIImage] = []
    
    var validation: AnyPublisher<Bool, Never> {
        Publishers
            .CombineLatest4($name, $type, $qrNumber, $images)
            .allSatisfy { nameValue, typeValue, qrValue, imagesValue in
                (!nameValue.isEmpty) && (!typeValue.isEmpty) && (qrValue != 0) && (!imagesValue.isEmpty)
        }.eraseToAnyPublisher()
    }
    
    init(vc: AddDataVC? = nil) {
        self.viewController = vc
    }
    
    func saveMachine() {
        let transformedArray = images.transformToData()
        let machine = MachineModel(name: name, type: type, qrNumber: qrNumber, maintenanceDate: maintenanceDate, images: transformedArray)
        dataManager.saveMachine(machine)
    }
    
    func presentQrReader() {
        let vc = ReaderVC(type: .input)
        viewController?.present(vc, animated: true)
    }
}
