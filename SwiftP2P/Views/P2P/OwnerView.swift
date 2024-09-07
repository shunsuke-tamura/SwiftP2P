//
//  OwnerView.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import SwiftUI
import MultipeerConnectivity

struct OwnerView: View {
    @StateObject var model = DeviceFinderViewModel()
    @Binding var isActive: Bool
    
    var body: some View {
        VStack(content: {
            Button(action: {
                isActive = false
            }) {
                Text("Close???")
            }
            Spacer()
            NavigationStack {
                List(model.peers) { peer in
                    HStack {
                        Image(systemName: "iphone.gen1")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                        
                        Text(peer.peerId.displayName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 5)
                    .onTapGesture {
                        model.selectedPeer = peer
                        print("pressed")
                    }
                }
                .onAppear {
                    model.startBrowsing()
                }
                .onDisappear {
                    model.finishBrowsing()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Toggle("Press to be discoverable", isOn: $model.isAdvertised)
                            .toggleStyle(.switch)
                    }
                }
            }
        })
        Spacer()
        Button(action: {
            model.shakeHandsComplete()
        }) {
            Text("Messenger")
        }.fullScreenCover(isPresented: $model.isShakeHandsComplete) {
            MessengerView().environmentObject(model)
        }
    }
}
