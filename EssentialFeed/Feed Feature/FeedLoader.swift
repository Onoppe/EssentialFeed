//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Omar Noppe on 04/08/2022.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
