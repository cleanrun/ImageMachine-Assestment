//
//  CoreDataManager.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    /// The current singleton instance of the manager.
    static let current = CoreDataManager()
    
    private let stack: CoreDataStack
    let managedContext: NSManagedObjectContext
    
    private init() {
        stack = CoreDataStack()
        managedContext = stack.managedContext
        DataArrayTransformer.register()
    }
    
    /// Saving a Machine model into CoreData model
    /// - Parameter machine: The Machine model object to save
    func saveMachine(_ machine: MachineModel) {
        let enitity = machine.asEntity(with: managedContext)
        stack.saveContext()
    }
    
    /// Getting all of the saved Machines objects
    /// - Returns: Returns all of the Machine model objects
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
