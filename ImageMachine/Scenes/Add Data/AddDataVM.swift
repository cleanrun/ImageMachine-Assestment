//
//  AddDataVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine
import PhotosUI

final class AddDataVM: BaseVM {
    private weak var viewController: AddDataVC?
    private var photoPickerConfig: PHPickerConfiguration
    
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var qrNumber: Int = 0
    @Published var maintenanceDate: Date = Date()
    @Published var images: [UIImage] = []
    
    lazy var validation: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest4($name, $type, $qrNumber, $images)
            .map { nameValue, typeValue, qrValue, imagesValue in
                (!nameValue.isEmpty) && (!typeValue.isEmpty) && (qrValue != 0) && (!imagesValue.isEmpty)
            }.eraseToAnyPublisher()
    }()
    
    init(vc: AddDataVC? = nil) {
        self.viewController = vc
        
        photoPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        photoPickerConfig.selectionLimit = 10
        photoPickerConfig.filter = .images
    }
    
    func saveMachine() {
        let transformedArray = images.transformToData()
        let machine = MachineModel(name: name, type: type, qrNumber: qrNumber, maintenanceDate: maintenanceDate, images: transformedArray)
        dataManager.saveMachine(machine)
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func presentQrReader() {
        let vc = ReaderVC(type: .input)
        viewController?.present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = PHPickerViewController(configuration: photoPickerConfig)
        vc.delegate = self
        viewController?.present(vc, animated: true)
    }
}

extension AddDataVM: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) { [unowned self] in
            self.images.removeAll()
            let imageItems = results.compactMap { $0.assetIdentifier }
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: imageItems, options: nil)
            fetchResult.enumerateObjects { object, index, stop in
                self.images.append(object.uiImage)
            }
        }
    }
}
