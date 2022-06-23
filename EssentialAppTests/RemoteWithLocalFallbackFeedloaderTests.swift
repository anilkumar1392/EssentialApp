//
//  RemoteWithLocalFallbackFeedloaderTests.swift
//  EssentialAppTests
//
//  Created by 13401027 on 23/06/22.
//

import Foundation
import XCTest
import EssentialFeed

class FeedLoaderWithFallbackComposite: FeedLoader {
    // RemoteWithLocalFallbackFeedLoader
    private let primaryFeedLoader: FeedLoader
    private let fallbackFeedLoader: FeedLoader
    
    init(primary: FeedLoader, fallback: FeedLoader) {
        self.primaryFeedLoader = primary
        self.fallbackFeedLoader = fallback
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primaryFeedLoader.load(completion: completion)
    }
    
}


// RemoteWithLocalFallbackFeedLoaderTests

class FeedLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        // test_load_deliversRemoteFeedOnRemoteSuccess
        
        let primaryFeed = uniqueFeed()
        let fallbackFeed = uniqueFeed()
        
        let primaryLoader = LoaderStub(result: .success(primaryFeed))
        let fallbackLoader = LoaderStub(result: .success(fallbackFeed))

        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "wait for load completion")
        sut.load { result in
            switch result {
            case let .success(receivedFeed):
                XCTAssertEqual(receivedFeed, primaryFeed)
                
            case .failure:
                XCTFail("Epxected to complete with success, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

extension FeedLoaderWithFallbackCompositeTests {
    
    private func uniqueFeed() -> [FeedImage] {
        return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
    }
    
    private class LoaderStub: FeedLoader {
        
        private let result: FeedLoader.Result
        
        init(result: FeedLoader.Result) {
            self.result = result
        }
        
        func load(completion: @escaping (LoaderStub.Result) -> Void) {
            completion(result)
        }
    }
}
