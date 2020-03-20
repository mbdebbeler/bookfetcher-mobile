//
//  BooksClient.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation

protocol BooksClient: class {
    func search(query: String, offset: Int, completion: @escaping (Result<[Book], Error>) -> Void)
}

class GoogleBooksClient: BooksClient {
    
    enum GoogleBooksClientError: Error {
        case unableToConnect
        case invalidURL
        case noData
    }

    var dataTask: NetworkingDataTask?
    let networkingSession: NetworkingSession
    let googleBooksEndpoint = "https://www.googleapis.com/books/v1/volumes"
    
    init(networkingSession: NetworkingSession = URLSession(configuration: .default)) {
        self.networkingSession = networkingSession
    }
    
    func search(query: String, offset: Int = 0, completion: @escaping (Result<[Book], Error>) ->
        Void) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: googleBooksEndpoint) {
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "maxResults", value: "40"),
                URLQueryItem(name: "startIndex", value: offset.description)
            ]

            guard let url = urlComponents.url else {
                completion(.failure(GoogleBooksClientError.invalidURL))
                return
            }

            dataTask = networkingSession.networkingTask(with: url) { (data, _, error) in
                if let error = error {
                    completion(Result<[Book], Error>.failure(error))
                    return
                }
                do {
                    guard let data = data else { throw GoogleBooksClientError.noData }
                    let decoder = JSONDecoder()
                    let bookResponse = try decoder.decode(BookResponse.self, from: data)
                    completion(Result.success(bookResponse.items ?? []))
                }
                catch let error {
                    completion(Result<[Book], Error>.failure(error))
                }
            }
            dataTask?.resume()
        }
    }
}

protocol NetworkingSession {
    func networkingTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingDataTask
}

extension URLSession: NetworkingSession {
    func networkingTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingDataTask {
        return dataTask(with: url, completionHandler: completionHandler)
    }
}

protocol NetworkingDataTask {
    func cancel()
    func resume()
}

extension URLSessionDataTask: NetworkingDataTask {}
