//
//  ImageFetcher.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/25/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation
import UIKit

class ImageFetcher {
        
    private let imageCache = NSCache<ImageKey, UIImage>()
    
    func load(url: URL, into imageView: UIImageView) {
        self.load(url: url) { [weak imageView] image in
            imageView?.image = image
        }
    }
    
    func load(url: URL, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.cacheKey) {
            completion(cachedImage)
        } else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let imageToCache = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageCache.setObject(imageToCache, forKey: url.cacheKey)
                            completion(imageToCache)
                        }
                    }
                }
            }
        }
    }
}

private typealias ImageKey = NSString

private extension URL {
    var cacheKey: ImageKey {
        return absoluteString as ImageKey
    }
}
