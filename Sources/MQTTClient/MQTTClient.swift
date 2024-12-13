//
//  MQTTClient.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import CocoaMQTT
import Combine
import Foundation

final class MQTTClient: MQTTProvider, Loggable {
    
    static let shared = MQTTClient()
    
    private var mqtt5: CocoaMQTT5?
    
    var mqttMessageSubject = PassthroughSubject<MQTT, Never>()
    var mqttConnectionSubject = PassthroughSubject<Bool, Never>()
    var mqttTopicSubject = PassthroughSubject<[String], Never>()
    
    private init() {
        logDefault("Init")
    }
    
    func startMQTT5(with config: MQTTConfig) {
        mqtt5 = CocoaMQTT5(
            clientID: config.clientID,
            host: config.host,
            port: config.port
        )
        mqtt5?.username = config.username
        mqtt5?.password = config.password
        mqtt5?.enableSSL = config.enableSSL
        
        _ = mqtt5?.connect()
        
        publishMQTTMessage()
        publishMQTTTopicSubscription()
        publishMqttConnection()
        
        mqtt5?.didDisconnect = { [weak self] _, error in
            if let error {
                self?.logError("Disconnected with Error: \(error)")
            }
        }
    }
    
    /// MQTT 연결상태
    func publishMqttConnection() {
        mqtt5?.didChangeState = { [weak self] _, state in
            guard let self else { return }
            switch state {
            case .connected:
                logInfo("CONNECTED")
                mqttConnectionSubject.send(true)
                
            case .disconnected:
                logInfo("DISCONNECTED")
                mqttConnectionSubject.send(false)
                
            case .connecting:
                logInfo("Connecting...")
            }
        }
    }
    
    /// MQTT 메시지
    func publishMQTTMessage() {
        mqtt5?.didReceiveMessage = { [weak self] _, rawMsg, _, _ in
            guard let self else { return }
            let mqtt = RawMQTT(
                topic: rawMsg.topic,
                message: rawMsg.string ?? ""
            )
            logInfo("\n[TOPIC] \(mqtt.topic)\n[MESSAGE] \(mqtt.message)")
            mqttMessageSubject.send(mqtt)
        }
    }
    
    /// MQTT 구독 토픽
    func publishMQTTTopicSubscription() {
        mqtt5?.didSubscribeTopics = { [weak self] _, topic, _, _ in
            guard let self else { return }
            if let dic = topic as? Dictionary<String, Int> {
                let topicArray = dic.map { $0.key }
                logInfo("Topic Subscribed \(topicArray)")
                mqttTopicSubject.send(topicArray)
            }
        }
    }
    
    func subscribe(_ topic: String) {
        mqtt5?.subscribe(topic, qos: .qos2)
    }
    
    func subscribeMulti(_ topics: [String]) {
        let subscription = topics.map { MqttSubscription(topic: $0, qos: .qos2) }
        mqtt5?.subscribe(subscription)
    }
    
    func unsubscribe(_ topic: String) {
        mqtt5?.unsubscribe(topic)
    }
    
    func disconnectMQTT() {
        mqtt5?.disconnect()
        mqtt5 = nil
        logInfo("Disconnected by User")
    }
}
