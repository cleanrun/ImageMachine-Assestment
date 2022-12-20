//
//  ViewControllerPreviewProvider.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import SwiftUI

struct ViewControllerPreviewProvider: UIViewControllerRepresentable {
    private let viewController: UIViewController
    
    init(using vc: UIViewController) {
        viewController = vc
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Do Nothing
    }
    
}
