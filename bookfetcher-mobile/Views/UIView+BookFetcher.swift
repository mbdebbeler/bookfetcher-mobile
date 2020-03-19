//
//  UIView+BookFetcher.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/17/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func pin(to other: UIView) -> [NSLayoutConstraint] {
        return [
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor)]
    }
    
    func center() -> [NSLayoutConstraint] {
        return [
            centerXAnchor.constraint(equalTo: centerXAnchor),
            centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
