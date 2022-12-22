//
//  DataVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import UIKit
import Combine

final class DataVM: BaseVM {
    private weak var viewController: DataVC?
    
    @Published private(set) var machines: [MachineModel] = []
    
    init(vc: DataVC? = nil) {
        self.viewController = vc
        super.init()
    }
    
    func getAllData() {
        machines = dataManager.getAllMachines()
    }
    
    func deleteData(_ id: UUID) {
        dataManager.deleteMachine(id)
    }
    
    func showDeleteConfirmationAlert(confirmHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Delete Machine",
                                      message: "Are you sure you want to delete this machine?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .destructive) { _ in
            confirmHandler()
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        viewController?.present(alert, animated: true)
    }
    
    func routeToAddData() {
        viewController?.navigationController?.pushViewController(AddDataVC(), animated: true)
    }
    
    func routeToDetailData(_ model: MachineModel) {
        viewController?.navigationController?.pushViewController(DataDetailVC(model: model), animated: true)
    }
}
