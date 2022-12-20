//
//  CoreDataManager.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let current = CoreDataManager()
    
    private let stack: CoreDataStack
    let managedContext: NSManagedObjectContext
    
    private init() {
        stack = CoreDataStack()
        managedContext = stack.managedContext
    }
    
    func saveMachine(_ machine: MachineModel) {
        let enitity = machine.asEntity(with: managedContext)
        stack.saveContext()
    }
    
    func getAllMachines() -> [MachineModel] {
        let fetchRequest: NSFetchRequest<MachineEntity> = MachineEntity.fetchRequest()
        var requestResult = [MachineModel]()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if !results.isEmpty {
                requestResult = results.map {
                    MachineModel(from: $0)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return requestResult
    }
}
