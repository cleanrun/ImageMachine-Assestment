//
//  ReaderVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

final class ReaderVC: BaseVC {

    private var viewModel: ReaderVM!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = ReaderVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = ReaderVM(vc: self)
    }
    
    override func setupUI() {
        super.setupUI()
    }
    
    override func setupBindings() {
        
    }
}
