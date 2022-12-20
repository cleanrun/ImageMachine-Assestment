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
    
    /// Setting up the view controllers required for the tab bar to display
    private func setupViewControllers() {
        viewControllers = [
            createNavController(for: DataVC(), title: "Data", icon: "list.bullet.clipboard"),
            createNavController(for: ReaderVC(), title: "Reader", icon: "qrcode.viewfinder")
        ]
    }
    
    /// Creates a `UINavigationController` for managing the tab navigation flow.
    /// - Parameters:
    ///   - vc: The root view controller of the navigation controller
    ///   - title: The `UITabBarItem` title for displaying the title on the tab bar
    ///   - icon: The `UITabBarItem` system image name for displaying the title on the tab bar
    /// - Returns: Returns the navigaton controller
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
