//
//  EazyInstallApp.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 10/9/23.
//

import SwiftUI
import UIKit
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    var persistentContainer: NSPersistentContainer = {
        // Replace 'YourModel' with your actual data model name
        let container = NSPersistentContainer(name: "ScannedTextModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Handle the error appropriately
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }

    // Add any additional AppDelegate methods here
}


@main
struct EazyInstallApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        let context = delegate.persistentContainer.viewContext
        let coreDataViewModel = CoreDataViewModel(managedObjectContext: context)

        return WindowGroup {
            ContentView(coreDataViewModel: coreDataViewModel)
                .environmentObject(SharedDataModel())


        }
    }
}
