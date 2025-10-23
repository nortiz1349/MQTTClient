# Suggested Commands for MQTTClient Development

## Building
```bash
# Build the package
swift build

# Build for release
swift build -c release
```

## Testing
```bash
# Run all tests
swift test

# Run tests with verbose output
swift test --verbose

# Run specific test
swift test --filter MQTTManagerTests
```

## Package Management
```bash
# Update dependencies
swift package update

# Resolve dependencies
swift package resolve

# Reset package cache
swift package reset

# Generate Xcode project (if needed)
swift package generate-xcodeproj
```

## Git Operations (Common)
```bash
# Check status
git status

# View recent commits
git log --oneline -10

# Stage changes
git add .

# Commit (Korean messages preferred based on git history)
git commit -m "커밋 메시지"

# Push
git push origin main
```

## macOS-Specific Commands
```bash
# List files
ls -la

# Find files
find . -name "*.swift"

# Search in files
grep -r "MQTTClient" Sources/

# View file
cat Sources/MQTTClient/MQTTClient.swift
```

## Xcode Integration
Since this is a Swift package, it can be:
1. Opened directly in Xcode via Package.swift
2. Integrated into other Xcode projects as a local or remote dependency
3. Developed using Xcode's SPM support

## Environment Notes
- Platform: Darwin (macOS)
- No linting tools (SwiftLint, swift-format) detected in the project
- No CI/CD configuration files found
