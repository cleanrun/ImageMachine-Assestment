//
//  ReaderVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine

final class ReaderVM: BaseVM {
    weak var viewController: ReaderVC?
    
    init(vc: ReaderVC? = nil) {
        self.viewController = vc
    }
}
