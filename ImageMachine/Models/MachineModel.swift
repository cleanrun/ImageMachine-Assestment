//
//  MachineModel.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation

struct MachineModel {
    let machineId: UUID
    let name: String
    let type: String
    let qrNumber: Int
    let maintenanceDate: Date
    let images: [Data]
}
