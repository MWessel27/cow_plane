//
//  AppDelegate.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import CoreData
import os.log

struct Bobbles: Decodable {
    let id: Int
    let probability: String
    let name: String
    let imageName: String
    let description: String
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var bobbleUniverse = [Bobble]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack
    func preloadData() {
        if let bobbleUniverseData = self.loadBobbleUniverseJson() {
            self.parse(jsonData: bobbleUniverseData)
        }
    }
    
    func loadBobbleUniverseJson() -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: "bobbleUniverse",
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func saveBobbles() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(bobbleUniverse, toFile: Bobble.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Bobbles successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Bobbles...", log: OSLog.default, type: .error)
        }
    }
    
    private func parse(jsonData: Data) {
        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: preloadedDataKey) == false {
            do {
                
                let backgroundContext = persistentContainer.newBackgroundContext()
                let bobbles = try JSONDecoder().decode([Bobbles].self, from: jsonData)
                backgroundContext.perform {
                    for bobble in bobbles {
                        print("id: ", bobble.id)
                        print("name: ", bobble.name)
                        print("probability: ", bobble.probability)
                        print("imageName: ", bobble.imageName)
                        print("description: ", bobble.description)
                        print("===================================")
                        let newBobble = Bobble(id: bobble.id, probability: bobble.probability, image: bobble.imageName, name: bobble.name, number: 1, outOf: 500, bobbleDescription: bobble.description)
                        self.bobbleUniverse.append(newBobble!)
                    }
                    self.saveBobbles()
                }
                userDefaults.set(true, forKey: preloadedDataKey)
                print(bobbles)
            } catch {
                print("decode error")
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "bobble")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

