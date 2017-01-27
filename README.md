# Servus
Lightweight wrapper around NSNetService for use in iOS apps.
Enables discovering other devices over standard LAN _and_ ad-hoc peer-to-peer WiFi or Bluetooth networks.

## Example
```Swift
explorer = Explorer()
explorer.delegate = self
explorer.startExploring()

...

func explorer(explorer: Explorer, didDeterminePeer peer: Peer) {
    print("Determined hostname for \(peer.identifier): \(peer.hostname!)")
}
```

For working example check out [the app target](https://github.com/airalex/Servus/blob/master/ServusExample/AppDelegate.swift). 

## Installation

### Carthage

Servus can be integrated with Xcode project via [Carthage](https://github.com/Carthage/Carthage), a dependency manager for Cocoa. 

1. Add ```github "airalex/Servus"``` to your Cartfile.
1. Run `carthage update`
1. Drag `Carthage/Build/iOS/Servus.framework` to your Xcode project, or select _File > Add Files..._
1. Make sure `/usr/local/bin/carthage copy-frameworks` _Run Script_ phase is present for your target.
1. Add `$(SRCROOT)/Carthage/Build/iOS/Servus.framework` to _Input Files_ list.
