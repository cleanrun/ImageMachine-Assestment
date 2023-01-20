//
//  DataListView.swift
//  ImageMachine
//
//  Created by cleanmac on 20/01/23.
//

import UIKit
import Combine

final class DataListView: BaseVC, DataListPresenterToViewProtocol {

    private typealias DataSource = DataTableViewDiffableDataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MachineModel>
    
    private var dataTableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    var presenter: DataListViewToPresenterProtocol!
    private var dataSource: DataSource!
    
    override func loadView() {
        super.loadView()
        super.setupUI()
        title = "Machines"
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
                                cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: DataListCell.REUSE_IDENTIFIER) as! DataListCell
            cell.setupContents(item)
            return cell
        })
        dataSource.deleteHandler = { [unowned self] source, model in
            self.presenter.deleteMachine(with: model.machineId)
        }
    }
    
    private func setupSnapshot(using machines: [MachineModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(machines)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func observeMachineList(subject: CurrentValueSubject<[MachineModel], Never>) {
        subject
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.setupSnapshot(using: value)
            }.store(in: &disposables)
    }
    
    @objc private func addAction() {
        if checkIfCameraIsAuthorized() {
            presenter.routeToAddMachine(using: navigationController!)
        } else {
            presenter.showCameraNotAuthorizedAlert()
        }
    }
    
    @objc private func sortAction() {
        presenter.showSortAlert()
    }

}

extension DataListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DataListCell.PREFERRED_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = presenter.getMachine(at: indexPath.row)
        presenter.routeToMachineDetail(using: navigationController!, model)
    }
}
