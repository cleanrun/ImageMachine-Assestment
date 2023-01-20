//
//  DataListProtocols.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import UIKit
import Combine

protocol DataListViewToPresenterProtocol: AnyObject {
    var view: DataListPresenterToViewProtocol? { get set }
    var interactor: DataListPresenterToInteractorProtocol { get set }
    var router: DataListPresenterToRouterProtocol { get set }
    var machineList: CurrentValueSubject<[MachineModel], Never>! { get set }
    
    func retrieveMachines()
    func deleteMachine(with id: UUID)
    func sortMachines(_ sortType: DataListVM.SortType)
    func getMachine(at index: Int) -> MachineModel
    
    func routeToAddMachine(using navController: UINavigationController)
    func routeToMachineDetail(using navController: UINavigationController,
                              _ data: MachineModel)
    
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
    var presenter: DataListRouterToPresenter? { get set }
    
    static func createModule() -> DataListView
    
    func pushToAddMachine(using navController: UINavigationController)
    func pushToMachineDetail(using navController: UINavigationController,
                             _ data: MachineModel)
    
    func presentDeleteConfirmationAlert(_ id: UUID)
    func presentCameraNotAuthorizedAlert()
    func presentSortAlert()
}

protocol DataListPresenterToViewProtocol: AnyObject {
    var presenter: DataListViewToPresenterProtocol! { get set }
    
    func observeMachineList(subject: CurrentValueSubject<[MachineModel], Never>)
}

protocol DataListPresenterToInteractorProtocol: AnyObject {
    var dataManager: CoreDataManager { get }
    var presenter: DataListInteractorToPresenterProtocol? { get set }
    
    func fetchMachines()
    func deleteMachine(with id: UUID)
}
