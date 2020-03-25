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

class CustomImageView: UIImageView {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func load(url: URL) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let imageToCache = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                            self?.image = imageToCache
                        }
                    }
                }
            }
        }
    }
}
