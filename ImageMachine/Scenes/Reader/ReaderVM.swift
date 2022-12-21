//
//  ReaderVM.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import Foundation
import Combine
import UIKit

final class ReaderVM: BaseVM {
    enum ReaderType {
        case detect
        case input
    }
    
    private weak var viewController: ReaderVC?
    let readerType: ReaderType
    
    init(vc: ReaderVC? = nil, type: ReaderType) {
        self.viewController = vc
        self.readerType = type
    }
    
    func detectHandler(_ value: String) {
        if let intValue = Int(value) {
            if readerType == .detect {
                viewController?.showQRResultAlert(result: intValue)
            } else {
                let presentingVc = viewController?.presentingViewController as! MainTabVC
                let navVc = presentingVc.viewControllers?.first as! UINavigationController
                let addDataVc = navVc.viewControllers.last as! AddDataVC
                addDataVc.viewModel.qrNumber = intValue
                viewController?.dismiss(animated: true)
            }
        } else {
            viewController?.showQRResultErrorAlert()
        }
    }
}
