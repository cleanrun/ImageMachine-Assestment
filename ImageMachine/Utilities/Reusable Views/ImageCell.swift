//
//  ImageCell.swift
//  ImageMachine
//
//  Created by cleanmac-ada on 21/12/22.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    static let REUSABLE_IDENTIFIER = String(describing: ImageCell.self)
    static let PREFERRED_HEIGHT_AND_WIDTH: CGFloat = 80
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
