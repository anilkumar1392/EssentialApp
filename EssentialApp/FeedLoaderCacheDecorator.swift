//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by 13401027 on 24/06/22.
//

import Foundation
import EssentialFeed

public final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
//            if let feed = try? result.get() {
//                self?.cache.save(feed) { _ in }
//            }

            completion(result.map { feed in
                // self?.cache.save(feed) { _ in }
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }
}

extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}
