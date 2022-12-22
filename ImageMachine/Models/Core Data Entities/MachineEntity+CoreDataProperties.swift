//
//  MachineEntity+CoreDataProperties.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//
//

import Foundation
import CoreData

extension MachineEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MachineEntity> {
        return NSFetchRequest<MachineEntity>(entityName: "MachineEntity")
    }

    @NSManaged public var machineId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var qrNumber: Int64
    @NSManaged public var maintenanceDate: Date?
    @NSManaged public var imageFileNames: [NSString]?

}

extension MachineEntity : Identifiable {

}
