//
//  MQTTConnectionState.swift
//  MQTTClient
//
//  Created on 1/31/25.
//

import Foundation

public enum MQTTConnectionState: Equatable {
    case connecting
    case connected
    case disconnected
    case reconnecting(attempt: Int)
    case failed

    public var isConnected: Bool {
        if case .connected = self {
            return true
        }
        return false
    }

    public var isConnecting: Bool {
        switch self {
        case .connecting, .reconnecting:
            return true
        default:
            return false
        }
    }

    public var isFailed: Bool {
        if case .failed = self {
            return true
        }
        return false
    }
}
