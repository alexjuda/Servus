//
//  Explorer.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

public protocol ExplorerDelegate {
    func explorer(explorer: Explorer, didSpotPeer peer: Peer)
    func explorer(explorer: Explorer, didDeterminePeer peer: Peer)
    func explorer(explorer: Explorer, didLosePeer peer: Peer)
}

public class Explorer {
    let advertiser: Advertiser
    let revealer: Revealer
    let resolver: Resolver
    
    public var delegate: ExplorerDelegate?
    
    public init(identifier: String, appName: String) {
        let type = "_\(appName)._tcp."
        let domain = "local."
        
        advertiser = Advertiser(identifier: identifier, netServiceType: type, netServiceDomain: domain)
        revealer = Revealer(localIdentifier: identifier, netServiceType: type, netServiceDomain: domain)
        resolver = Resolver(timeout: 60.0)
        
        revealer.delegate = self
        resolver.delegate = self
    }
    
    public convenience init() {
        let uuid = NSUUID().UUIDString
        
        let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier")!
        let charactersToRemove = NSCharacterSet.alphanumericCharacterSet().invertedSet
        let cleanAppName = appName.componentsSeparatedByCharactersInSet(charactersToRemove).joinWithSeparator("")
        
        self.init(identifier: uuid, appName: cleanAppName)
    }
    
    public func startExploring() {
        advertiser.start()
        revealer.start()
    }
    
    public func stopExploring() {
        advertiser.stop()
        revealer.stop()
    }
}

extension Explorer: RevealerDelegate {
    func revealer(revealer: Revealer, didRevealService netService: NSNetService) {
        resolver.resolveService(netService)
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didSpotPeer: peer)
    }
    
    func revealer(revealer: Revealer, didLoseService netService: NSNetService) {
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didLosePeer: peer)
    }
}

extension Explorer: ResolverDelegate {
    func resolver(resolver: Resolver, didResolveService netService: NSNetService) {
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didDeterminePeer: peer)
    }
    
    func resolver(resolver: Resolver, failedToResolveService netService: NSNetService) {
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didLosePeer: peer)
    }
}

