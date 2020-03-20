//
//  BooksClient.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation

/// API for getting books
protocol BooksClient: class {
    
    /// searches for books
    /// - Parameters:
    ///   - query: what to search for
    ///   - offset: start index to fetch more results
    ///   - completion: fired when request completes or errors
    func search(query: String, offset: Int, completion: @escaping (Result<[Book], Error>) -> Void)
}


/// API for searching Google Books
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
                // this can never happen because our endpoint is a constant and a valid URL, so this path is not tested
                completion(.failure(GoogleBooksClientError.invalidURL))
                return
            }

            // the completion expects (data, response, error)
            // @escaping just means the completion will not be called until after the function finished
            // data task takes an escaping closure - it is async. map, filter, take closures but they are NOT escaping they run right away
            dataTask = networkingSession.networkingTask(with: url) { (data, _, error) in
                if let error = error {
                    // if there's an error we pass the completion a result that is case failure with the error as an associated value
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
            // calling resume starts the data task
            dataTask?.resume()
        }
    }
}

/// wrapper around networking to allow mocking
protocol NetworkingSession {
    func networkingTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingDataTask
}

extension URLSession: NetworkingSession {
    func networkingTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkingDataTask {
        return dataTask(with: url, completionHandler: completionHandler)
    }
}

/// wrapper around dataTask to allow mocking
protocol NetworkingDataTask {
    func cancel()
    func resume()
}

extension URLSessionDataTask: NetworkingDataTask {
    
}
