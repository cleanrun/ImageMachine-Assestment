//
//  ReaderVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine

final class ReaderVM: BaseVM {
    enum ReaderType {
        case detect
        case input
    }
    
    private weak var viewController: ReaderVC?
    private let readerType: ReaderType
    
    init(vc: ReaderVC? = nil, type: ReaderType) {
        self.viewController = vc
        self.readerType = type
    }
}
