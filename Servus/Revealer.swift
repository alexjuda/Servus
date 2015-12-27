//
//  Revealer.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

protocol RevealerDelegate {
    func revealer(revealer: Revealer, didRevealService netService: NSNetService)
    func revealer(revealer: Revealer, didLoseService netService: NSNetService)
}

class Revealer: NSObject {
    private let localIdentifier: String
    private let netServiceType: String
    private let netServiceDomain: String
    private var browser: NSNetServiceBrowser?
    
    var delegate: RevealerDelegate?
    
    init(localIdentifier: String, netServiceType: String, netServiceDomain: String) {
        self.localIdentifier = localIdentifier
        self.netServiceType = netServiceType
        self.netServiceDomain = netServiceDomain
    }
    
    func start() {
        stop()
        
        browser = NSNetServiceBrowser()
        browser?.delegate = self
        browser?.includesPeerToPeer = true
        browser?.searchForServicesOfType(netServiceType, inDomain: netServiceDomain)
    }
    
    func stop() {
        browser?.stop()
        browser = nil
    }
}

extension Revealer: NSNetServiceBrowserDelegate {
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        if service.name == localIdentifier {
            return
        }
        
        delegate?.revealer(self, didRevealService: service)
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        delegate?.revealer(self, didLoseService: service)
    }
}