//
//  DataArrayTransformer.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import CoreData

final class DataArrayTransformer: NSSecureUnarchiveFromDataTransformer {
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSData.self]
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Incorrect data type. Should be Data, but instead we're getting \(type(of: value))")
        }
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? [NSData] else {
            fatalError("Incorrect data type. Should be NSData, but instead we're getting \(type(of: value))")
        }
        return super.reverseTransformedValue(data)
    }

    static func register() {
        let className = String(describing: DataArrayTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = DataArrayTransformer()

        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
