//
//  DataVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

final class DataVC: BaseVC {
    
    private var dataTableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var viewModel: DataVM!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = DataVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = DataVM(vc: self)
    }
    
    override func setupUI() {
        super.setupUI()
        title = "Data"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAction))
        
//        dataTableView.delegate = self
//        dataTableView.dataSource = self
        view.addSubview(dataTableView)
        
        NSLayoutConstraint.activate([
            dataTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            dataTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            dataTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            dataTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    override func setupBindings() {
        
    }
    
    @objc private func addAction() {
        let image = UIImage(named: "swiftlogo")!
        let imageArray: Array<UIImage> = [image, image]
        let transformedArray = imageArray.transformToData()
        let currentManager = CoreDataManager.current
        
        let model = MachineModel(name: "Test", type: "Test", qrNumber: 1234, maintenanceDate: Date(), images: transformedArray)
        currentManager.saveMachine(model)
    }
    
    @objc private func sortAction() {
        
    }
}

extension DataVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
