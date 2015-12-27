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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        explorer = Explorer()
        explorer.delegate = self
        explorer.startExploring()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.whiteColor()
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate: ExplorerDelegate {
    func explorer(explorer: Explorer, didSpotPeer peer: Peer) {
        print("Spotted \(peer.identifier). Didn't determine its addresses yet")
    }
    
    func explorer(explorer: Explorer, didDeterminePeer peer: Peer) {
        print("Determined hostname for \(peer.identifier): \(peer.hostname!)")
    }
    
    func explorer(explorer: Explorer, didLosePeer peer: Peer) {
        print("Lost \(peer.hostname) from sight")
    }
}

