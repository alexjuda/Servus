//
//  Resolver.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

protocol ResolverDelegate {
    func resolver(resolver: Resolver, didResolveService netService: NSNetService)
    func resolver(resolver: Resolver, failedToResolveService netService: NSNetService)
}

class Resolver: NSObject {
    private lazy var servicesInProgress = Set<NSNetService>()
    private let timeout: NSTimeInterval
    
    var delegate: ResolverDelegate?
    
    init(timeout: NSTimeInterval) {
        self.timeout = timeout
    }
    
    func resolveService(netService: NSNetService) {
        netService.delegate = self
        servicesInProgress.insert(netService)
        netService.resolveWithTimeout(timeout)
    }
}

extension Resolver: NSNetServiceDelegate {
    func netServiceDidResolveAddress(sender: NSNetService) {
        servicesInProgress.remove(sender)
        delegate?.resolver(self, didResolveService: sender)
    }
    
    func netService(sender: NSNetService, didNotResolve errorDict: [String : NSNumber]) {
        servicesInProgress.remove(sender)
        delegate?.resolver(self, failedToResolveService: sender)
    }
}