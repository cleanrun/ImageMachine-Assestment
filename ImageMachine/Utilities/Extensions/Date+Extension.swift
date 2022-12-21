//
//  Date+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 21/12/22.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
