//
//  OwnerView.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import SwiftUI
import MultipeerConnectivity

struct OwnerView: View {
    @StateObject var model = OwnerViewModel()
    @Binding var isActive: Bool
    @State var isShakeHandsComplete: Bool = false
    @State var isPleaseWaitAlertActive: Bool = false
    
    var body: some View {
        VStack(content: {
            Button(action: {
                isActive = false
            }) {
                Text("Close OwnerView")
            }
            Spacer()
            if model.selectedPeer == nil {
                NavigationStack {
                    List(model.peers, id: \.self) { peer in
                        HStack {
                            Image(systemName: "iphone.gen1")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            
                            Text(peer.peerId.displayName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            model.invite(_selectedPeer: PeerDevice(peerId: peer.peerId))
                        }
                    }
                }
            }
            Button(action: {
                if (!model.isParticipantsJoined()) {
                    isPleaseWaitAlertActive = true
                    return
                }
                isShakeHandsComplete = true
                model.join()
            }) {
                Text("Go to GameScreen")
            }.fullScreenCover(isPresented: $isShakeHandsComplete) {
                OwnerMessengerView().environmentObject(model)
            }
        }).alert(isPresented: $isPleaseWaitAlertActive, content: {
            Alert(
                title: Text("\(model.selectedPeer?.peerId.displayName) is not ready. Please wait."),
                dismissButton: .default(Text("OK"), action: {
                    isPleaseWaitAlertActive = false
                })
            )
        })
    }
}
