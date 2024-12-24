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
    var mqttConnectionSubject = CurrentValueSubject<Bool, Never>(false)
    var mqttTopicSubject = CurrentValueSubject<[String], Never>([])
    
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
        publishMQTTTopicUnsubscription()
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
                mqttTopicSubject.send([])
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
    
    /// 토픽을 구독 했을때
    func publishMQTTTopicSubscription() {
        mqtt5?.didSubscribeTopics = { [weak self] _, topic, _, _ in
            guard let self else { return }
            if let dic = topic as? Dictionary<String, Int> {
                let topicArray = dic.map { $0.key }
                
                var currentTopics = mqttTopicSubject.value
                currentTopics.append(contentsOf: topicArray)
                
                logInfo("Topic Subscribed \(topicArray)")
                logInfo("Remaining Subscribed Topics: \(currentTopics)")
                mqttTopicSubject.send(currentTopics)
            }
        }
    }
    
    /// 토픽을 구독 해제 했을때
    func publishMQTTTopicUnsubscription() {
        mqtt5?.didUnsubscribeTopics = { [weak self] _, topics, _ in
            guard let self else { return }
            
            var currentTopics = mqttTopicSubject.value
            topics.forEach { topic in
                if let index = currentTopics.firstIndex(of: topic) {
                    currentTopics.remove(at: index)
                }
            }
            
            logInfo("Unsubscribed Topics: \(topics)")
            logInfo("Remaining Subscribed Topics: \(currentTopics)")
            mqttTopicSubject.send(currentTopics)
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
        mqttTopicSubject.send([])
        mqttConnectionSubject.send(false)
        logInfo("Disconnected by User")
    }
}
