//
//  UIApplication+Extension.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import UIKit

extension UIApplication {
    func getTopViewController() -> UIViewController? {
        var topVc: UIViewController? = nil
        
        for scene in connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        topVc = window.rootViewController
                    }
                }
            }
        }
        
        while true {
            if let presented = topVc?.presentedViewController {
                topVc = presented
            } else if let navController = topVc as? UINavigationController {
                topVc = navController.topViewController
            } else if let tabbBarController = topVc as? UITabBarController {
                topVc = tabbBarController.selectedViewController
            } else {
                break
            }
        }
        
        return topVc
    }
    
    func getSelectedTabNavigationController() -> UINavigationController? {
        var navVc: UINavigationController? = nil
        var tabBar: UITabBarController? = nil
        
        for scene in connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        tabBar = window.rootViewController as? UITabBarController
                    }
                }
            }
        }
        
        navVc = tabBar?.selectedViewController as? UINavigationController
        return navVc
    }
}
