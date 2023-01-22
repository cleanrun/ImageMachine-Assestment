//
//  CoreDataManager.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import CoreData

struct CoreDataManagerDependencyKey: DependencyKey {
    static var currentValue: CoreDataManager = CoreDataManager()
}

struct CoreDataManager {
    private let stack: CoreDataStack
    let managedContext: NSManagedObjectContext
    
    init() {
        stack = CoreDataStack()
        managedContext = stack.managedContext
    }
    
    func saveMachine(_ machine: MachineModel) {
        let enitity = machine.asEntity(with: managedContext)
        stack.saveContext()
    }
    
    func deleteMachine(_ id: UUID) {
        if let entity = findMachine(byId: id) {
            for imageFileName in entity.imageFileNames! {
                deleteStoredImage(for: imageFileName as String)
            }
            managedContext.delete(entity)
            stack.saveContext()
        }
    }
    
    func findMachine(byId machineId: UUID) -> MachineEntity? {
        let fetchRequest: NSFetchRequest<MachineEntity> = MachineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "machineId == %@", machineId as NSUUID)
        
        var result: MachineEntity? = nil
        
        do {
            result = try managedContext.fetch(fetchRequest).first
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func findMachine(byQrNumber qrNumber: Int) -> MachineEntity? {
        let fetchRequest: NSFetchRequest<MachineEntity> = MachineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "qrNumber == %d", Int64(qrNumber))
        
        var result: MachineEntity? = nil
        
        do {
            result = try managedContext.fetch(fetchRequest).first
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func checkIfMachineExists(for qrNumber: Int) -> Bool {
        findMachine(byQrNumber: qrNumber) != nil
    }
    
    func editMachine(_ model: MachineModel) {
        if let entity = findMachine(byId: model.machineId) {
            entity.setValue(model.name, forKey: #keyPath(MachineEntity.name))
            entity.setValue(model.type, forKey: #keyPath(MachineEntity.type))
            entity.setValue(model.maintenanceDate, forKey: #keyPath(MachineEntity.maintenanceDate))
            entity.setValue(model.imageFileNames, forKey: #keyPath(MachineEntity.imageFileNames))
            stack.saveContext()
        }
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
    
    func deleteStoredImage(for id: String) {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(id)
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
