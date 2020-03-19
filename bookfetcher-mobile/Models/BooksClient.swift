//
//  BooksClient.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation

protocol BooksClient {
    func search(query: String, offset: Int, completion: @escaping (Result<[Book], Error>) -> Void)
}

class GoogleBooksClient: BooksClient {
    
    enum GoogleBooksClientError: Error {
        case unableToConnect
    }

    var dataTask: URLSessionDataTask?
    let networkingSession: NetworkingSession
    
    init(networkingSession: NetworkingSession = URLSession(configuration: .default)) {
        self.networkingSession = networkingSession
    }
    
    func search(query: String, offset: Int = 0, completion: @escaping (Result<[Book], Error>) ->
        Void) {
        dataTask?.cancel()
        
        let googleBooksEndpoint = "https://www.googleapis.com/books/v1/volumes"
        if var urlComponents = URLComponents(string: googleBooksEndpoint) {
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "maxResults", value: "40"),
                URLQueryItem(name: "startIndex", value: offset.description)
            ]

            guard let url = urlComponents.url else {
                return
            }
            //you're going to make a fake session, like we did in Java
            //mock URLSession
            dataTask = networkingSession.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Oh no!", error)
                    completion(Result<[Book], Error>.failure(error))
                    return
                }
                do {
                    guard let data = data else { return }
                    let decoder = JSONDecoder()
                    let bookResponse = try decoder.decode(BookResponse.self, from: data)
                    completion(Result.success(bookResponse.items ?? []))
                }
                catch let error {
                    print("oh no! Failed to decode data into books", error)
                    completion(Result<[Book], Error>.failure(error))
                }
            }
            dataTask?.resume()
        }
    }
}

protocol NetworkingSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: NetworkingSession {
    
}
