//
//  DataListInteractor.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import Foundation

final class DataListInteractor: DataListPresenterToInteractorProtocol {
    @Dependency(\.dataManager) var dataManager: CoreDataManager
    weak var presenter: DataListInteractorToPresenterProtocol?
    
    func fetchMachines() {
        let machines = dataManager.getAllMachines()
        presenter?.noticeMachinesFetched(machines)
    }
    
    func deleteMachine(with id: UUID) {
        dataManager.deleteMachine(id)
        presenter?.noticeMachinesDeleted(with: id)
    }
    
}
