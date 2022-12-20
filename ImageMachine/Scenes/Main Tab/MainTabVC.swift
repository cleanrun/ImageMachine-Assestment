//
//  MainTabVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

final class MainTabVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createNavController(for: DataVC(), title: "Data", icon: "list.bullet"),
            createNavController(for: ReaderVC(type: .detect), title: "Reader", icon: "qrcode.viewfinder")
        ]
        
        tabBar.isTranslucent = true
    }
    
    private func createNavController(for vc: UIViewController,
                                     title: String,
                                     icon: String) -> UINavigationController {
        let imageIcon = UIImage(systemName: icon)
        let tabBarItem = UITabBarItem(title: title,
                                      image: imageIcon,
                                      selectedImage: imageIcon)
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = tabBarItem
        return navController
    }
}
