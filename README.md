# Servus
Lightweight wrapper around NSNetService for use in iOS apps.
Enables discovering other devices over standard LAN _and_ ad-hoc peer-to-peer WiFi or Bluetooth networks.

## Usage
```Swift
explorer = Explorer()
explorer.delegate = self
explorer.startExploring()

...

func explorer(explorer: Explorer, didDeterminePeer peer: Peer) {
    print("Determined hostname for \(peer.identifier): \(peer.hostname!)")
}
```
