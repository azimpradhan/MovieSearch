//
//  AppDelegate.swift
//  MovieSearch
//
//  Created by Azim Pradhan on 4/3/25.
//
import UIKit
import SDWebImage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Set up SDWebImage cache size
        let imageCache = SDImageCache.shared
        imageCache.config.maxDiskSize = 10 * 1024 * 1024 // 10 MB
        imageCache.config.maxMemoryCost = 5 * 1024 * 1024 // 5 MB

        return true
    }
}
