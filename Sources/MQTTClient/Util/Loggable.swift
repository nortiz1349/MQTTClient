//
//  Loggable.swift
//
//
//  Created by 박종운 on 12/13/24.
//

import Foundation
import OSLog

public protocol Loggable {
    var logger: Logger { get }
}

extension Loggable {
    var logger: Logger {
        Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "",
            category: String(describing: Self.self)
        )
    }

    func logDefault(_ message: String) {
        logger.log("[\(String(describing: Self.self))] \(message)")
    }
    
    func logInfo(_ message: String) {
        logger.info("[\(String(describing: Self.self))] \(message)")
    }
    
    func logError(_ message: String) {
        logger.error("[\(String(describing: Self.self))] \(message)")
    }
    
    func logDebug(_ message: String) {
        logger.debug("[\(String(describing: Self.self))] \(message)")
    }
}
