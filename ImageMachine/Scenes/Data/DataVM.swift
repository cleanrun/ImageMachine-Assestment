//
//  DataVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine

final class DataVM: BaseVM {
    private weak var viewController: DataVC?
    
    init(vc: DataVC? = nil) {
        self.viewController = vc
    }
    
    func routeToAddData() {
        
    }
}
