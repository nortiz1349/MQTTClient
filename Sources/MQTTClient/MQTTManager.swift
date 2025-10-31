//
//  MQTTManager.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import Combine
import Foundation

public struct MQTTManager {
    
    private static var provider: MQTTProvider = MQTTClient.shared
        
    /// 외부에서 provider를 교체할 수 있도록 하는 메서드 (테스트 전용)
    public static func setProvider(_ newProvider: MQTTProvider) {
        provider = newProvider
    }
    
    public static func connectMQTT(with config: MQTTConfig) {
        provider.startMQTT5(with: config)
    }
    
    public static func disconnectMQTT() {
        provider.disconnectMQTT()
    }
    
    public static func subscribe(topic: String) {
        provider.subscribe(topic)
    }
    
    public static func subscribeMulti(topics: [String]) {
        provider.subscribeMulti(topics)
    }
    
    public static func unsubscribe(topic: String) {
        provider.unsubscribe(topic)
    }
    
    public static func sendMessage(topic: String, message: String) {
        provider.sendMessage(topic, message: message)
    }
    
    public static func ping() {
        provider.ping()
    }
    
    public static var mqttMessagePublisher: AnyPublisher<MQTT, Never> {
        provider.mqttMessageSubject.eraseToAnyPublisher()
    }
    
    public static var mqttConnectionPublisher: AnyPublisher<Bool, Never> {
        provider.mqttConnectionSubject.eraseToAnyPublisher()
    }
    
    public static var mqttTopicPublisher: AnyPublisher<[String], Never> {
        provider.mqttTopicSubject.eraseToAnyPublisher()
    }
    
    public static var mqttPingPublisher: AnyPublisher<Void, Never> {
        provider.mqttPingSubject.eraseToAnyPublisher()
    }
    
    public static var mqttPongPublisher: AnyPublisher<Void, Never> {
        provider.mqttPongSubject.eraseToAnyPublisher()
    }
}
