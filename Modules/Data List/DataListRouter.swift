//
//  DataListRouter.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import UIKit

final class DataListRouter: DataListPresenterToRouterProtocol {
    var presenter: DataListRouterToPresenter?
    
    static func createModule() -> DataListView {
        let view = DataListView()
        let interactor = DataListInteractor()
        let router = DataListRouter()
        let presenter = DataListPresenter(view: view,
                                          interactor:
                                            interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
    
    func pushToAddMachine(using navController: UINavigationController) {
        
    }
    
    func pushToMachineDetail(using navController: UINavigationController, _ data: MachineModel) {
        
    }
    
    func presentDeleteConfirmationAlert() {
        let alert = UIAlertController(title: "Delete Machine",
                                      message: "Are you sure you want to delete this machine?",
                                      preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .destructive) { _ in
            //confirmHandler()
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
    func presentCameraNotAuthorizedAlert() {
        let alert = UIAlertController(title: "Missing camera permission",
                                      message: "To add a new Machine data, please grant the camera permission for this app.",
                                      preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go To Settings",
                                   style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            UIApplication.shared.getTopViewController()?.tabBarController?.selectedIndex = 0
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                   style: .cancel) { _ in
            UIApplication.shared.getTopViewController()?.tabBarController?.selectedIndex = 0
        }
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
    func presentSortAlert() {
        let alert = UIAlertController(title: nil,
                                      message: "Select sort method",
                                      preferredStyle: .actionSheet)
        let nameAscAction = UIAlertAction(title: "Name (Ascending)", style: .default) { [unowned self] _ in
            self.presenter?.notifySortType(.nameAscending)
        }
        let nameDscAction = UIAlertAction(title: "Name (Descending)", style: .default) { [unowned self] _ in
            self.presenter?.notifySortType(.nameDescending)
        }
        let typeAscAction = UIAlertAction(title: "Type (Ascending)", style: .default) { [unowned self] _ in
            self.presenter?.notifySortType(.typeAscending)
        }
        let typeDscAction = UIAlertAction(title: "Type (Descending)", style: .default) { [unowned self] _ in
            self.presenter?.notifySortType(.typeDescending)
        }
        alert.addAction(nameAscAction)
        alert.addAction(nameDscAction)
        alert.addAction(typeAscAction)
        alert.addAction(typeDscAction)
        UIApplication.shared.getTopViewController()?.present(alert, animated: true)
    }
    
}
