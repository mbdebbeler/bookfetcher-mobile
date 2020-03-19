//
//  BookStore.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation

class BookStore {
    
    func search(query: String, offset: Int = 0, completion: @escaping (Result<[Book], Error>) -> Void) {
        let localBooksClient = LocalBooksClient()
        localBooksClient.search(query: "stub", offset: offset, completion: completion)
    }
    
    func searchGoogleBooks(query: String, offset: Int = 0, completion: @escaping (Result<[Book], Error>) -> Void) {
        let googleBooksClient = GoogleBooksClient()
        googleBooksClient.search(query: query, offset: offset, completion: completion)
    }
    
}

protocol BooksClient {
    func search(query: String, offset: Int, completion: @escaping (Result<[Book], Error>) -> Void)
}

class GoogleBooksClient: BooksClient {
    
    enum GoogleBooksClientError: Error {
        case unableToConnect
    }

    var dataTask: URLSessionDataTask?
    let defaultSession = URLSession(configuration: .default)
    
    func search(query: String, offset: Int = 0, completion: @escaping (Result<[Book], Error>) -> Void) {
        
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
            dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
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

class LocalBooksClient: BooksClient {
    
    enum LocalBooksClientError: Error {
        case noLocalData
    }
    
    func search(query: String, offset: Int = 0, completion: @escaping (Result<[Book], Error>) -> Void) {
        do {
            let data = try getLocalJSONResponse()
            let decoder = JSONDecoder()
            let bookResponse = try decoder.decode(BookResponse.self, from: data)
            completion(Result.success(bookResponse.items ?? []))
        } catch let error {
            let result = Result<[Book], Error>.failure(error)
            completion(result)
        }
    }
    
    func getLocalJSONResponse() throws -> Data {
        guard let url: URL = Bundle.main.url(forResource: "sampleData", withExtension: "json") else {
            throw LocalBooksClientError.noLocalData
        }
        return try Data(contentsOf: url)
        
    }
    
}

