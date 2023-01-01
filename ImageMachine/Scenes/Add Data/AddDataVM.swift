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
    private(set) var photoLibraryAuthorizationStatus: PHAuthorizationStatus!
    
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var qrNumber: Int = 0
    @Published var maintenanceDate: Date = Date()
    private(set) var images = CurrentValueSubject<[ImageModel], Never>([])
    
    lazy var validation: AnyPublisher<Bool, Never> = {
        Publishers
            .CombineLatest4($name, $type, $qrNumber, images)
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
        guard !dataManager.checkIfMachineExists(for: qrNumber) else {
            showQrRegisteredAlert()
            return
        }
        
        for image in images.value {
            do {
                try image.imageData.storeToDisk(id: image.id)
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        
        let imageFileNames = images.value.compactMap { $0.id }
        let machine = MachineModel(name: name, type: type, qrNumber: qrNumber, maintenanceDate: maintenanceDate, imageFileNames: imageFileNames)
        dataManager.saveMachine(machine)
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func requestPhotoLibraryAuthorization() {
        photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if photoLibraryAuthorizationStatus != .authorized {
            PHPhotoLibrary.requestAuthorization { [unowned self] status in
                self.photoLibraryAuthorizationStatus = status
            }
        }
    }
    
    private func showCameraNotAuthorizedAlert() {
        let alert = UIAlertController(title: "Missing photo library permission",
                                      message: "To add a new Machine data, please grant the photo library permission for all photos for this app.",
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go To Settings",
                                   style: .default) { [unowned self] _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            self.viewController?.tabBarController?.selectedIndex = 0
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                   style: .cancel) { [unowned self] _ in
            self.viewController?.tabBarController?.selectedIndex = 0
        }
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        viewController?.present(alert, animated: true)
    }
    
    private func showQrRegisteredAlert() {
        let alert = UIAlertController(title: "QR code is already registered",
                                      message: "This QR code is already registered, please change to other QR code.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                   style: .cancel)
        alert.addAction(okAction)
        viewController?.present(alert, animated: true)
    }
    
    func presentQrReader() {
        let vc = ReaderVC(type: .input)
        viewController?.present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        if photoLibraryAuthorizationStatus == .authorized {
            let vc = PHPickerViewController(configuration: photoPickerConfig)
            vc.delegate = self
            viewController?.present(vc, animated: true)
        } else {
            showCameraNotAuthorizedAlert()
        }
    }
}

extension AddDataVM: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) { [unowned self] in
            self.images.send([])
            var imageArray = [ImageModel]()
            let imageItems = results.compactMap { $0.assetIdentifier }
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: imageItems, options: nil)
            fetchResult.enumerateObjects { object, index, stop in
                let imageModel = ImageModel(id: "image_\(UUID().uuidString)", imageData: object.uiImage.jpegData(compressionQuality: 0.5)!)
                imageArray.append(imageModel)
            }
            self.images.send(imageArray)
        }
    }
}

extension AddDataVM: ImageCellDelegate {
    func onDelete(for model: ImageModel) {
        var updatedArray = images.value
        updatedArray.removeAll(where: { $0.id == model.id })
        images.send(updatedArray)
    }
}
