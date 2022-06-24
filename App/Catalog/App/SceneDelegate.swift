//
//  SceneDelegate.swift
//  Catalog
//
//  Created by Dzulfaqar on 28/05/22.
//

import Cleanse
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        do {
            let main = try ComponentFactory.of(HomeComponent.self).build(())
            window?.rootViewController = UINavigationController(rootViewController: main)
            window?.makeKeyAndVisible()
        } catch {
            print("Cleanse Error: \(error)")
        }
    }
}
