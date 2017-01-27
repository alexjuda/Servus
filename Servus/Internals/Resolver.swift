//
//  Resolver.swift
//  Servus
//
//  Created by Alexander Juda on 27/12/15.
//  Copyright © 2015 Alexander Juda. All rights reserved.
//

import Foundation

protocol ResolverDelegate {
    func resolver(_ resolver: Resolver, didResolveService netService: NetService)
    func resolver(_ resolver: Resolver, failedToResolveService netService: NetService)
}

class Resolver: NSObject {
    fileprivate lazy var servicesInProgress = Set<NetService>()
    fileprivate let timeout: TimeInterval
    
    var delegate: ResolverDelegate?
    
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    func resolveService(_ netService: NetService) {
        netService.delegate = self
        servicesInProgress.insert(netService)
        netService.resolve(withTimeout: timeout)
    }
}

extension Resolver: NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        servicesInProgress.remove(sender)
        delegate?.resolver(self, didResolveService: sender)
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        servicesInProgress.remove(sender)
        delegate?.resolver(self, failedToResolveService: sender)
    }
}
