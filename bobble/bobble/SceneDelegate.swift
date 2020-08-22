//
//  SceneDelegate.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import bobbleFramework
import myBobblesFramework
import os.log

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var bobbles = [Bobble]()
    var myWonBobbles = [myBobbles]()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let _ = (scene as? UIWindowScene) else { return }
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    private func loadBobbles() -> [Bobble]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("bobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [Bobble]
    }
    
    private func loadMyBobbles() -> [myBobbles]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [myBobbles]
    }
    
    private func saveMyBobbles() {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myWonBobbles, toFile: ArchiveURL!.path)
        if isSuccessfulSave {
            os_log("Bobbles successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Bobbles...", log: OSLog.default, type: .error)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else {
            return
        }
        bobbles = []
        myWonBobbles = []
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)

        let bobbleId = Int(urlComponents?.host ?? "")
        guard let bobbleDetailVC = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "BobbleDetailViewController") as? BobbleDetailViewController else {
                   assertionFailure("No view controller ID BobbleDetailViewController in storyboard")
                   return
               }
        var selectedBobble: Bobble?
        for bobble in bobbles {
            if(bobble.id == bobbleId) {
                selectedBobble = bobble
                let wonBobble = myBobbles(id: bobbleId!)!
                myWonBobbles.append(wonBobble)
                break
            }
        }
        bobbleDetailVC.bobble = selectedBobble
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController?.present(bobbleDetailVC, animated: true, completion: nil)
        
        saveMyBobbles()
    }
    

}

