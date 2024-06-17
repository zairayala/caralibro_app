//
//  Message.swift
//  2022-ios
//
//  Created by user190700 on 7/22/22.
//

import UIKit

class Message {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    init(fromId: String?, text: String?, timestamp: NSNumber?, toId: String?){
        self.fromId = fromId
        self.text = text
        self.timestamp = timestamp
        self.toId = toId
    }
}
