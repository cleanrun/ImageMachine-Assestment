//
//  AddDataVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

final class AddDataVC: BaseVC {
    
    private var viewModel: AddDataVM!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = AddDataVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = AddDataVM(vc: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
