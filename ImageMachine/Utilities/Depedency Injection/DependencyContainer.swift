//
//  DependencyContainer.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import Foundation

public class DependencyContainer {
    private static var current = DependencyContainer()
    
    public static subscript<K>(key: K.Type) -> K.Value where K: DependencyKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    public static subscript<T>(_ keyPath: WritableKeyPath<DependencyContainer, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
    
    public static func setDepedency<K>(initialValue: K.Value, key: K.Type) where K: DependencyKey {
        key.currentValue = initialValue
    }
}

extension DependencyContainer {
    var dataManager: CoreDataManager {
        get { Self.self[CoreDataManagerDependencyKey.self] }
        set { Self.self[CoreDataManagerDependencyKey.self] = newValue }
    }
}
