//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Omar Noppe on 31/07/2022.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        
        client.get(from: url) { result in
            
            switch result {
            case .failure:
                completion(.failure(.connectivity))
            case let .success(data, response):
                
                do {
                    let items = try FeedItemsMapper.map(data, response: response)
                        completion(.success(items))

                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, response: response)
            return .success(items)
            
        } catch {
            return .failure(.invalidData)
        }
    }
}
