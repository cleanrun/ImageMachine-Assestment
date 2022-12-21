//
//  BaseVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine

class BaseVC: UIViewController {
    
    var deviceWidth: CGFloat {
        get {
            UIScreen.main.bounds.width
        }
    }
    
    var deviceHeight: CGFloat {
        get {
            UIScreen.main.bounds.height
        }
    }
    
    var disposables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func setupBindings() {}
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
