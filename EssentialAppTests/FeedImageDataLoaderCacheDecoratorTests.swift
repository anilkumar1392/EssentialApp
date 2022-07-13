//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by 13401027 on 25/06/22.
//

import Foundation
import XCTest
import EssentialFeed
import EssentialApp

// Main module lecture -3
// MARK: - Interception: An Effective, Modular and Composable Way of Injecting Behavior and Side-effects in the App Composition
// For FeedImageDataLoader

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
    
    func test_loadImageData_doesNotCacheDataOnLoaderFailure() {
        let cache = CacheSpy()
        let url = anyURL()
        let (sut, loader) = makeSUT(cache: cache)

        _ = sut.loadImageData(from: url) { _ in }
        loader.complete(with: anyNSError())

        XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache image data on load error")
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

