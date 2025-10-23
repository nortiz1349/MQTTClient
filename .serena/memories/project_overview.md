# MQTTClient Project Overview

## Purpose
MQTTClient is a Swift package library that provides a wrapper around CocoaMQTT for iOS and macOS applications. It simplifies MQTT communication by providing a clean, protocol-based architecture with Combine publishers for reactive programming.

## Tech Stack
- **Language**: Swift 5.10+
- **Platforms**: iOS 15+, macOS 13+
- **Dependencies**: 
  - CocoaMQTT (v2.1.8+) - The underlying MQTT client implementation
- **Frameworks**:
  - Combine - For reactive publishers
  - OSLog - For logging
  - UIKit - For device identification
- **Testing**: XCTest
- **Package Manager**: Swift Package Manager (SPM)

## Main Components

### Core Classes
- **MQTTClient** (Class): Main singleton client that wraps CocoaMQTT5, provides subjects for message/connection/topic events
- **MQTTManager** (Struct): Static facade/wrapper that provides a clean API interface to MQTTClient

### Protocols
- **MQTTProvider**: Defines the contract for MQTT providers with publishers and MQTT operations
- **MQTTConfig**: Configuration protocol for MQTT connection settings (host, port, credentials, SSL, etc.)
- **MQTT**: Protocol for MQTT messages with topic and message properties
- **MQTTIdentifiable**: Protocol for types that can be identified in MQTT context
- **Loggable**: Logging utility protocol using OSLog

### Data Types
- **RawMQTT** (Struct): Basic implementation of MQTT protocol for raw messages

## Key Features
1. MQTT5 protocol support
2. Reactive publishers for:
   - Message reception
   - Connection status
   - Topic subscriptions
3. Auto-reconnect capability
4. SSL/TLS support
5. Environment-based conditional logging (DevDebug, DevTestFlight, StagingDebug, StagingTestFlight)
6. Device-specific client IDs using UIDevice identifier
