//
//  SceneDelegate.swift
//  ImagesSearch
//
//  Created by Roman Ivanov on 22.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13, *)
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    @available(iOS 13, *)
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    @available(iOS 13, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    @available(iOS 13, *)
    func sceneWillResignActive(_ scene: UIScene) {
    }

    @available(iOS 13, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    @available(iOS 13, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

