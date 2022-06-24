//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by 13401027 on 24/06/22.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    private let primary: FeedImageDataLoader
    private let fallback: FeedImageDataLoader
    
    private class TaskWrapper: FeedImageDataTaskLoader {
        var wrapper: FeedImageDataTaskLoader?
        
        func cancel() {
            wrapper?.cancel()
        }
    }

    public init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataTaskLoader {
        let task = TaskWrapper()
        task.wrapper = primary.loadImageData(from: url, completion: { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                task.wrapper = self?.fallback.loadImageData(from: url, completion: completion)
            }
        })
        return task
    }
}
