# RichText Testing Guide

This directory contains comprehensive tests for the RichText library using both traditional XCTest and modern Swift Testing frameworks.

## Test Files Overview

### 1. `RichTextTests.swift` (XCTest)
- **Framework**: XCTest (traditional testing framework)
- **Compatibility**: Works with all Swift versions and Xcode versions
- **Platform Support**: iOS 13.0+, macOS 10.15+
- **Features**: Complete test coverage with XCTest assertions

### 2. `RichTextSwiftTestingTests.swift` (Swift Testing)
- **Framework**: Swift Testing (modern testing framework introduced in 2024)
- **Compatibility**: Requires Swift 6.0+ with Xcode 16 or later
- **Platform Support**: iOS 16.0+, macOS 13.0+
- **Features**: Modern syntax with `@Test`, `#expect`, `#require` macros

## Running Tests

### Using Swift Package Manager
```bash
# Run all tests (XCTest only if Swift Testing not available)
swift test

# Run specific test class (XCTest)
swift test --filter RichTextTests

# Run Swift Testing tests (requires Swift 6.0+)
swift test --filter RichTextSwiftTestingTests
```

### Using Xcode
1. Open the RichText package in Xcode
2. Use ⌘+U to run all tests
3. Both XCTest and Swift Testing tests will appear in the Test Navigator
4. Swift Testing tests will be grouped by `@Suite` names

## Test Coverage

Both test files provide comprehensive coverage of:

### Core Functionality
- ✅ Configuration initialization and customization
- ✅ ColorSet creation and CSS generation
- ✅ Font type handling (system, custom, monospaced, italic)
- ✅ RichText view initialization with various options
- ✅ CSS generation for different themes and alignments

### New Features (v3.0.0)
- ✅ Background color enum system (`BackgroundColor`)
- ✅ Media click handling (`MediaClickType`)
- ✅ Error handling (`RichTextError`)
- ✅ Loading transitions and placeholders
- ✅ Enhanced font rendering
- ✅ HTML5 semantic element support

### Backward Compatibility
- ✅ Deprecated string-based background color methods
- ✅ `ColorScheme` typealias compatibility
- ✅ Migration path validation

### Performance & Edge Cases
- ✅ Configuration creation performance
- ✅ CSS generation performance
- ✅ Empty HTML handling
- ✅ Large HTML content
- ✅ Special character handling

## Swift Testing Features Demonstrated

The Swift Testing file showcases modern testing patterns:

### Parameterized Tests
```swift
@Test("CSS Generation produces valid output", arguments: [
    (true, TextAlignment.leading, "text-align:left"),
    (false, TextAlignment.center, "text-align:center"),
    (true, TextAlignment.trailing, "text-align:right")
])
func cssGeneration(isLight: Bool, alignment: TextAlignment, expectedAlignment: String) {
    // Test implementation with multiple parameter combinations
}
```

### Test Suites Organization
```swift
@Suite("RichText Configuration Tests")
struct ConfigurationTests {
    @Test("Configuration defaults are correct")
    func configurationDefaults() {
        // Modern assertion syntax
        #expect(config.customCSS == "")
        #expect(config.supportsDynamicType == false)
    }
}
```

### Modern Assertions
- `#expect()` - Expressive assertions with detailed failure messages
- `#require()` - Critical assertions that stop test execution on failure
- Support for async/throws test functions

### Tags and Filtering
```swift
@Test(.tags(.performance))
func performanceTest() {
    // Tagged for selective test running
}
```

## Compatibility Notes

### Swift Testing Availability
- **Available**: Swift 6.0+ with Xcode 16 or later
- **Fallback**: If Swift Testing is not available, the file provides clear error messages
- **Conditional Compilation**: Uses `#if canImport(Testing)` for graceful degradation

### Platform Requirements
- **XCTest**: Works with iOS 13.0+, macOS 10.15+
- **Swift Testing**: Requires iOS 16.0+, macOS 13.0+ for full compatibility

## Migration from XCTest to Swift Testing

Key differences when migrating:

| XCTest | Swift Testing |
|--------|---------------|
| `XCTAssertEqual(a, b)` | `#expect(a == b)` |
| `XCTAssertTrue(condition)` | `#expect(condition)` |
| `XCTAssertNotNil(value)` | `#expect(value != nil)` |
| `XCTFail("message")` | `#expect(Bool(false), "message")` |
| `func testExample()` | `@Test func example()` |
| Class-based organization | Struct-based with `@Suite` |

## Best Practices

1. **Run Both Test Suites**: During development, run both XCTest and Swift Testing to ensure comprehensive coverage
2. **Platform Targeting**: Use XCTest for broader compatibility, Swift Testing for modern features
3. **Performance Testing**: Swift Testing provides better performance insights with modern tooling
4. **Error Messages**: Swift Testing provides more detailed failure messages with captured values
5. **Parameterized Testing**: Use Swift Testing's native parameterization for testing multiple scenarios

## Contributing

When adding new tests:
1. Add corresponding tests to both files when possible
2. Use Swift Testing's modern syntax for new features
3. Maintain backward compatibility tests in XCTest version
4. Ensure test coverage for all new functionality
5. Include performance and edge case testing

Both testing approaches ensure the RichText library maintains high quality and reliability across all supported platforms and Swift versions.