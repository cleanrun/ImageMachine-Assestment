//
//  BaseVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine

class BaseVC: UIViewController {
    
    /// The current device's screen width
    var deviceWidth: CGFloat {
        get {
            UIScreen.main.bounds.width
        }
    }
    
    /// The current device's screen height
    var deviceHeight: CGFloat {
        get {
            UIScreen.main.bounds.height
        }
    }
    
    /// A `Set` to store any active Combine subscriptions.
    var disposables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    /// Setting up the UI based on the controller's needs.
    ///
    /// If you override this method, you MUST be sure to invoke the superclass implementation.
    func setupUI() {
        view.backgroundColor = .white
    }
    
    /// Setting up any UI bindings (i.e. subscriptions and/or observations) from the view model.
    func setupBindings() {}
    
}
