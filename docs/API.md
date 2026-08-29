# 📚 Complete API Reference

### Core Components

#### RichText Initializers

```swift
// Basic initializer
RichText(html: String)

// With configuration
RichText(html: String, configuration: Configuration)

// With placeholder
RichText(html: String, placeholder: AnyView?)

// Full initializer
RichText(html: String, configuration: Configuration, placeholder: AnyView?)
```

### Styling Modifiers

#### Background Colors

```swift
// Recommended approaches (v3.0.0+)
.transparentBackground()                    // Transparent (default)
.backgroundColor(.system)                   // System default (white/black)
.backgroundColorHex("FF0000")              // Hex color
.backgroundColorSwiftUI(.blue)             // SwiftUI Color
.backgroundColor(.color(.green))           // Using BackgroundColor enum

// Legacy approach (still works, but deprecated)
.backgroundColor("transparent")             // Deprecated but backward compatible
```

#### Typography & Colors

```swift
// Font configuration
.fontType(.system)                         // System font (default)
.fontType(.monospaced)                     // Monospaced font
.fontType(.italic)                         // Italic font
.fontType(.customName("Helvetica"))        // Custom font by name
.fontType(.custom(UIFont.systemFont(ofSize: 16))) // Custom UIFont (iOS only)

// Text colors - Modern API (v3.0.0+)
.textColor(light: Color.primary, dark: Color.primary) // Modern semantic naming

// Legacy text colors (deprecated but supported)
.foregroundColor(light: Color.primary, dark: Color.primary) // SwiftUI Colors (deprecated)
.foregroundColor(light: UIColor.black, dark: UIColor.white) // UIColors (deprecated)
.foregroundColor(light: NSColor.black, dark: NSColor.white) // NSColors (deprecated)

// Link colors
.linkColor(light: Color.blue, dark: Color.cyan) // SwiftUI Colors
.linkColor(light: UIColor.blue, dark: UIColor.cyan) // UIColors

// Color enforcement
.colorPreference(forceColor: .onlyLinks)   // Force only link colors (default)
.colorPreference(forceColor: .all)         // Force all colors
.colorPreference(forceColor: .none)        // Don't force any colors
```

#### Layout & Spacing

```swift
.lineHeight(170)                           // Line height percentage (default: 170)
.imageRadius(12)                           // Image border radius in points (default: 0)
.colorScheme(.auto)                        // .auto (default), .light, .dark
.forceColorSchemeBackground(true)          // Force background color override
```

#### Link Behavior

```swift
.linkOpenType(.Safari)                     // Open in Safari (default)
.linkOpenType(.SFSafariView())            // Open in SFSafariViewController (iOS)
.linkOpenType(.SFSafariView(               // Advanced SFSafariView config
    configuration: config,
    isReaderActivated: true,
    isAnimated: true
))
.linkOpenType(.custom { url in             // Custom link handler
    // Handle URL yourself
})
.linkOpenType(.none)                       // Don't handle link taps
```

### Advanced Features

#### Loading States

```swift
// Loading placeholders (Modern approach - recommended)
.placeholder {                             // Custom placeholder view
    HStack(spacing: 8) {
        ProgressView()
            .scaleEffect(0.8)
        Text("Loading content...")
            .foregroundColor(.secondary)
    }
    .frame(minHeight: 60)
}

// Deprecated methods (still supported for backward compatibility)
.loadingPlaceholder("Loading...")          // Deprecated - use placeholder {}
.loadingText("Please wait...")             // Deprecated - use placeholder {}

// Loading transitions
.loadingTransition(.fade)                  // Fade transition
.loadingTransition(.slide)                 // Slide transition
.loadingTransition(.scale)                 // Scale transition
.loadingTransition(.custom(.easeInOut))    // Custom animation
.transition(.easeOut)                      // Legacy transition method
```

#### Event Handling

```swift
// Media click events (v3.0.0+)
.onMediaClick { media in
    switch media {
    case .image(let src):
        // Handle image clicks
        presentImageViewer(src)
    case .video(let src):
        // Handle video clicks
        presentVideoPlayer(src)
    }
}

// Error handling (v3.0.0+)
.onError { error in
    switch error {
    case .htmlLoadingFailed(let html):
        // The web view failed to load the generated document
        print("Failed to load HTML: \(html)")
    case .webViewConfigurationFailed:
        // The web view could not be configured as requested (macOS transparency)
        print("WebView configuration failed")
    case .cssGenerationFailed:
        // A colour was given as an invalid hex value, so the browser drops the declaration
        print("CSS generation failed")
    case .mediaHandlingFailed(let media):
        print("Media handling failed: \(media)")
    }
}
```

#### Custom Styling

```swift
// Custom CSS
.customCSS("""
    p { margin: 10px 0; }
    h1 { color: #ff6b6b; }
    img { box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
""")

// Base URL for relative resources
.baseURL(Bundle.main.bundleURL)
```

### Configuration-Based Initialization

For complex configurations, create a `Configuration` object:

```swift
let config = Configuration(
    customCSS: "body { padding: 20px; }",
    supportsDynamicType: true,              // Enable Dynamic Type
    fontType: .system,
    fontColor: ColorSet(light: "333333", dark: "CCCCCC"),
    lineHeight: 180,
    colorScheme: .auto,
    forceColorSchemeBackground: false,
    backgroundColor: .transparent,
    imageRadius: 8,
    linkOpenType: .Safari,
    linkColor: ColorSet(light: "007AFF", dark: "0A84FF", isImportant: true),
    baseURL: Bundle.main.bundleURL,
    mediaClickHandler: { media in /* handle clicks */ },
    errorHandler: { error in /* handle errors */ },
    transition: .easeInOut(duration: 0.3)
)

RichText(html: htmlContent, configuration: config)
```

### Utility Methods

```swift
// Generate CSS programmatically (v3.0.0+)
let richText = RichText(html: html)
let richTextCSS = richText.generateCSS(colorScheme: .light, alignment: .center)

// Generate CSS from configuration
let config = Configuration(lineHeight: 150)
let configurationCSS = config.generateCompleteCSS(colorScheme: .dark)
```

Individual rules can be built directly (v3.1.0+). These replace the deprecated
`String(format:)` constants, so percent signs no longer need escaping:

```swift
RichTextConstants.imageCSS(radius: 8)
// img{height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: 8.0px;}

RichTextConstants.iframeCSS(height: 250)
// iframe{width:100%; height:250px; border: none;}

RichTextConstants.linkCSS(color: "#007AFF")
// a:link {color: #007AFF; transition: color 0.2s ease;}
```

---

[← Back to README](../README.md)
