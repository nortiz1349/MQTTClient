//
//  MockMQTTClient.swift
//
//
//  Created by 박종운 on 12/24/24.
//

import MQTTClient
import Foundation
import Combine

final class MockMQTTClient: MQTTProvider {
    // MARK: - Subjects
    var mqttMessageSubject = PassthroughSubject<MQTT, Never>()
    var mqttConnectionSubject = CurrentValueSubject<Bool, Never>(false)
    var mqttTopicSubject = CurrentValueSubject<[String], Never>([])
    
    var isStarted = false
    
    func startMQTT5(with config: MQTTConfig) {
        // 실제 네트워크 연결 대신, 원하는 시점에 연결 이벤트를 직접 트리거
        isStarted = true
        mqttConnectionSubject.send(true)
    }
    
    func subscribe(_ topic: String) {
        // 구독 완료가 되었다고 가정
        var currentTopics = mqttTopicSubject.value
        currentTopics.append(topic)
        mqttTopicSubject.send(currentTopics)
    }
    
    func subscribeMulti(_ topics: [String]) {
        var currentTopics = mqttTopicSubject.value
        currentTopics.append(contentsOf: topics)
        mqttTopicSubject.send(currentTopics)
    }
    
    func unsubscribe(_ topic: String) {
        var currentTopics = mqttTopicSubject.value
        if let index = currentTopics.firstIndex(of: topic) {
            currentTopics.remove(at: index)
        }
        mqttTopicSubject.send(currentTopics)
    }
    
    func disconnectMQTT() {
        isStarted = false
        mqttConnectionSubject.send(false)
        mqttTopicSubject.send([])
    }
}
