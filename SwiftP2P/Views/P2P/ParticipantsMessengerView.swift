//
//  MessengerView.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import SwiftUI

struct ParticipantsMessengerView: View {
    @EnvironmentObject var model: ParticipantsViewModel
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Message", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action: {
                    model.send(message: Message(message: text))
                }) {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }
            }
            Spacer()
            List(model.messages, id: \.self) { message in
                Text(message.toJson() ?? "Failed to encode Message to JSON")
            }
        }
    }
}
