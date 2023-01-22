//
//  DataListPresenter.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import Foundation
import Combine

final class DataListPresenter: DataListViewToPresenterProtocol {
    weak var view: DataListPresenterToViewProtocol?
    var interactor: DataListPresenterToInteractorProtocol
    var router: DataListPresenterToRouterProtocol
    var machineList: CurrentValueSubject<[MachineModel], Never>! = CurrentValueSubject([])
    
    init(view: DataListPresenterToViewProtocol,
         interactor: DataListPresenterToInteractorProtocol,
         router: DataListPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoadFired() {
        view?.observeMachineList(subject: machineList.eraseToAnyPublisher())
    }
    
    func retrieveMachines() {
        interactor.fetchMachines()
    }
    
    func deleteMachine(with id: UUID) {
        var updatedValue = machineList.value
        updatedValue.removeAll(where: { $0.machineId == id })
        machineList.send(updatedValue)
        interactor.deleteMachine(with: id)
    }
    
    func sortMachines(_ sortType: SortType) {
        var sortedMachines: [MachineModel] = []
        switch sortType {
        case .defaultOrder:
            break
        case .nameAscending:
            sortedMachines = machineList.value.sorted(by: { $0.name > $1.name })
        case .nameDescending:
            sortedMachines = machineList.value.sorted(by: { $0.name < $1.name })
        case .typeAscending:
            sortedMachines = machineList.value.sorted(by: { $0.type > $1.type })
        case .typeDescending:
            sortedMachines = machineList.value.sorted(by: { $0.type < $1.type })
        }
        
        machineList.send(sortedMachines)
    }
    
    func getMachine(at index: Int) -> MachineModel {
        machineList.value[index]
    }
    
    func routeToAddMachine() {
        router.pushToAddMachine()
    }
    
    func routeToMachineDetail(data: MachineModel) {
        router.pushToMachineDetail(data: data)
    }
    
    func showDeleteConfirmationAlert(_ id: UUID) {
        router.presentDeleteConfirmationAlert(id)
    }
    
    func showCameraNotAuthorizedAlert() {
        router.presentCameraNotAuthorizedAlert()
    }
    
    func showSortAlert() {
        router.presentSortAlert()
    }
    
}

extension DataListPresenter: DataListInteractorToPresenterProtocol {
    func noticeMachinesFetched(_ machines: [MachineModel]) {
        machineList.send(machines)
    }
    
    func noticeMachinesDeleted(with id: UUID) {
        deleteMachine(with: id)
    }
    
    func noticeError() {
        // FIXME: Handle error here
    }
}

extension DataListPresenter: DataListRouterToPresenter {
    func notifyDeleteMachine(_ id: UUID) {
        interactor.deleteMachine(with: id)
    }
    
    func notifySortType(_ type: SortType) {
        sortMachines(type)
    }
}
