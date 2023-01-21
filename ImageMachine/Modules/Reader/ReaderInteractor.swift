//
//  ReaderInteractor.swift
//  ImageMachine
//
//  Created by cleanmac on 21/01/23.
//

import Foundation

final class ReaderInteractor: ReaderPresenterToInteractorProtocol {
    @Dependency(\.dataManager) var dataManager: CoreDataManager
    weak var presenter: ReaderInteractorToPresenterProtocol?
    
    func checkDetectedCode(type: ReaderVM.ReaderType, _ value: String) {
        if let qrNumber = Int(value) {
            if type == .detect {
                if let entity = dataManager.findMachine(byQrNumber: qrNumber) {
                    presenter?.noticeQRRegistered(MachineModel(from: entity))
                } else {
                    presenter?.noticeQRNotRegistered(detectedQr: qrNumber)
                }
            } else {
                presenter?.noticeQRDetectedForFillingNewData(detectedQr: qrNumber)
            }
        } else {
            presenter?.noticeQRResultError()
        }
    }
    
}
