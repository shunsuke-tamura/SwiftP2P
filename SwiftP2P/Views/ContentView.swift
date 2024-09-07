//
//  ContentView.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresentedOwnerView = false
    @State private var isPresentedParticipantsView = false
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }

            Button(action: {
                isPresentedOwnerView = true
            }) {
               Text("Create Room")
                    .foregroundColor(.white)
            }.fullScreenCover(isPresented: $isPresentedOwnerView) {
                OwnerView(isActive: $isPresentedOwnerView)
            }
                .accentColor(Color.white)
                .background(Color.green)
                .cornerRadius(.infinity)

            Button(action: {
                isPresentedParticipantsView = true
            }) {
               Text("Join Room")
                    .foregroundColor(.white)
            }.fullScreenCover(isPresented: $isPresentedParticipantsView) {
                ParticipantsView(isActive: $isPresentedParticipantsView)
            }
                .accentColor(Color.white)
                .background(Color.blue)
                .cornerRadius(.infinity)
        }
        .padding()
    }
}
