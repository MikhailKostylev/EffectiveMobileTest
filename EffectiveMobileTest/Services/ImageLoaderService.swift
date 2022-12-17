//
//  ImageLoaderService.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 14.12.2022.
//

import UIKit

final class ImageLoaderService {
    static let shared = ImageLoaderService()
    
    private let networkService = NetworkService()
    private var cacheImages: NSCache<NSString, UIImage> = NSCache()
    
    private init() {}
    
    public func loadImage(
        for url: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        if let image = cacheImages.object(forKey: url as NSString) {
            completion(image)
        } else {
            networkService.fetchImage(with: url) { result in
                switch result {
                    
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    self.cacheImages.setObject(image, forKey: url as NSString)
                    completion(image)
                    
                case .failure(let error):
                    completion(R.Image.mockImage)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
