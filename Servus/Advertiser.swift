//
//  Advertiser.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

class Advertiser {
    let identifier: String
    let netServiceType: String
    let netServiceDomain: String
    
    var announcingService: NSNetService?
    
    init(identifier: String, netServiceType: String, netServiceDomain: String) {
        self.identifier = identifier
        self.netServiceType = netServiceType
        self.netServiceDomain = netServiceDomain
    }
    
    func start() {
        stop()
        
        announcingService = NSNetService(domain: netServiceDomain, type: netServiceType, name: identifier)
        announcingService?.includesPeerToPeer = true
        announcingService?.publish()
    }
    
    func stop() {
        announcingService?.stop()
        announcingService = nil
    }
}