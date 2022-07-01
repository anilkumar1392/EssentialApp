//
//  CombineHelpers.swift
//  EssentialApp
//
//  Created by 13401027 on 30/06/22.
//

import Foundation
import Combine
import EssentialFeed

extension FeedLoader {
    public typealias Publisher = AnyPublisher<[FeedImage], Error>
    
    public func loadPublisher() -> Publisher {
        Deferred {
            Future { completion in
                self .load(completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }
}


// Configure with decorator
extension Publisher where Output == [FeedImage] {
    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> {
//        map { feed in
//            cache.saveIgnoringResult(feed)
//            return feed
//        }
//        .eraseToAnyPublisher()
        
//        handleEvents(receiveOutput: { feed in
//            cache.saveIgnoringResult(feed)
//        })
//        .eraseToAnyPublisher()

        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
}

// Configure for fallback
extension Publisher {
    func failure(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueSchedular {
        ImmediateWhenOnMainQueueSchedular.shared
    }
    
    struct ImmediateWhenOnMainQueueSchedular: Scheduler {

        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        /// This scheduler’s definition of the current moment in time.
        var now: Self.SchedulerTimeType {
            DispatchQueue.main.now
        }

        /// The minimum tolerance allowed by the scheduler.
        var minimumTolerance: Self.SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }

        static let shared = Self()
        private static let key = DispatchSpecificKey<UInt>()
        private static let value = UInt.max
        
        private init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }
        
        private func isMainQueue() -> Bool {
            return DispatchQueue.getSpecific(key: Self.key) == Self.value
        }
        
        /// Performs the action at the next possible opportunity.
        func schedule(options: Self.SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            // The Main queue is quaranteed to be running on the main thread.
            // The Main thread is not quaranteed to be running the main queue.
            // It may be running a background queue.
            action()
        }

        /// Performs the action at some time after the specified date.
        func schedule(after date: Self.SchedulerTimeType, tolerance: Self.SchedulerTimeType.Stride, options: Self.SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }

        /// Performs the action at some time after the specified date, at the specified frequency, optionally taking into account tolerance if possible.
        func schedule(after date: Self.SchedulerTimeType, interval: Self.SchedulerTimeType.Stride, tolerance: Self.SchedulerTimeType.Stride, options: Self.SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
