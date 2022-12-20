//
//  BaseVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine

class BaseVM: ObservableObject {
    /// A `Set` to store any active Combine subscriptions.
    var disposables = Set<AnyCancellable>()
}
