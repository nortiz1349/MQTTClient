//
//  MQTTManagerTests.swift
//
//
//  Created by 박종운 on 12/24/24.
//

import XCTest
import Combine
@testable import MQTTClient

final class MQTTManagerTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var mockClient: MockMQTTClient!
    
    override func setUp() {
        super.setUp()
        
        // 새 Mock 객체를 만들고, MQTTManager에 주입
        mockClient = MockMQTTClient()
        MQTTManager.setProvider(mockClient)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testConnection() {
        // given
        let expectation = XCTestExpectation(description: "MQTTConnectionPublisher test")
        
        // when
        MQTTManager.mqttConnectionPublisher
            .dropFirst() // 초기값(false)을 스킵
            .sink { isConnected in
                // then
                XCTAssertTrue(isConnected, "Mock client는 start 호출 후 true를 보내야 함")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        MQTTManager.connectMQTT(with: MockMQTTConfig())
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTopicSubscription() {
        // given
        let expectation = XCTestExpectation(description: "MQTTTopicPublisher test")
        
        MQTTManager.mqttTopicPublisher
            .dropFirst() // 초기값([])을 스킵
            .sink { topics in
                // then
                XCTAssertEqual(topics, ["test/topic"], "토픽이 정상적으로 추가되어야 함")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        MQTTManager.subscribe(topic: "test/topic")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMessageReception() {
        // given
        let expectation = XCTestExpectation(description: "MQTTMessagePublisher test")
        
        MQTTManager.mqttMessagePublisher
            .sink { mqttData in
                XCTAssertEqual(mqttData.topic, "test/topic")
                XCTAssertEqual(mqttData.message, "hello world")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        // 실제로 네트워크 수신 대신, mockClient에서 직접 send
        mockClient.mqttMessageSubject.send(
            RawMQTT(topic: "test/topic", message: "hello world")
        )
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUnsubscribe() {
        // given
        let expectation = XCTestExpectation(description: "Unsubscribe test")
        
        MQTTManager.subscribe(topic: "test/topic1")
        MQTTManager.subscribe(topic: "test/topic2")
        
        MQTTManager.mqttTopicPublisher
            .dropFirst()
            .sink { topics in
                // then
                XCTAssertFalse(topics.contains("test/topic1"), "topic1은 구독 해제 후 없어야 함")
                XCTAssertTrue(topics.contains("test/topic2"), "topic2는 여전히 유지되어야 함")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        MQTTManager.unsubscribe(topic: "test/topic1")
        
        wait(for: [expectation], timeout: 1.0)
    }
}
