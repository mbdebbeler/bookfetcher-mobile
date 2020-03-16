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

}

protocol BooksClient {
    func search(query: String, completion: @escaping (Result<[Book], Error>) -> Void)
}

class GoogleBooksClient: BooksClient {
    func search(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {}
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

