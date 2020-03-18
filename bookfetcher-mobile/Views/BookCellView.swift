//
//  BookCellView.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/17/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

class BookCell: UITableViewCell {
    
    let iconView = UILabel()
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    private func configure() {
        label.lineBreakMode = .byTruncatingTail
        iconView.text = "📚"
        self.addSubview(iconView)
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
    }
    
}
