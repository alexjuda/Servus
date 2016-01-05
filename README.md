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

## Usage
Servus can be easily integrated with Xcode project via Carthage. 

Add 
```
github "airalex/Servus"
``` 
to your Cartfile, run `carthage update`, and drag `Carthage/Build/iOS/Servus.framework` to your Xcode project.
