# 📖 Migration Guide

### From v2.x to v3.0.0

#### Background Colors

```swift
// ✅ v2.7.0 - Still works, but deprecated
RichText(html: html)
    .backgroundColor("transparent")     // Deprecated but functional

// 🚀 v3.0.0 - Recommended approaches
RichText(html: html)
    .transparentBackground()           // Easiest for transparent
    .backgroundColorHex("#FF0000")     // For hex colors  
    .backgroundColorSwiftUI(.blue)     // For SwiftUI colors
    .backgroundColor(.system)          // For system colors
```

#### Enhanced Features (Optional Upgrades)

```swift
// 🚀 Add error handling
RichText(html: html)
    .onError { error in
        print("Error: \(error)")
    }

// 🚀 Add interactive media handling
RichText(html: html)
    .onMediaClick { media in
        switch media {
        case .image(let src):
            presentImageViewer(src)
        case .video(let src):
            presentVideoPlayer(src)
        }
    }

// 🚀 Better loading experience with custom view
RichText(html: html)
    .placeholder {
        HStack(spacing: 8) {
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading...")
                .foregroundColor(.secondary)
        }
        .frame(minHeight: 60)
    }
    .loadingTransition(.fade)
```

#### Font & Color API Modernization

```swift
// ✅ v2.x - Still works, but deprecated
RichText(html: html)
    .foregroundColor(light: .black, dark: .white)  // Deprecated

// 🚀 v3.0.0 - Modern semantic naming
RichText(html: html)
    .textColor(light: .black, dark: .white)        // Modern & clear
```

#### Enhanced Font Rendering

No changes needed - font rendering is automatically improved:

```swift
// ✅ Automatically better in v3.0.0 with async/await
RichText(html: html)
    .fontType(.monospaced)    // Enhanced rendering
    .fontType(.italic)        // Improved CSS generation
```

### Recommended Migration Steps

1. **Update to v3.0.0**: Your existing code continues to work
2. **Add Error Handling**: Use `.onError()` for better debugging
3. **Update Background Colors**: Replace string-based with type-safe methods
4. **Add Media Handling**: Use `.onMediaClick()` for interactive content
5. **Improve Loading UX**: Add `.placeholder {}` with custom views and transitions

---

[← Back to README](../README.md)
