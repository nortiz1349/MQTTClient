# Codebase Structure

## Directory Layout
```
MQTTClient/
├── Package.swift                    # SPM package definition
├── Sources/
│   └── MQTTClient/
│       ├── MQTTClient.swift        # Main client class (singleton)
│       ├── MQTTManager.swift       # Static facade for MQTT operations
│       ├── RawMQTT.swift           # Basic MQTT message implementation
│       ├── Protocols/
│       │   ├── MQTT.swift          # MQTT message protocol
│       │   ├── MQTTConfig.swift    # Configuration protocol
│       │   ├── MQTTProvider.swift  # Provider protocol
│       │   └── MQTTIdentifiable.swift
│       └── Util/
│           └── Loggable.swift      # Logging utility protocol
└── Tests/
    └── MQTTClientTests/
        ├── MQTTManagerTests.swift  # Unit tests for MQTTManager
        └── Mocks/
            ├── MockMQTTClient.swift
            └── MockMQTTConfig.swift

```

## File Organization
- **Protocols**: Located in `Sources/MQTTClient/Protocols/`
- **Utilities**: Located in `Sources/MQTTClient/Util/`
- **Core Implementation**: Root level of `Sources/MQTTClient/`
- **Tests**: Mirrored structure in `Tests/MQTTClientTests/`

## Build Configuration
The package defines conditional compilation flags for different environments:
- `DevDebug`
- `DevTestFlight`
- `StagingDebug`
- `StagingTestFlight`

These flags control logging behavior in the Loggable protocol.
