//
//  Revealer.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

protocol RevealerDelegate {
    func revealer(_ revealer: Revealer, didRevealService netService: NetService)
    func revealer(_ revealer: Revealer, didLoseService netService: NetService)
}

class Revealer: NSObject {
    fileprivate let localIdentifier: String
    fileprivate let netServiceType: String
    fileprivate let netServiceDomain: String
    fileprivate var browser: NetServiceBrowser?
    
    var delegate: RevealerDelegate?
    
    init(localIdentifier: String, netServiceType: String, netServiceDomain: String) {
        self.localIdentifier = localIdentifier
        self.netServiceType = netServiceType
        self.netServiceDomain = netServiceDomain
    }
    
    func start() {
        stop()
        
        browser = NetServiceBrowser()
        browser?.delegate = self
        browser?.includesPeerToPeer = true
        browser?.searchForServices(ofType: netServiceType, inDomain: netServiceDomain)
    }
    
    func stop() {
        browser?.stop()
        browser = nil
    }
}

extension Revealer: NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        if service.name == localIdentifier {
            return
        }
        
        delegate?.revealer(self, didRevealService: service)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        delegate?.revealer(self, didLoseService: service)
    }
}
