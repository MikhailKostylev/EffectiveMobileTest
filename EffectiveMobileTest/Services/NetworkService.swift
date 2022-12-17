//
//  NetworkService.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 08.12.2022.
//

import UIKit

protocol NetworkServiceProtocol: AnyObject {
    func fetchData<T: Decodable>(with url: String, for model: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func fetchImage(with url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    private var cacheImages: NSCache<NSString, UIImage> = NSCache()
    
    enum NetworkError: Error {
        case fetchDataError
        case decodeDataError
        case fetchImageError
    }
    
    public func fetchData<T: Decodable>(
        with url: String,
        for model: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.fetchDataError))
                return
            }
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                completion(.failure(NetworkError.decodeDataError))
            }
        }.resume()
    }
    
    public func fetchImage(
        with url: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.fetchImageError))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
