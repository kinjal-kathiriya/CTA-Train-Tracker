//
//  SceneDelegate.swift
//  KinjalKCTATracker
//
//  Created by kinjal kathiriya  on 4/25/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            window = UIWindow(windowScene: windowScene)
            let linesVC = LinesViewController()
            let navController = UINavigationController(rootViewController: linesVC)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene disconnected")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Scene became active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("Scene will resign active")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("Scene will enter foreground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Scene entered background")
    }
}
