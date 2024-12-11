//
//  MQTTProvider.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import Combine
import Foundation

protocol MQTTProvider {
    func startMQTT5(with config: MQTTConfig)
    func disconnectMQTT()
    func subscribe(_ topic: String)
    func subscribeMulti(_ topics: [String])
    func unsubscribe(_ topic: String)
    var mqttMessageSubject: PassthroughSubject<MQTT, Never> { get }
    var mqttConnectionSubject: PassthroughSubject<Bool, Never> { get }
    var mqttTopicSubject: PassthroughSubject<[String], Never> { get }
}
