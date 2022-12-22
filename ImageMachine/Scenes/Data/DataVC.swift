//
//  DataVC.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

final class DataVC: BaseVC {
    
    private typealias DataSource = DataTableViewDiffableDataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MachineModel>
    
    private var dataTableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private var viewModel: DataVM!
    private var dataSource: DataSource!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = DataVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = DataVM(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "Data"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(sortAction))
        
        dataTableView.delegate = self
        dataTableView.register(DataListCell.self,
                               forCellReuseIdentifier: DataListCell.REUSE_IDENTIFIER)
        view.addSubview(dataTableView)
        
        NSLayoutConstraint.activate([
            dataTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            dataTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            dataTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            dataTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        dataSource = DataSource(tableView: dataTableView,
                                cellProvider: { [unowned self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: DataListCell.REUSE_IDENTIFIER) as! DataListCell
            let model = self.viewModel.machines[indexPath.row]
            cell.setupContents(model)
            return cell
        })
        dataSource.deleteHandler = { [unowned self] source, model in
            self.viewModel.showDeleteConfirmationAlert {
                self.viewModel.deleteData(model.machineId)
                var currentSnapshot = source.snapshot()
                currentSnapshot.deleteItems([model])
                source.apply(currentSnapshot)
            }
        }
    }
    
    override func setupBindings() {
        viewModel.$machines
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                self.setupSnapshot()
            }.store(in: &disposables)
    }
    
    private func setupSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.machines)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func addAction() {
        viewModel.routeToAddData()
    }
    
    @objc private func sortAction() {
        
    }
}

extension DataVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DataListCell.PREFERRED_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.routeToDetailData(viewModel.machines[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
