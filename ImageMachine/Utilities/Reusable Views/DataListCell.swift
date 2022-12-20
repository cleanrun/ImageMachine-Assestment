//
//  DataListCell.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 20/12/22.
//

import UIKit

final class DataListCell: UITableViewCell {
    static let REUSE_IDENTIFIER = String(describing: DataListCell.self)
    
    private var nameTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private var imageCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        nameTypeStackView.addArrangedSubviews(nameLabel, typeLabel)
        contentView.addSubviews(imageCountLabel, nameTypeStackView)
        
        NSLayoutConstraint.activate([
            imageCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            
            nameTypeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameTypeStackView.trailingAnchor.constraint(equalTo: imageCountLabel.leadingAnchor, constant: -16),
            nameTypeStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ])
    }
    
    func setupContents(_ machine: MachineModel) {
        nameLabel.text = machine.name
        typeLabel.text = machine.type
        imageCountLabel.text = "\(machine.images.count) Images"
    }
}
