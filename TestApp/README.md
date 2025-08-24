# RichText Test App

This is a comprehensive test application for the RichText SwiftUI library. It demonstrates all features and functionalities.

## How to Run

### Option 1: Xcode
1. Open the RichText project in Xcode
2. Add this TestApp folder as a new target or open it separately
3. Run the app

### Option 2: Swift Package Manager
```bash
cd TestApp
swift run
```

### Option 3: Create New Xcode Project
1. Create a new SwiftUI app in Xcode
2. Add RichText as a package dependency: `https://github.com/NuPlay/RichText.git`
3. Copy the ContentView.swift content to your project

## Test Coverage

The test app covers all major features:

### ✅ Core Features
- [x] **Basic Usage** - Simple HTML rendering
- [x] **Background Colors** - All background color options (transparent, system, hex, SwiftUI colors)
- [x] **Font Types** - System, monospaced, italic, custom fonts
- [x] **Color Schemes** - Light, dark, auto modes with custom colors

### ✅ Advanced Features  
- [x] **Media Handling** - Image and video click events
- [x] **Error Handling** - Error callbacks and debugging
- [x] **Loading States** - Placeholders, transitions, custom loading views
- [x] **Custom CSS** - CSS injection and styling

### ✅ Interactive Features
- [x] **Link Handling** - Safari, SFSafariView, custom handlers
- [x] **Performance Testing** - Large content rendering
- [x] **Backward Compatibility** - Deprecated method testing

## What to Test

1. **Basic Rendering**: Check if HTML renders correctly
2. **Background Colors**: Verify all background options work
3. **Font Rendering**: Test monospaced and italic fonts (v3.0.0 improvements)
4. **Media Clicks**: Click on images and videos
5. **Error Handling**: Check error messages in console
6. **Loading States**: Watch loading animations and placeholders
7. **Link Behavior**: Test different link opening methods
8. **Performance**: Load large content and measure render time
9. **Backward Compatibility**: Ensure deprecated methods still work

## Expected Behavior

### New in v3.0.0
- **Better Font Rendering**: Monospaced and italic fonts should display correctly
- **Media Interaction**: Clicking images/videos should trigger callbacks
- **Enhanced Backgrounds**: Type-safe background color system
- **Error Handling**: Errors should be caught and reported
- **CSS Generation**: Programmatic CSS access should work

### Backward Compatibility
- **Deprecated Methods**: Should show compiler warnings but still function
- **String Background Colors**: Old `.backgroundColor("transparent")` should work
- **Existing Configurations**: All v2.x code should work unchanged

## Troubleshooting

If something doesn't work:

1. **Check Console**: Look for error messages or warnings
2. **Network Issues**: Some test images may not load due to network
3. **Platform Differences**: Some features work differently on iOS vs macOS
4. **Permissions**: macOS may need "Outgoing Connections" enabled

## Reporting Issues

If you find bugs or issues:
1. Note which test view shows the problem
2. Check console output for errors
3. Note your platform (iOS/macOS version)
4. Report to: https://github.com/NuPlay/RichText/issues