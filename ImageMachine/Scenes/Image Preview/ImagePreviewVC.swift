//
//  ImagePreviewVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 22/12/22.
//

import UIKit

final class ImagePreviewVC: BaseVC {
    
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
    
    private var viewModel: ImagePreviewVM!
    
    init(imageData: Data) {
        super.init(nibName: nil, bundle: nil)
        viewModel = ImagePreviewVM(vc: self, imageData: imageData)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
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
    
    override func setupBindings() {
        viewModel
            .$imageData
            .sink { [unowned self] value in
                self.imageView.image = value?.createDownsampledImage(to: CGSize(width: 800, height: 800))
            }.store(in: &disposables)
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }

}
