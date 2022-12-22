//
//  URL+Extension.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 22/12/22.
//

import Foundation

extension URL {
    static func getImageURL(id: String) -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(id)
    }
}
