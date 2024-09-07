//
//  ParticipantsView.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import SwiftUI
import MultipeerConnectivity

struct ParticipantsView: View {
    @StateObject var model = DeviceFinderViewModel()
    @Binding var isActive: Bool
    
    var body: some View {
        VStack(content: {
            Button(action: {
                isActive = false
            }) {
                Text("Close!!!!!")
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
            .alert(item: $model.permissionRequest, content: { request in
                Alert(
                    title: Text("Do you want to join \(request.peerId.displayName)"),
                    primaryButton: .default(Text("Yes"), action: {
                        request.onRequest(true)
                        model.show(peerId: request.peerId)
                    }),
                    secondaryButton: .cancel(Text("No"), action: {
                        request.onRequest(false)
                    })
                )
            })
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
