//
//  ParticipantsView.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import SwiftUI
import MultipeerConnectivity

struct ParticipantsView: View {
    @StateObject var model = ParticipantsViewModel()
    @Binding var isActive: Bool
    @State var isShakeHandsComplete: Bool = false
    @State var isJoined: Bool = false
    
    var body: some View {
        VStack(content: {
            Button(action: {
                isActive = false
            }) {
                Text("Close ParticipantsView")
            }
            Spacer()
            
            VStack {
                if !isJoined {
                    Text("Matchig")
                } else {
                    Text("You are Matched!")
                    Button(action: {
                        isShakeHandsComplete = true
                    }) {
                        Text("Go to GameScreen")
                    }.fullScreenCover(isPresented: $isShakeHandsComplete) {
                        ParticipantsMessengerView().environmentObject(model)
                    }
                }
            }
        }).alert(item: $model.permissionRequest, content: { request in
            Alert(
                title: Text("Do you want to join \(request.peerId.displayName)"),
                primaryButton: .default(Text("Yes"), action: {
                    request.onRequest(true)
                    model.join(peer: PeerDevice(peerId: request.peerId))
                    isJoined = true
                }),
                secondaryButton: .cancel(Text("No"), action: {
                    request.onRequest(false)
                })
            )
        })
    }
}
