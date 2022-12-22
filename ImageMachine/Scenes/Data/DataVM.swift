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
    
    enum SortType {
        case nameAscending
        case nameDescending
        case typeAscending
        case typeDescending
        case defaultOrder
    }
    
    private weak var viewController: DataVC?
    
    @Published private(set) var machines: [MachineModel] = []
    @Published var sortType: SortType = .defaultOrder
    
    init(vc: DataVC? = nil) {
        self.viewController = vc
        super.init()
        
        $sortType.sink { [unowned self] _ in
            self.sortData()
        }.store(in: &disposables)
    }
    
    func getAllData() {
        sortType = .defaultOrder
        machines = dataManager.getAllMachines()
    }
    
    func deleteData(_ id: UUID) {
        dataManager.deleteMachine(id)
    }
    
    func sortData() {
        switch sortType {
        case .defaultOrder:
            break
        case .nameAscending:
            machines = machines.sorted(by: { $0.name > $1.name })
        case .nameDescending:
            machines = machines.sorted(by: { $0.name < $1.name })
        case .typeAscending:
            machines = machines.sorted(by: { $0.type > $1.type })
        case .typeDescending:
            machines = machines.sorted(by: { $0.type < $1.type })
        }
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
    
    func showCameraNotAuthorizedAlert() {
        let alert = UIAlertController(title: "Missing camera permission",
                                      message: "To add a new Machine data, please grant the camera permission for this app.",
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
    
    func showSortAlert() {
        let alert = UIAlertController(title: nil,
                                      message: "Select sort method",
                                      preferredStyle: .actionSheet)
        let nameAscAction = UIAlertAction(title: "Name (Ascending)", style: .default) { [unowned self] _ in
            self.sortType = .nameAscending
        }
        let nameDscAction = UIAlertAction(title: "Name (Descending)", style: .default) { [unowned self] _ in
            self.sortType = .nameDescending
        }
        let typeAscAction = UIAlertAction(title: "Type (Ascending)", style: .default) { [unowned self] _ in
            self.sortType = .typeAscending
        }
        let typeDscAction = UIAlertAction(title: "Type (Descending)", style: .default) { [unowned self] _ in
            self.sortType = .typeDescending
        }
        alert.addAction(nameAscAction)
        alert.addAction(nameDscAction)
        alert.addAction(typeAscAction)
        alert.addAction(typeDscAction)
        viewController?.present(alert, animated: true)
    }
    
    func routeToAddData() {
        viewController?.navigationController?.pushViewController(AddDataVC(), animated: true)
    }
    
    func routeToDetailData(_ model: MachineModel) {
        viewController?.navigationController?.pushViewController(DataDetailVC(model: model), animated: true)
    }
}
