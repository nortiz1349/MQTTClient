# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

```bash
# Build
swift build

# Run all tests
swift test

# Run specific test class
swift test --filter MQTTManagerTests

# Run single test method
swift test --filter MQTTManagerTests/testConnection

# Update dependencies
swift package update
```

## Architecture Overview

### Three-Layer Design Pattern

1. **MQTTClient (Implementation Layer)**: Internal singleton class that wraps CocoaMQTT5
   - Location: `Sources/MQTTClient/MQTTClient.swift`
   - Direct interaction with CocoaMQTT5 library
   - Manages connection lifecycle, subscriptions, and message handling
   - Exposes Combine subjects for reactive streams

2. **MQTTProvider (Abstraction Layer)**: Protocol defining MQTT operations
   - Location: `Sources/MQTTClient/Protocols/MQTTProvider.swift`
   - Enables dependency injection for testing
   - Defines contract for: subjects (message/connection/topic), operations (start/subscribe/publish/disconnect)

3. **MQTTManager (Public API Layer)**: Static facade providing clean public interface
   - Location: `Sources/MQTTClient/MQTTManager.swift`
   - All methods and publishers are static
   - Delegates to internal provider (MQTTClient by default)
   - `setProvider()` allows injection of mock implementations for testing

### Data Flow

```
Consumer → MQTTManager (static API) → MQTTProvider (protocol) → MQTTClient (singleton) → CocoaMQTT5
                                                ↓
                                    Combine Publishers (message/connection/topic)
```

### Key Protocols

- **MQTTConfig**: Connection configuration (host, port, credentials, SSL, keepAlive, autoReconnect)
  - Extension provides `clientID` using `UIDevice.current.identifierForVendor`

- **MQTT**: Message protocol with `topic` and `message` properties
  - Extension provides: `seperateTopic()`, `jsonDataMessage`, `description`

- **MQTTIdentifiable**: For enums representing MQTT topics
  - Must be `CaseIterable` and `RawRepresentable` with `String` raw value
  - Provides `findMQTT(from:)` to match incoming messages to enum cases by last topic component

- **Loggable**: OSLog-based logging with environment-specific visibility
  - Logs with `.public` privacy only in dev/staging builds (controlled by build flags)

### Reactive Streams

Three Combine publishers expose MQTT events:

1. **mqttMessagePublisher**: `AnyPublisher<MQTT, Never>` - Incoming messages
2. **mqttConnectionPublisher**: `AnyPublisher<Bool, Never>` - Connection state
3. **mqttTopicPublisher**: `AnyPublisher<[String], Never>` - Currently subscribed topics

### Environment Build Flags

The package defines conditional compilation flags in `Package.swift`:
- `DevDebug`, `DevTestFlight`, `StagingDebug`, `StagingTestFlight`
- These control logging visibility in the `Loggable` protocol

## Code Conventions

- **Commit messages**: Write in Korean without external attribution
- **Type safety**: Always verify property type definitions before use (check protocol/class definitions)
- **Protocol-oriented**: Prefer protocol extensions for default implementations
- **Access control**: Mark public APIs explicitly; tests use `@testable import`
- **Testing**: Use mock implementations conforming to `MQTTProvider` protocol

## Common Patterns

### Implementing Custom MQTT Messages

Create a struct/class conforming to `MQTT` protocol:

```swift
struct CustomMessage: MQTT {
    let topic: String
    let message: String
    // Additional properties as needed
}
```

### Defining Topic Enums

For type-safe topic handling, create enums conforming to `MQTTIdentifiable`:

```swift
public enum MyTopics: String, MQTTIdentifiable {
    case status = "device/status"
    case command = "device/command"
    case unknown = "unknown"

    public static var unknown: MyTopics { .unknown }
}

// Usage: match received MQTT to enum case
let topicCase = MyTopics.findMQTT(from: receivedMQTT)
```

### Testing with Mocks

1. Create mock conforming to `MQTTProvider`
2. Inject via `MQTTManager.setProvider(mockProvider)`
3. Manually trigger subjects to simulate MQTT events
4. Test uses `XCTestExpectation` with Combine sinks

See `Tests/MQTTClientTests/` for examples.
