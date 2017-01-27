# Servus
Lightweight wrapper around NSNetService for use in iOS apps.
Enables discovering other devices over standard LAN _and_ ad-hoc peer-to-peer WiFi or Bluetooth networks.

Written in Swift 3.

## What is it for?

When nearby devices are discovered and properly resolved, Servus provides a hostname for each of them. Combine it with [a HTTP Server for iOS](https://github.com/httpswift/swifter), and [HTTP requests](https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started), and BAM! You send data between devices using Bluetooth or WiFi without having to worry about the infrastructure.

### Isn't it MultipeerConnectivity?

[Apple provides a framework](https://developer.apple.com/reference/multipeerconnectivity) for such ad-hoc networks. However, from my experience it's quite unreliable (gets stuck pretty often), and is painful to test. 

Servus, on the other hand, provides only the discovery phase. Data transfer is done separately, so the developer has greater insight to it. Also, it's super easy to test! Just open the app on the simulator, or on a device within the same LAN as your computer and you can send HTTP requests to `http://your-device-hostname:PORT/`. _And it works_. Magic.

## Example
```Swift
explorer = Explorer()
explorer.delegate = self
explorer.startExploring() // Start announcing this device's presence & reporting discovery of other ones.

...

func explorer(explorer: Explorer, didDeterminePeer peer: Peer) {
    print("Determined hostname for \(peer.identifier): \(peer.hostname!)")
}
```

For working example check out [the app target](ServusExample/AppDelegate.swift). 

## Installation

### Carthage

Servus can be integrated with Xcode project via [Carthage](https://github.com/Carthage/Carthage), a dependency manager for Cocoa. 

1. Add ```github "airalex/Servus"``` to your Cartfile.
1. Run `carthage update`
1. Drag `Carthage/Build/iOS/Servus.framework` to your Xcode project, or select _File > Add Files..._
1. Make sure `/usr/local/bin/carthage copy-frameworks` _Run Script_ phase is present for your target.
1. Add `$(SRCROOT)/Carthage/Build/iOS/Servus.framework` to _Input Files_ list.

### Manual

1. `git clone git@github.com:airalex/Servus.git`
1. Copy [Servus/](Servus/) directory to your project.
1. Make sure all files are present in your project (Explorer, Peer, Advertiser, Resolver, Revealer).
