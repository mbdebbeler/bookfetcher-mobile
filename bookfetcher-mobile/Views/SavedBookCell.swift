//
//  SavedBookCell.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/26/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

class SavedBookCell: UICollectionViewCell {
    
    static var identifier: String = "SavedBookCell"
    
    weak var textLabel: UILabel!
    
    let containerView = UIView()
    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
        thumbnailImageView.image = nil
    }
    
    private func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailImageView.contentMode = .scaleAspectFit
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center
        authorLabel.lineBreakMode = .byTruncatingTail
        authorLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 18)
        let padding: CGFloat = 8
        let height: CGFloat = 188
        
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        contentView.addSubview(containerView)
                
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            thumbnailImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            thumbnailImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: height),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 3/4),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: padding),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            authorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            authorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4)

        ])
    }
    
}
