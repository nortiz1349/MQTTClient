//
//  MockMQTTConfig.swift
//
//
//  Created by 박종운 on 12/24/24.
//

import Foundation
import MQTTClient

struct MockMQTTConfig: MQTTConfig {
    var host: String = "testHost"
    var port: UInt16 = 1883
    var username: String = ""
    var password: String = ""
    var enableSSL: Bool = true
}
