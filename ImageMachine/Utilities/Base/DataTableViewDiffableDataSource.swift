//
//  DataTableViewDiffableDataSource.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 21/12/22.
//

import UIKit

final class DataTableViewDiffableDataSource: UITableViewDiffableDataSource<Int, MachineModel> {
    var deleteHandler: ((DataTableViewDiffableDataSource, MachineModel) -> Void)?
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let model = itemIdentifier(for: indexPath) else { return }
            deleteHandler?(self, model)
        }
    }
}
