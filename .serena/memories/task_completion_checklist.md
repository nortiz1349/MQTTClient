# Task Completion Checklist

When completing a coding task in the MQTTClient project, follow these steps:

## 1. Code Quality
- [ ] Ensure code follows the existing style conventions
- [ ] Use protocol-oriented design where appropriate
- [ ] Add public access modifiers for public APIs
- [ ] Verify property types are correctly defined (user requirement: always check type definitions before use)

## 2. Testing
- [ ] Run tests: `swift test`
- [ ] Ensure all tests pass
- [ ] Add new tests for new functionality
- [ ] Update mock objects if protocols changed

## 3. Building
- [ ] Build the package: `swift build`
- [ ] Ensure no compilation errors or warnings
- [ ] Verify compatibility with iOS 15+ and macOS 13+

## 4. Documentation
- [ ] Add file headers if creating new files
- [ ] Document public APIs if needed
- [ ] Update protocol documentation if protocols changed

## 5. Git Commit
- [ ] Review changes: `git status` and `git diff`
- [ ] Stage relevant files: `git add <files>`
- [ ] Write commit message in Korean (based on project history)
- [ ] **IMPORTANT**: Do NOT add "Generated with Claude Code" or similar attribution in commit messages (user requirement)
- [ ] Commit follows project style (simple, descriptive, Korean)

## 6. Verification
- [ ] Check that logging is appropriate for environment flags
- [ ] Verify no hardcoded credentials or sensitive data
- [ ] Ensure dependency on CocoaMQTT is maintained at correct version

## Notes
- No linting/formatting tools are configured, so manual style consistency is important
- Korean language is preferred for commit messages
- User has specified: Always check how types and properties are defined before using them
- User has specified: Do not include Claude Code attribution in commit messages
