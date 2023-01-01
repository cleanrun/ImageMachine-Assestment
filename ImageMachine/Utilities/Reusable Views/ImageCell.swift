//
//  ImageCell.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 21/12/22.
//

import UIKit

protocol ImageCellDelegate: AnyObject {
    func onDelete(for model: ImageModel)
}

final class ImageCell: UICollectionViewCell {
    static let REUSABLE_IDENTIFIER = String(describing: ImageCell.self)
    static let PREFERRED_HEIGHT_AND_WIDTH: CGFloat = 80
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = .red
        button.tintColor = .white
        button.layer.cornerRadius = 12.5
        return button
    }()
    
    private var imageModel: ImageModel!
    weak var delegate: ImageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            deleteButton.heightAnchor.constraint(equalToConstant: 25),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
        ])
        
        deleteButton.isHidden = true
    }
    
    func setImageModel(_ model: ImageModel) {
        imageModel = model
        imageView.image = model.imageData.createDownsampledImage(to: CGSize(width: 100, height: 100))
    }
    
    func enableDeleteButton(_ enable: Bool) {
        deleteButton.isHidden = !enable
    }
    
    @objc private func deleteAction() {
        delegate?.onDelete(for: imageModel)
    }
}
