//
//  AddDataVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine

final class AddDataVM: BaseVM {
    
    private weak var viewController: AddDataVC?
    
    @Published var name: String = ""
    @Published var type: String = ""
    @Published var qrNumber: Int = 0
    @Published var maintenanceDate: Date = Date()
    @Published var images: [UIImage] = []
    
    init(vc: AddDataVC? = nil) {
        self.viewController = vc
    }
}
