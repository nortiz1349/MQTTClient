//
//  MQTTClient.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import CocoaMQTT
import Combine
import Foundation
import OSLog

final class MQTTClient: MQTTProvider {
    
    static let shared = MQTTClient()
    
    private var mqtt5: CocoaMQTT5?
    
    var mqttMessageSubject = PassthroughSubject<MQTT, Never>()
    var mqttConnectionSubject = PassthroughSubject<Bool, Never>()
    var mqttTopicSubject = PassthroughSubject<[String], Never>()
    
    private let keepAliveSec: Double = 60.0
    
    private init() {
        logger.info("\(logHeader) Init")
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
        mqtt5?.keepAlive = UInt16(keepAliveSec)
        
        _ = mqtt5?.connect()
        
        publishMQTTMessage()
        publishMQTTTopicSubscription()
        publishMqttConnection()
        
        mqtt5?.didDisconnect = { _, error in
            if let error {
                logger.error("error :: \(error)")
            }
        }
    }
    
    /// MQTT 연결상태
    func publishMqttConnection() {
        mqtt5?.didChangeState = { _, state in
            switch state {
            case .connected:
                logger.log("\(logHeader) CONNECTED")
                self.mqttConnectionSubject.send(true)
                
            case .disconnected:
                logger.log("\(logHeader) DISCONNECTED")
                self.mqttConnectionSubject.send(false)
                
            case .connecting:
                logger.log("\(logHeader) Connecting...")
            }
        }
    }
    
    /// MQTT 메시지
    func publishMQTTMessage() {
        mqtt5?.didReceiveMessage = { _, rawMsg, _, _ in
            
            let mqtt = RawMQTT(
                topic: rawMsg.topic,
                message: rawMsg.string ?? ""
            )
            logger.log("\(logHeader) [TOPIC] \(mqtt.topic)\n[MESSAGE] \(mqtt.message)")
            
            self.mqttMessageSubject.send(mqtt)
        }
    }
    
    /// MQTT 구독 토픽
    func publishMQTTTopicSubscription() {
        mqtt5?.didSubscribeTopics = { _, topic, _, _ in
            if let dic = topic as? Dictionary<String, Int> {
                let topicArray = dic.map { $0.key }
                logger.log("\(logHeader) TopicSubscribed \(topicArray)")
                self.mqttTopicSubject.send(topicArray)
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
        logger.log("\(logHeader) MQTT5 nil")
    }
}

fileprivate let logger = Logger(subsystem: "com.theone.MQTTClient", category: "MQTTClient")
fileprivate let logHeader = "[MQTTClient]"
