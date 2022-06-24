//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by 13401027 on 24/06/22.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoaderStub.Result) -> Void) {
        completion(result)
    }
}
