//
//  MainQueueDispatchDecorator.swift
//  EssentialFeediOS
//
//  Created by 13401027 on 13/06/22.
//

import Foundation
import EssentialFeed
import Combine

/*
 
   1.  Add behaviour to an instance wthout while keeping the same interface
   Following Open and close principle.
   Adding behaviour without changing the insatacne.
 
   So the ViewModel does not know about threading, Controller does not know about threading.
 
 */

/*
 Learning Outcomes
 Decoupling UIKit components (and any other client) from threading details
 Removing duplication and centralizing threading logic in the composition layer
 Decorator pattern: Extending behavior of individual objects without changing its implementation (Liskov Substitution + Open/Closed Principles)
 Decorator pattern: Implementing Cross-Cutting concerns (Single Responsibility Principle)
 */

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: FeedLoader where T == FeedLoader {
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataTaskLoader {
        decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
