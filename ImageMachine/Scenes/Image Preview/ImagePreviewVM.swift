//
//  ImagePreviewVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 22/12/22.
//

import Foundation
import Combine
import UIKit

final class ImagePreviewVM: BaseVM {
    private weak var viewController: ImagePreviewVC?
    
    @Published var imageData: Data!
    
    init(vc: ImagePreviewVC? = nil, imageData: Data) {
        self.viewController = vc
        self.imageData = imageData
    }
}

