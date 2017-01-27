//
//  AppDelegate.swift
//  ServusExample
//
//  Created by Alexander Juda on 28/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import UIKit
import Servus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var explorer: Explorer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        explorer = Explorer()
        explorer.delegate = self
        explorer.startExploring()
        print("Started exploring nearby peers...")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate: ExplorerDelegate {
    func explorer(_ explorer: Explorer, didSpotPeer peer: Peer) {
        print("Spotted \(peer.identifier). Didn't determine its addresses yet")
    }
    
    func explorer(_ explorer: Explorer, didDeterminePeer peer: Peer) {
        print("Determined hostname for \(peer.identifier): \(peer.hostname!)")
    }
    
    func explorer(_ explorer: Explorer, didLosePeer peer: Peer) {
        print("Lost \(peer.hostname) from sight")
    }
}

