//
//  DebuggingSceneDelegate.swift
//  EssentialApp
//
//  Created by 13401027 on 25/06/22.
//

#if DEBUG
import Foundation
import UIKit
import EssentialFeed

// We are extending the scene delegate
// and moving all the DEBUG logic to the new debugging scene deleagte.

class DebuggingSceneDelegate: SceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Compilation directives to prevent this code from being deployed on production.
        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreURL)
        }
        
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    override func makeRemoteClient() -> HTTPClient {
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            return AlwaysFailingHTTPClient()
        }
        
        return super.makeRemoteClient()
    }
}

private class AlwaysFailingHTTPClient: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() { }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(.failure(NSError(domain: "offline", code: 0)))
        return Task()
    }
}
#endif
