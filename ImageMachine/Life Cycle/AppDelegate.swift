//
//  AppDelegate.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 19/12/22.
//

import UIKit
import AVFoundation

@main final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataArrayTransformer.register()
        setupDependencies()
        requestCameraPermission()
        return true
    }
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            
        })
    }
    
    private func setupDependencies() {
        DependencyContainer.setDepedency(initialValue: CoreDataManager(),
                                         key: CoreDataManagerDependencyKey.self)
    }
}

