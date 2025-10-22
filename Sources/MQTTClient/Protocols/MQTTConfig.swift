//
//  MQTTConfiguration.swift
//
//
//  Created by 박종운 on 12/11/24.
//

import Foundation
import UIKit

public protocol MQTTConfig {
    var host: String { get }
    var port: UInt16 { get }
    var username: String { get }
    var password: String { get }
    var enableSSL: Bool { get }
}

public extension MQTTConfig {
    var clientID: String { UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString }
}
