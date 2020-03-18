//
//  LoadingView.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/17/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    let spinner = UIActivityIndicatorView(style: .large)

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
        spinner.startAnimating()   
        self.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}
