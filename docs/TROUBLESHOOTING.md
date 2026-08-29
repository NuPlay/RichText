# 🐛 Troubleshooting

### Common Issues

#### Content Not Displaying

**Problem**: RichText shows blank or doesn't render content

**Solutions**:
- Ensure HTML is valid and well-formed
- Check that images have proper URLs
- Verify network permissions for external resources
- Add error handling to debug loading issues

```swift
RichText(html: html)
    .onError { error in
        print("Debug error: \(error)")
    }
```

#### Images Not Loading

**Problem**: Images don't appear in the rendered content

**Solutions**:
- Verify image URLs are accessible
- For macOS: Enable "Outgoing Connections (Client)" in App Sandbox
- Use base URL for relative image paths

```swift
RichText(html: html)
    .baseURL(Bundle.main.bundleURL)  // For bundled resources
```

#### Performance Issues

**Problem**: Slow rendering with large HTML content

**Solutions**:
- Simplify CSS and reduce inline styles
- Use image compression for better loading
- Consider pagination for very large content
- Disable animations for better performance

```swift
RichText(html: largeContent)
    .loadingTransition(.none)
    .imageRadius(0)
```

#### Dark Mode Issues

**Problem**: Colors don't adapt properly to dark mode

**Solutions**:
- Use `.colorScheme(.auto)` for automatic adaptation
- Set proper light/dark colors for text and links
- Force color scheme background if needed

```swift
RichText(html: html)
    .colorScheme(.auto)
    .forceColorSchemeBackground(true)
    .foregroundColor(light: .black, dark: .white)
```

### Platform-Specific Issues

#### macOS Specific

**Issue**: External resources don't load
- **Solution**: Enable "Outgoing Connections (Client)" in App Sandbox settings
- **Alternative**: Use bundled resources or file URLs

**Issue**: Scrolling behavior differs from iOS
- **Solution**: This is expected due to platform differences
- **Workaround**: Embed in a ScrollView for consistent behavior

#### iOS Specific

**Issue**: SFSafariViewController not presenting
- **Solution**: Ensure you have a presented view controller
- **Alternative**: Use `.linkOpenType(.Safari)` as fallback

#### tvOS / watchOS

**Issue**: The package does not build for tvOS or watchOS
- **Cause**: `RichText` renders HTML through `WKWebView`, and Apple does not ship `WKWebView` on tvOS or watchOS. There is no supported way to display a web view on those platforms.
- **Solution**: Render the content natively on those platforms, for example with `AttributedString` and `Text`.

### Memory Management

If you experience memory issues with large content:

```swift
// Implement proper cleanup
struct ContentView: View {
    @State private var html = ""
    
    var body: some View {
        RichText(html: html)
            .onDisappear {
                html = ""  // Clear content when not visible
            }
    }
}
```

### Getting Help

1. **Check the Issues**: Search [GitHub Issues](https://github.com/NuPlay/RichText/issues) for similar problems
2. **Provide Details**: When reporting issues, include:
   - iOS/macOS version
   - RichText version
   - Sample HTML content
   - Error messages or console output
3. **Create Minimal Example**: Provide a minimal reproducible example

---

[← Back to README](../README.md)
