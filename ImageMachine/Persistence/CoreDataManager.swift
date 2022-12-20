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
    }
}
