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
}

private final class FeedItemsMapper {
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(Root.self, from: data).items.map { $0.item }
    }
}

private struct Root: Decodable {
    let items: [Item]
}

private struct Item: Decodable {
    
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedItem {
        FeedItem(id: id, description: description, location: location, imageURL: image)
    }
   
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.image = imageURL
    }
}
