//
//  BobbleShelfViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 9/11/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import SwiftUI
import bobbleFramework
import myBobblesFramework
import NotificationCenter

class BobbleShelfViewController: UIViewController {
    
    var bobbles = [Bobble]()
    var myWonBobbles = [myBobbles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        let bobbleShelfView = UIHostingController(rootView: BobbleShelfSwiftUIView(bobbles: bobbles, myWonBobbles: myWonBobbles))
        
        addChild(bobbleShelfView)
        view.addSubview(bobbleShelfView.view)
        
        bobbleShelfView.view.translatesAutoresizingMaskIntoConstraints = false
        bobbleShelfView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bobbleShelfView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bobbleShelfView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bobbleShelfView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("dismissSwiftUI"), object: nil, queue: nil) { (_) in
            self.shareButtonTapped()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bobbles = []
        myWonBobbles = []
        
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        let bobbleShelfView = UIHostingController(rootView: BobbleShelfSwiftUIView(bobbles: bobbles, myWonBobbles: myWonBobbles))
        
        addChild(bobbleShelfView)
        view.addSubview(bobbleShelfView.view)
        
        bobbleShelfView.view.translatesAutoresizingMaskIntoConstraints = false
        bobbleShelfView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bobbleShelfView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bobbleShelfView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bobbleShelfView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    public func shareButtonTapped() {
        print("tapped that button")
    }
    
    private func loadBobbles() -> [Bobble]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("bobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [Bobble]
    }
    
    private func loadMyBobbles() -> [myBobbles]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [myBobbles]
    }
}
