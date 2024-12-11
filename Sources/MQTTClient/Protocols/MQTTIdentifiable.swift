//
//  MQTTIdentifiable.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import Foundation

public protocol MQTTIdentifiable: CaseIterable {
    var lastComponent: String { get }
    static var unknown: Self { get }
}

public extension MQTTIdentifiable {
    static func lastComponents() -> [String] {
        return Self.allCases.map { $0.lastComponent }
    }

    static func findMQTT(from mqtt: MQTT) -> Self {
        guard let last = mqtt.seperateTopic().last else { return .unknown }
        return Self.allCases.first { $0.lastComponent == last } ?? .unknown
    }
}
