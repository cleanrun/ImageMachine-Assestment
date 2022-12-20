//
//  AddDataVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation

final class AddDataVM: BaseVM {
    
    private weak var viewController: AddDataVC?
    
    init(vc: AddDataVC? = nil) {
        self.viewController = vc
    }
}
