//
//  BookStore.swift
//  bookfetcher-mobile
//
//  Created by Monica Debbeler on 3/16/20.
//  Copyright © 2020 Monica Debbeler. All rights reserved.
//

import Foundation

class BookStore {
    
    func search(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let localBooksClient = LocalBooksClient()
        localBooksClient.search(query: "stub", completion: completion)
    }
    
    func searchGoogleBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let googleBooksClient = GoogleBooksClient()
        googleBooksClient.search(query: query, completion: completion)
    }
    
}

protocol BooksClient {
    func search(query: String, completion: @escaping (Result<[Book], Error>) -> Void)
}

class GoogleBooksClient: BooksClient {
    
    enum GoogleBooksClientError: Error {
        case unableToConnect
    }
    
    func search(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        
        let googleBooksEndpoint = "https://www.googleapis.com/books/v1/volumes"
        if var urlComponents = URLComponents(string: googleBooksEndpoint) {
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: query)
            ]

            guard let url = urlComponents.url else {
                return
            }
            defaultSession.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Oh no!", error)
                    completion(Result<[Book], Error>.failure(error))
                    return
                }
                do {
                    guard let data = data else { return }
                    let decoder = JSONDecoder()
                    let bookResponse = try decoder.decode(BookResponse.self, from: data)
                    completion(Result.success(bookResponse.items))
                }
                catch let error {
                    print("oh no! Failed to decode data into books", error)
                    completion(Result<[Book], Error>.failure(error))
                }
            }.resume()
        }
    }
}

class LocalBooksClient: BooksClient {
    
    enum LocalBooksClientError: Error {
        case noLocalData
    }
    
    func search(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        do {
            let data = try getLocalJSONResponse()
            let decoder = JSONDecoder()
            let bookResponse = try decoder.decode(BookResponse.self, from: data)
            completion(Result.success(bookResponse.items))
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

