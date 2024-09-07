//
//  MessagerViewModel.swift
//  SwiftP2P
//
//  Created by shunsuke tamura on 2024/09/08.
//

class MessagerViewModel {
    var messages: [Message] = []
    
    func init(
    
    func send(message: String) {
        let message = Message(message: message)
        messages.append(message)
    }
}
