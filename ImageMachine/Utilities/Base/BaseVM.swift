//
//  BaseVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine

class BaseVM: ObservableObject {
    var disposables = Set<AnyCancellable>()
    var dataManager = CoreDataManager.current
}
