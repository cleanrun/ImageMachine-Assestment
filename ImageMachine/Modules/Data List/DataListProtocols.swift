//
//  DataListProtocols.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import Foundation
import Combine

protocol DataListViewToPresenterProtocol: AnyObject {
    /*weak*/ var view: DataListPresenterToViewProtocol? { get set }
    var interactor: DataListPresenterToInteractorProtocol { get set }
    var router: DataListPresenterToRouterProtocol { get set }
    var machineList: CurrentValueSubject<[MachineModel], Never>! { get set }
    
    func viewDidLoadFired()
    
    func retrieveMachines()
    func deleteMachine(with id: UUID)
    func sortMachines(_ sortType: DataListVM.SortType)
    func getMachine(at index: Int) -> MachineModel
    
    func routeToAddMachine()
    func routeToMachineDetail(data: MachineModel)
    
    func showDeleteConfirmationAlert(_ id: UUID)
    func showCameraNotAuthorizedAlert()
    func showSortAlert()
}

protocol DataListInteractorToPresenterProtocol: AnyObject {
    func noticeMachinesFetched(_ machines: [MachineModel])
    func noticeMachinesDeleted(with id: UUID)
    func noticeError()
}

protocol DataListRouterToPresenter: AnyObject {
    func notifySortType(_ type: DataListVM.SortType)
    func notifyDeleteMachine(_ id: UUID)
}

protocol DataListPresenterToRouterProtocol: AnyObject {
    /*weak*/ var presenter: DataListRouterToPresenter? { get set }
    
    static func createModule() -> DataListView
    
    func pushToAddMachine()
    func pushToMachineDetail(data: MachineModel)
    
    func presentDeleteConfirmationAlert(_ id: UUID)
    func presentCameraNotAuthorizedAlert()
    func presentSortAlert()
}

protocol DataListPresenterToViewProtocol: AnyObject {
    var presenter: DataListViewToPresenterProtocol! { get set }

    func observeMachineList(subject: AnyPublisher<[MachineModel], Never>)
}

protocol DataListPresenterToInteractorProtocol: AnyObject {
    var dataManager: CoreDataManager { get }
    /*weak*/ var presenter: DataListInteractorToPresenterProtocol? { get set }
    
    func fetchMachines()
    func deleteMachine(with id: UUID)
}
