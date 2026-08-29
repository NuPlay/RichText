# Changelog

All notable changes to RichText are documented here.

---

## 3.1.0

A correctness release. Every change below is source-compatible - nothing public was removed.

### 🐛 **Fixes**

**Images were never constrained to the view width.** The image stylesheet is rendered with `String(format:)`, which eats a bare `%`, so `max-width: 100%` was emitted as `max-width: 100` - an invalid length the browser discards. Large images overflowed. ([#76](https://github.com/NuPlay/RichText/pull/76))

**Content was clipped and `<details>` never expanded.** The rendered height was measured exactly once, in `window.onload`. Anything that changed the layout afterwards - a `<details>` toggled open, late images, web fonts, rotation, Dynamic Type - was never reported back to SwiftUI. The container is now watched with a `ResizeObserver`. ([#18](https://github.com/NuPlay/RichText/issues/18), [#59](https://github.com/NuPlay/RichText/issues/59))

**The document was reloaded on every SwiftUI update.** `updateUIView` called `loadHTMLString` unconditionally, including for the height updates the view produces itself, so the document was re-parsed several times per appearance and all in-page state was thrown away. It now reloads only when the generated HTML or base URL actually changes. ([#60](https://github.com/NuPlay/RichText/issues/60))

**Dynamic Type silently discarded `fontType`.** `font: -apple-system-body` is a shorthand, and a shorthand resets `font-family`, so `supportsDynamicType: true` made `.monospaced`, `.italic` and `.customName` fall back to the default family. ([#63](https://github.com/NuPlay/RichText/issues/63))

**`SafariServices` was imported unconditionally**, which broke the build on platforms that do not ship it. ([#77](https://github.com/NuPlay/RichText/issues/77))

### 🚨 **Errors that now actually fire**

`RichTextError.webViewConfigurationFailed` and `.cssGenerationFailed` were documented but never constructed. They now report real failures:

```swift
RichText(html: html)
    .onError { error in
        switch error {
        case .cssGenerationFailed:
            // fontColor or linkColor holds an invalid hex value, so the browser
            // is dropping the declaration and the colour falls back to default
            break
        case .webViewConfigurationFailed:
            // macOS: the web view background could not be made transparent
            break
        default:
            break
        }
    }
```

`ColorSet.isValid` backs the first of those, and now accepts every hex form CSS accepts - `#RGB`, `#RGBA`, `#RRGGBB` and `#RRGGBBAA`. It previously rejected the two shorthand forms.

### 🏗️ **CSS is now built by interpolation**

The stylesheet and document templates were printf format strings. That is what caused the image bug above, and it also meant literal percent signs had to be escaped as `%%`. They are replaced by builders:

```swift
RichTextConstants.imageCSS(radius: 8)
RichTextConstants.textCSS(alignment:lineHeight:fontFamily:color:backgroundColor:)
RichTextConstants.iframeCSS(height: 250)
RichTextConstants.linkCSS(color: "#007AFF")
RichTextConstants.styleDocument(css:customCSS:)
RichTextConstants.styleDocument(lightCSS:darkCSS:customCSS:)
RichTextConstants.htmlDocument(css:body:)
```

Output is unchanged - each builder was diffed against the format string it replaces and all seven render byte-identical results.

### ⚠️ **Deprecations**

Nothing is removed; all of these still compile and behave as before.

| Deprecated | Use instead |
|---|---|
| `RichTextConstants.imageCSS` | `RichTextConstants.imageCSS(radius:)` |
| `RichTextConstants.textCSS` | `RichTextConstants.textCSS(alignment:lineHeight:fontFamily:color:backgroundColor:)` |
| `RichTextConstants.iframeCSS` | `RichTextConstants.iframeCSS(height:)` |
| `RichTextConstants.linkCSS` | `RichTextConstants.linkCSS(color:)` |
| `RichTextConstants.cssTemplate` | `RichTextConstants.styleDocument(css:customCSS:)` |
| `RichTextConstants.mediaCSSTemplate` | `RichTextConstants.styleDocument(lightCSS:darkCSS:customCSS:)` |
| `RichTextConstants.htmlTemplate` | `RichTextConstants.htmlDocument(css:body:)` |
| `RichTextConstants.bodyCSS` | nothing - it was never applied |
| `Configuration.isColorsImportant` | `.colorPreference(forceColor:)`, or `ColorSet(light:dark:isImportant:)` |

`Configuration.isColorsImportant` deserves a note: it was recorded but never read during CSS generation, so `Configuration(isColorsImportant: .all)` silently did nothing. `!important` comes from the colour sets alone.

```swift
// ❌ had no effect
Configuration(fontColor: ColorSet(light: "000000", dark: "FFFFFF"), isColorsImportant: .all)

// ✅ either of these works
RichText(html: html).colorPreference(forceColor: .all)
Configuration(fontColor: ColorSet(light: "000000", dark: "FFFFFF", isImportant: true))
```

### 🧹 **Also**

- `loading: lazy` removed from the image CSS. `loading` is an HTML attribute, not a CSS property, so no browser ever applied it.
- Percentage `min-height`/`max-height` removed from the image CSS. Both resolved against an `auto`-height containing block and did nothing.
- macOS transparency no longer risks an uncatchable `NSUnknownKeyException`.

---

## 3.0.0

### 🚀 **Core Modernization**

- **⚡ Async/Await Architecture**: Complete rewrite using modern Swift concurrency for better performance and reliability
- **🛡️ Enhanced Type Safety**: Robust ColorSet equality comparison and validation with RGBA-based color handling
- **⚙️ Performance Optimizations**: Frame update debouncing, improved WebView management, and reduced main thread blocking
- **📊 Comprehensive Logging**: Built-in performance monitoring with os.log integration

### 🎨 **Enhanced User Experience**

- **🎨 Type-Safe Background Colors**: Complete background color system with `.transparent`, `.system`, `.hex()`, and `.color()` support
- **📱 Interactive Media Handling**: Full media click event system for images and videos with custom action support
- **🔧 Improved Font System**: Better monospace and italic rendering with enhanced CSS generation
- **🔄 Modern Loading States**: Type-safe loading transitions with `.fade`, `.scale`, `.slide`, and custom animations

### 🛠️ **Developer Experience**

- **🧪 Swift Testing Migration**: Complete migration from XCTest to modern Swift Testing framework
- **📖 Semantic API Naming**: Modern APIs like `.textColor()` replacing `.foregroundColor()` for better clarity
- **🚨 Comprehensive Error Handling**: Detailed error types with custom callbacks and debugging support
- **🛠️ Public CSS Access**: Programmatic CSS generation and access for advanced customization scenarios
- **🌐 Enhanced HTML5 Support**: Complete support for `<figure>`, `<details>`, `<summary>`, `<figcaption>`, and semantic elements

### 🔄 **Migration & Compatibility**

- **✅ 100% Backward Compatible**: All v2.x code works without changes
- **⚠️ Thoughtful Deprecations**: Deprecated methods include clear migration guidance
- **📚 Migration Tooling**: Built-in TestApp with Modern API demo and migration examples

### 🔄 **Backward Compatibility Promise**

Version 3.0.0 maintains **100% backward compatibility** for v2.x users while providing a clear path to modern APIs:

- ✅ **Zero Breaking Changes**: All existing v2.x code works unchanged
- ✅ **Automatic Performance**: Better async/await performance and font rendering without code changes
- ✅ **Guided Migration**: Helpful deprecation warnings with clear modern API alternatives
- ✅ **Additive Enhancement**: New features are optional and don't affect existing functionality
- ✅ **Future-Proof**: Modern architecture ready for Swift 6+ and future iOS/macOS versions

### 🎯 **Recommended Migration Path**

1. **Update to v3.0.0**: Immediate performance and reliability improvements
2. **Add Error Handling**: Use `.onError()` for better debugging and user experience
3. **Modernize APIs**: Replace deprecated methods with type-safe alternatives
4. **Enhance Interactivity**: Add `.onMediaClick()` for rich media experiences
5. **Improve Loading UX**: Implement `.placeholder {}` and modern transitions
