//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Omar Noppe on 01/08/2022.
//

import Foundation

public struct FeedItem: Equatable {
    
    let id: UUID
    let description: String?
    let location: String?
    let imageUrl: URL
}
