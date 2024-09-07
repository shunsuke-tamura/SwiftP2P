//
//  DeviceFinderViewModel.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import Foundation
import MultipeerConnectivity
import SwiftUI
import Combine

class DeviceFinderViewModel: NSObject, ObservableObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    @Published var peers: [PeerDevice] = []
    private let session: MCSession
    private let serviceType = "nearby-devices"
    
    @Published var permissionRequest: PermissionRequest?
    
    @Published var isAdvertised: Bool = false {
        didSet {
            isAdvertised ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    @Published var selectedPeer: PeerDevice? {
        didSet {
            print("selected!!")
            connect()
        }
    }
    
    @Published var joinedPeer: [PeerDevice] = []
    
    @Published var messages: [String] = []
    let messagePublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    func send(string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        
        try? session.send(data, toPeers: [joinedPeer.last!.peerId], with: .reliable)
        
        messagePublisher.send(string)
    }
    
    @Published var isShakeHandsComplete = false
    func shakeHandsComplete() {
        isShakeHandsComplete = true
    }
    
    override init() {
        let peer = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peer)
        
        advertiser = MCNearbyServiceAdvertiser(
            peer: peer,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        super.init()
        
        browser.delegate = self
        advertiser.delegate = self
        session.delegate = self
        
        messagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.messages.append($0)
            }
            .store(in: &subscriptions)
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    func finishBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    func show(peerId: MCPeerID) {
        guard let first = peers.first(where: { $0.peerId == peerId }) else {
            return
        }
        
        joinedPeer.append(first)
    }
    
    private func connect() {
        print("connect")
        print("selectedPeer: \(selectedPeer)")
        guard let selectedPeer else {
            return
        }
        
        if session.connectedPeers.contains(selectedPeer.peerId) {
            print("joined")
            joinedPeer.append(selectedPeer)
        } else {
            print("invite")
            browser.invitePeer(selectedPeer.peerId, to: session, withContext: nil, timeout: 60)
        }
    }
}

extension DeviceFinderViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(PeerDevice(peerId: peerID))
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
}

struct PeerDevice: Identifiable, Hashable {
    let id = UUID()
    let peerId: MCPeerID
}

extension DeviceFinderViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        permissionRequest = PermissionRequest(
            peerId: peerID,
            onRequest: {
                [weak self] permission in
                invitationHandler(permission, permission ? self?.session : nil)
            }
        )
    }
}

struct PermissionRequest: Identifiable {
    let id = UUID()
    let peerId: MCPeerID
    let onRequest: (Bool) -> Void
}

extension DeviceFinderViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let last = joinedPeer.last, last.peerId == peerID, let message = String(data: data, encoding: .utf8) else {
            return
        }
        
        messagePublisher.send(message)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //
    }
    
}
