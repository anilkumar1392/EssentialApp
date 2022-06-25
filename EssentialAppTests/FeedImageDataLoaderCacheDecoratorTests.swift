//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by 13401027 on 25/06/22.
//

import Foundation
import XCTest
import EssentialFeed

protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}

final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataTaskLoader {
        return decoratee.loadImageData(from: url, completion: { [weak self] result in
            self?.cache.save((try? result.get()) ?? anyData(), for: url, completion: { _ in })
            completion(result)
        })
    }
}

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
    }
    
    func test_loadImageData_loadsFromLoader() {
        let (sut, loader) = makeSUT()
        
        _ = sut.loadImageData(from: anyURL()) { _ in }

        XCTAssertEqual(loader.loadedURLs, [anyURL()])
    }
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        let (sut, loader) = makeSUT()

        let task = sut.loadImageData(from: anyURL()) { result in }
        
        task.cancel()
        XCTAssertEqual(loader.cancelledURLs, [anyURL()])
    }
    
    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .success(anyData())) {
            loader.complete(with: anyData())
        }
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError())) {
            loader.complete(with: anyNSError())
        }
    }
    
    func test_loadImageData_cachesLoadedDataOnLoaderSuccess() {
        let cache = CacheSpy()
        let (sut, loader) = makeSUT(cache: cache)
        
        _ = sut.loadImageData(from: anyURL()) { _ in }
        loader.complete(with: anyData())
        
        XCTAssertEqual(cache.messages, [.save(data: anyData(), for: anyURL())])
    }
}

// MARK: - Helpers

extension FeedImageDataLoaderCacheDecoratorTests {
        
    private func makeSUT(cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()

        enum Message: Equatable {
            case save(data: Data, for: URL)
        }

        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data: data, for: url))
            completion(.success(()))
        }
    }
    
}

