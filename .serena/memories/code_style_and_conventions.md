# Code Style and Conventions

## Naming Conventions
- **Classes/Structs/Protocols**: PascalCase (e.g., `MQTTClient`, `MQTTProvider`)
- **Properties/Methods**: camelCase (e.g., `mqttMessageSubject`, `startMQTT5`)
- **Constants**: camelCase
- **Protocol conformance**: Often used with protocol-oriented design

## Code Organization
1. **Properties** are declared before methods
2. **Public** members come before private/internal
3. **Static** members (like singletons) are declared first
4. Protocol extensions are used extensively for default implementations

## Comments
- File headers include:
  - File name
  - Empty creator/date section (usually just shows file name and date)
- Code uses Korean language for commit messages and some comments
- Minimal inline comments; code is expected to be self-documenting

## Swift Patterns Used
1. **Protocol-Oriented Programming**: Heavy use of protocols with extensions
2. **Singleton Pattern**: `MQTTClient.shared`
3. **Static Facade Pattern**: `MQTTManager` provides static methods wrapping the singleton
4. **Reactive Programming**: Combine publishers for events
5. **Dependency Injection**: `MQTTManager.setProvider()` for testing

## Type Annotations
- Type inference is used where clear
- Explicit types are used for protocol conformance and public APIs
- Properties use explicit types when conforming to protocols

## Access Control
- Public APIs are explicitly marked `public`
- Protocol methods are public
- Internal details are left implicit (default internal access)

## Testing
- Unit tests use XCTest framework
- Mocks are used for protocol implementations
- Tests are organized with Given-When-Then comments in Korean
- Use of `@testable import` for accessing internal members
