//
//  MQTT.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import Foundation
import OSLog

public protocol MQTT {
    var topic: String { get }
    var message: String { get }
}

public extension MQTT {
    
    /// `topic`을 "/" 단위로 분리하여 배열로 반환
    func seperateTopic() -> [String] {
        topic.components(separatedBy: "/")
    }
    
    /// `message`를 utf8 형식으로 인코딩한 `Data`
    var jsonDataMessage: Data? {
        guard let data = message.data(using: .utf8) else {
            Logger().error("[MQTTMessage] Failed to encode data From message\n\(message)")
            return nil
        }
        
        return data
    }
}

fileprivate let logger = Logger(subsystem: "com.theone.MQTTClient", category: "MQTTParsable")
