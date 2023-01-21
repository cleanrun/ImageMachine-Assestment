//
//  MachineModel.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import CoreData

struct MachineModel: Hashable {
    let machineId: UUID
    let name: String
    let type: String
    let qrNumber: Int
    let maintenanceDate: Date
    var imageFileNames: [String]
    
    init(machineId: UUID = UUID(), name: String, type: String, qrNumber: Int, maintenanceDate: Date, imageFileNames: [String] = []) {
        self.machineId = machineId
        self.name = name
        self.type = type
        self.qrNumber = qrNumber
        self.maintenanceDate = maintenanceDate
        self.imageFileNames = imageFileNames
    }
    
    init(from entity: MachineEntity) {
        self.machineId = entity.machineId!
        self.name = entity.name!
        self.type = entity.type!
        self.qrNumber = Int(entity.qrNumber)
        self.maintenanceDate = entity.maintenanceDate!
        self.imageFileNames = (entity.imageFileNames?.compactMap {
            $0 as String
        })!
    }
    
    mutating func setImageFileNames(names: [String]) {
        self.imageFileNames = names
    }
}

extension MachineModel {
    
    func asEntity(with context: NSManagedObjectContext) -> MachineEntity {
        let transformedImages = imageFileNames.compactMap {
            NSString(string: $0)
        }
        
        let entity = MachineEntity(context: context)
        entity.setValue(machineId, forKey: #keyPath(MachineEntity.machineId))
        entity.setValue(name, forKey: #keyPath(MachineEntity.name))
        entity.setValue(type, forKey: #keyPath(MachineEntity.type))
        entity.setValue(Int64(qrNumber), forKey: #keyPath(MachineEntity.qrNumber))
        entity.setValue(maintenanceDate, forKey: #keyPath(MachineEntity.maintenanceDate))
        entity.setValue(transformedImages, forKey: #keyPath(MachineEntity.imageFileNames))
        return entity
    }
}
