//
//  BaseVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit
import Combine
import AVFoundation

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
    }
    
    func setupBindings() {}
    
    func dismissKeyboardWhenViewIsTapped() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardHandler)))
    }
    
    @objc private func dismissKeyboardHandler() {
        view.endEditing(true)
    }
    
    func checkIfCameraIsAuthorized() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
}
