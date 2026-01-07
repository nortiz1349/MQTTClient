//
//  MQTTProvider.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import Combine
import Foundation

public protocol MQTTProvider {
    var mqttMessageSubject: PassthroughSubject<MQTT, Never> { get }
    var mqttConnectionSubject: CurrentValueSubject<Bool, Never> { get }
    var mqttConnectionStateSubject: CurrentValueSubject<MQTTConnectionState, Never> { get }
    var mqttTopicSubject: CurrentValueSubject<[String], Never> { get }
    var mqttPingSubject: PassthroughSubject<Void, Never> { get }
    var mqttPongSubject: PassthroughSubject<Void, Never> { get }
    var mqttDisconnectSubject: PassthroughSubject<Error?, Never> { get }
    
    func startMQTT5(with config: MQTTConfig)
    func subscribe(_ topic: String)
    func subscribeMulti(_ topics: [String])
    func unsubscribe(_ topic: String)
    func unsubscribeMulti(_ topics: [String])
    func sendMessage(_ topic: String, message: String)
    func disconnectMQTT()
    func ping()
}
