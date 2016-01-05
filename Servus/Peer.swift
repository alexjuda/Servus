//
//  Peer.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

/// Model class representing a device participating in Bonjour exploration.
public class Peer {
    /// Identifier the device's Explorer was initialized with.
    public let identifier: String
    
    /// The device's hostname. This value should be used in place of an IP address.
    public let hostname: String?
    
    let netService: NSNetService
    
    init(netService: NSNetService) {
        identifier = netService.name
        hostname = netService.hostName
        self.netService = netService
    }
}