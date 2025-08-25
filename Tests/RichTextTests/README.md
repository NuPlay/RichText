# RichText Testing Guide

This directory contains comprehensive tests for the RichText library using the modern Swift Testing framework.

## Test Files Overview

### `RichTextSwiftTestingTests.swift` (Swift Testing)
- **Framework**: Swift Testing (modern testing framework introduced in 2024)
- **Compatibility**: Requires Swift 6.0+ with Xcode 16 or later
- **Platform Support**: iOS 16.0+, macOS 13.0+
- **Features**: Modern syntax with `@Test`, `#expect`, `#require` macros

## Running Tests

### Using Swift Package Manager
```bash
# Run all tests (requires Swift 6.0+)
swift test

# Run Swift Testing tests specifically
swift test --filter RichTextSwiftTestingTests
```

### Using Xcode
1. Open the RichText package in Xcode (requires Xcode 16+)
2. Use ⌘+U to run all tests
3. Swift Testing tests will appear in the Test Navigator
4. Tests will be grouped by `@Suite` names

## Test Coverage

The test file provides comprehensive coverage of:

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
- **Swift Testing**: Requires iOS 16.0+, macOS 13.0+, Swift 6.0+, Xcode 16+
- **Library itself**: Works with iOS 15.0+, macOS 12.0+, Swift 5.9+

## Swift Testing Syntax Reference

Key syntax differences from XCTest:

| XCTest (Not used in this project) | Swift Testing (Used here) |
|-----------------------------------|---------------------------|
| `XCTAssertEqual(a, b)` | `#expect(a == b)` |
| `XCTAssertTrue(condition)` | `#expect(condition)` |
| `XCTAssertNotNil(value)` | `#expect(value != nil)` |
| `XCTFail("message")` | `#expect(Bool(false), "message")` |
| `func testExample()` | `@Test func example()` |
| Class-based organization | Struct-based with `@Suite` |

## Best Practices

1. **Swift 6.0+ Required**: Ensure you have Swift 6.0+ and Xcode 16+ to run tests
2. **Performance Testing**: Swift Testing provides better performance insights with modern tooling
3. **Error Messages**: Swift Testing provides more detailed failure messages with captured values
4. **Parameterized Testing**: Use Swift Testing's native parameterization for testing multiple scenarios
5. **Test Coverage**: The single test file ensures comprehensive coverage with modern syntax

## Contributing

When adding new tests:
1. Use Swift Testing's modern syntax with `@Test` and `@Suite`
2. Add parameterized tests for multiple scenarios
3. Ensure test coverage for all new functionality
4. Include performance and edge case testing
5. Use descriptive test names and suite organization

The Swift Testing framework ensures the RichText library maintains high quality and reliability across all supported platforms.