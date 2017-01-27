//
//  Explorer.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

/**
 *  Defines methods to be called during Bonjour exploration.
 */
public protocol ExplorerDelegate {
    /**
     Method to be called after a peer was discovered, but its addresses are not resolved yet.
     
     - parameter explorer: Explorer instance.
     - parameter peer:     Spotted peer.
     */
    func explorer(_ explorer: Explorer, didSpotPeer peer: Peer)
    
    /**
     Method to be called after a peer was discovered and its addresses are resolved. Standard TCP connections can be established now (i.e. HTTP).
     
     - parameter explorer: Explorer instance.
     - parameter peer:     Determined peer.
     */
    func explorer(_ explorer: Explorer, didDeterminePeer peer: Peer)
    /**
     Method to be called after a peer service disappeared. This can occur when the other device's user turns off WiFi or Bluetooth.
     
     - parameter explorer: Explorer instance
     - parameter peer:     Lost peer.
     */
    func explorer(_ explorer: Explorer, didLosePeer peer: Peer)
}

/// Encapsulates discovering nearby Bonjour services and broadcasting its own one.
///
/// Enables creating ad-hoc networks (if not already connected), discovering and resolving addresses of other devices.
/// Supports connections in the same LAN, WiFi to WiFi and Bluetooth to Bluetooth.
open class Explorer {
    let advertiser: Advertiser
    let revealer: Revealer
    let resolver: Resolver
    
    /// This device's peer identifier.
    open let identifier: String
    
    /// Delegate object to be notified about explorations.
    open var delegate: ExplorerDelegate?
    
    /**
     Explorer initalizer.
     
     - parameter identifier: Identifier used to distinguish this device from other peers. Should be unique for each device.
     - parameter appName:    Application name used to distinguish the Servus services from other service broadcasters such as printers.
    
     - returns: Initialized object.
     */
    public init(identifier: String, appName: String) {
        let type = "_\(appName)._tcp."
        let domain = "local."
        
        advertiser = Advertiser(identifier: identifier, netServiceType: type, netServiceDomain: domain)
        revealer = Revealer(localIdentifier: identifier, netServiceType: type, netServiceDomain: domain)
        resolver = Resolver(timeout: 60.0)
        self.identifier = identifier
        
        revealer.delegate = self
        resolver.delegate = self
    }
    
    /**
     Convenience Explorer initializer. Generates a UUID for current device identifier and fetches the app name from bundle.
     
     - returns: Initialized object.
     */
    public convenience init() {
        let uuid = UUID().uuidString
        
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier")!
        let charactersToRemove = CharacterSet.alphanumerics.inverted
        let cleanAppName = (appName as AnyObject).components(separatedBy: charactersToRemove).joined(separator: "")
        
        self.init(identifier: uuid, appName: cleanAppName)
    }
    
    /**
     Starts the exploration process. Makes current device visible with Bonjour (LAN and P2P) and searches for other devices.
     Calls the delegate on each discovery.
     */
    open func startExploring() {
        advertiser.start()
        revealer.start()
    }
    
    /**
     Stops the exploration process. Hides current device and stops calling the delegate.
     */
    open func stopExploring() {
        advertiser.stop()
        revealer.stop()
    }
}

extension Explorer: RevealerDelegate {
    func revealer(_ revealer: Revealer, didRevealService netService: NetService) {
        resolver.resolveService(netService)
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didSpotPeer: peer)
    }
    
    func revealer(_ revealer: Revealer, didLoseService netService: NetService) {
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didLosePeer: peer)
    }
}

extension Explorer: ResolverDelegate {
    func resolver(_ resolver: Resolver, didResolveService netService: NetService) {
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didDeterminePeer: peer)
    }
    
    func resolver(_ resolver: Resolver, failedToResolveService netService: NetService) {
        let peer = Peer(netService: netService)
        delegate?.explorer(self, didLosePeer: peer)
    }
}

