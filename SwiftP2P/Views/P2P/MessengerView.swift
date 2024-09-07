//
//  MessengerView.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/07.
//

import SwiftUI

struct MessengerView: View {
    @EnvironmentObject var model: DeviceFinderViewModel
    @State private var message: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Message", text: $message)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action: {
                    model.send(string: message)
                    message = ""
                }) {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }
            }
            Spacer()
            List(model.messages, id: \.self) { message in
                Text(message)
            }
        }
    }
}
