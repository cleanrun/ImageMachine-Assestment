//
//  DependencyKey.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import Foundation

public protocol DependencyKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}
