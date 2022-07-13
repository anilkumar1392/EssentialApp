//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by 13401027 on 26/06/22.
//

import Foundation
import XCTest
import EssentialFeed
import EssentialFeediOS
@testable import EssentialApp


// MARK: - Migrating the UIAcceptance test with the UIIntegration tests validating exactly the same scenarios.

// MARK: - Finallly we can remove Accpetacne Test file, DebuggingSceneDelegate, and we don't need to swap our delegate class for Debug builds.

// We also don't need to write RemoteClientFunction any more which was overriden for deubgging in scene delegate.
/*
 Like we did in UIAcceptacne test here also we need to control the infrastructure.
 So ideally we need to inject here HTTPClient and Store same as We did in UIAcceptacne.
 ["-reset", "-connectivity", "online"]
 
 So we can control unreliable infrastructure components.
 We want this test to be fast and reliable.
 
 */

class FeedAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        
//        XCTAssertNotNil(feed.simulateFeedImageViewVisible(at: 0)?.renderedImage)
//        XCTAssertNotNil(feed.simulateFeedImageViewVisible(at: 1)?.renderedImage)
//
//        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData())
//        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displayCachedRemoteFeedWhenCustomerHasNoConnectivity() {
         let sharedStore = InMemoryFeedStore.empty
         let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
         onlineFeed.simulateFeedImageViewVisible(at: 0)
         onlineFeed.simulateFeedImageViewVisible(at: 1)

        let offlineFeed = launch(httpClient: .offline, store: sharedStore)

        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 2)
        
        //XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData())
        // XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let offlineFeed = launch(httpClient: .offline, store: .empty)

        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 0)
    }
    
    // MARK: - When app enters background valdiate cache.
    
    func test_onEnteringBackground_deletesExpiredFeedCache() {
        let store = InMemoryFeedStore.withExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNil(store.feedCache, "Expecetd to delete expired cache")
    }
    
    func test_onEnteringBackground_keepsNonExpiredFeedCache() {
        let store = InMemoryFeedStore.withNonExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNotNil(store.feedCache, "Expecetd to keep non-expired cache")
    }
    
    // MARK: - Helpers
    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryFeedStore = .empty
    ) -> FeedViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()

        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! FeedViewController
    }
    
    private func enterBackground(with store: InMemoryFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
}

extension FeedAcceptanceTests {
    private class HTTPClientStub: HTTPClient {
        private class Task: HTTPClientTask {
            func cancel() {}
        }

        private let stub: (URL) -> HTTPClient.Result

        init(stub: @escaping (URL) -> HTTPClient.Result) {
            self.stub = stub
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            completion(stub(url))
            return Task()
        }

        static var offline: HTTPClientStub {
            HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
        }

        static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
            HTTPClientStub { url in
                .success(stub(url))
            }
        }
    }
    
    private class InMemoryFeedStore: FeedStore, FeedImageDataStore {
        private(set) var feedCache: CacheFeed?
        private var feedImageDataCache: [URL: Data] = [:]
        
        private init(feedCache: CacheFeed? = nil) {
            self.feedCache = feedCache
        }
        
        func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
            feedCache = nil
            completion(.success(()))
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
            feedCache = CacheFeed(feed: feed, timestamp: timestamp)
            completion(.success(()))
        }
        
        func retrieve(completion: @escaping FeedStore.RetrivalCompletion) {
            completion(.success(feedCache))
        }
        
        func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
            feedImageDataCache[url] = data
            completion(.success(()))
        }
        
        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
            completion(.success(feedImageDataCache[url]))
        }
        
        static var empty: InMemoryFeedStore {
            InMemoryFeedStore()
        }
        
        static var withExpiredFeedCache: InMemoryFeedStore {
            InMemoryFeedStore(feedCache: CacheFeed(feed: [], timestamp: Date.distantPast))
        }
        
        static var withNonExpiredFeedCache: InMemoryFeedStore {
            InMemoryFeedStore(feedCache: CacheFeed(feed: [], timestamp: Date()))
        }
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "http://image.com":
            return makeImageData()
            
        default:
            return makeFeedData()
        }
    }
    
    private func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString, "image": "http://image.com"],
            ["id": UUID().uuidString, "image": "http://image.com"]
        ]])
    }
}
