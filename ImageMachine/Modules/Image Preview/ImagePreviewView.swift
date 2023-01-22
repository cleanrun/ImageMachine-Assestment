//
//  ImagePreviewView.swift
//  ImageMachine
//
//  Created by cleanmac on 22/01/23.
//

import UIKit
import Combine

final class ImagePreviewView: BaseVC, ImagePreviewPresenterToViewProtocol {
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    var presenter: ImagePreviewViewToPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoadFired()
    }
    
    override func loadView() {
        super.loadView()
        super.setupUI()
        
        view.addSubviews(navigationBar, imageView)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            navigationBar.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 50),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
        ])
        
        let navigationItem = UINavigationItem()
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissModal))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationBar.items = [navigationItem]
    }
    
    func observeImage(image: AnyPublisher<UIImage?, Never>) {
        image
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                self.imageView.image = value
            }.store(in: &disposables)
    }
    
    @objc private func dismissModal() {
        presenter.dismiss()
    }

}
