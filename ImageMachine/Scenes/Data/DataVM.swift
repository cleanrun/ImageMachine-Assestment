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
    
    @Published private(set) var machines: [MachineModel] = []
    
    init(vc: DataVC? = nil) {
        self.viewController = vc
        super.init()
    }
    
    func getAllData() {
        machines = dataManager.getAllMachines()
    }
    
    func routeToAddData() {
        viewController?.navigationController?.pushViewController(AddDataVC(), animated: true)
    }
    
    func routeToDetailData() {
        
    }
}
