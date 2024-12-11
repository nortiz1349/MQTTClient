//
//  MQTTManager.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import Combine
import Foundation

public struct MQTTManager {
    
    public static func connectMQTT(with config: MQTTConfig) {
        MQTTClient.shared.startMQTT5(with: config)
    }
    
    public static func disconnectMQTT() {
        MQTTClient.shared.disconnectMQTT()
    }
    
    public static func subscribe(topic: String) {
        MQTTClient.shared.subscribe(topic)
    }
    
    public static func subscribeMulti(topics: [String]) {
        MQTTClient.shared.subscribeMulti(topics)
    }
    
    public static func unsubscribe(topic: String) {
        MQTTClient.shared.unsubscribe(topic)
    }
    
    public static var mqttMessagePublisher: AnyPublisher<MQTT, Never> {
        MQTTClient.shared.mqttMessageSubject.eraseToAnyPublisher()
    }
    
    public static var mqttConnectionPublisher: AnyPublisher<Bool, Never> {
        MQTTClient.shared.mqttConnectionSubject.eraseToAnyPublisher()
    }
    
    public static var mqttTopicPublisher: AnyPublisher<[String], Never> {
        MQTTClient.shared.mqttTopicSubject.eraseToAnyPublisher()
    }
}
