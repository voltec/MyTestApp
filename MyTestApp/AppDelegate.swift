//
//  AppDelegate.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  internal var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController = HomeModuleBuilder.build()
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()

    return true
  }
}

