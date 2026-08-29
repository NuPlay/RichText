# RichText

<p align="center">
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/Swift-5.9+-F05138?labelColor=303840" alt="Swift: 5.9+">
    </a>
    <a href="https://www.apple.com/ios/">
        <img src="https://img.shields.io/badge/iOS-15.0+-007AFF?labelColor=303840" alt="iOS: 15.0+">
    </a>
    <a href="https://www.apple.com/macos/">
        <img src="https://img.shields.io/badge/macOS-12.0+-007AFF?labelColor=303840" alt="macOS-12.0+">
    </a>
    <a href="https://developer.apple.com/xcode/">
        <img src="https://img.shields.io/badge/Xcode-16+-blue?labelColor=303840" alt="Xcode: 16+">
    </a>
    <a href="https://github.com/NuPlay/RichText/actions/workflows/ci.yml">
        <img src="https://github.com/NuPlay/RichText/actions/workflows/ci.yml/badge.svg" alt="CI">
    </a>
    <a href="https://github.com/NuPlay/RichText/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/NuPlay/RichText" alt="License">
    </a>
    <a href="https://github.com/NuPlay/RichText/releases">
        <img src="https://img.shields.io/github/v/release/NuPlay/RichText" alt="Release">
    </a>
</p>

**Render HTML in SwiftUI.**

RichText sizes itself to its content, so HTML fits into a layout like any other view.

Styling, light and dark theming, custom fonts, media callbacks and typed errors are built in.

![github](https://user-images.githubusercontent.com/73557895/128497417-52d47524-05bf-48af-ae0a-e0cdffdbedf5.png)

| <img width="1440" alt="Light Mode Screenshot" src="https://user-images.githubusercontent.com/73557895/131149958-bbc28435-02e2-4a02-8ad5-43627cd333e0.png"> 	| <img width="1440" alt="Dark Mode Screenshot" src="https://user-images.githubusercontent.com/73557895/131149926-211e2111-6d6e-4aac-94b8-44c7230b6244.png"> 	|
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------:	|:------------------------------------------------------------------------------------------------------------------------------:	|
| Light Mode                                                                                                                                                                 	| Dark Mode                                                                                                                        	|

---

## ✨ Features

- **Cross-platform** — iOS 15.0+ and macOS 12.0+, Swift 5.9+
- **Automatic sizing** — the view resizes itself as the content lays out, including late images, web fonts and `<details>` toggles
- **Theming** — automatic light/dark mode, custom color sets, transparent or custom backgrounds
- **Typography** — system, monospaced, italic, custom and bundled fonts, with Dynamic Type support
- **Interactive media** — click callbacks for images and videos
- **Link handling** — Safari, `SFSafariViewController`, or your own handler
- **HTML5** — `<figure>`, `<details>`, `<summary>`, `<figcaption>` and the semantic elements
- **Error reporting** — typed errors for load, configuration and CSS failures

> tvOS and watchOS are not supported: Apple does not ship `WKWebView` on those platforms.

---

## 🚀 Quick Start

```swift
import SwiftUI
import RichText

struct ContentView: View {
    let html = """
        <h1>Welcome to RichText</h1>
        <p>A powerful HTML renderer for SwiftUI.</p>
    """

    var body: some View {
        ScrollView {
            RichText(html: html)
                .colorScheme(.auto)
                .lineHeight(170)
                .imageRadius(12)
                .placeholder { ProgressView() }
                .onMediaClick { media in
                    if case .image(let src) = media { print(src) }
                }
                .onError { error in print(error) }
        }
    }
}
```

See [the API reference](docs/API.md) for every modifier, and [advanced usage](docs/ADVANCED.md) for custom fonts, themes and complete examples.

---

## 📦 Installation

### Swift Package Manager (Recommended)

1. In Xcode, select **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/NuPlay/RichText.git
   ```
3. Select version rule: **"Up to Next Major Version"** from **"3.1.1"**
4. Click **Add Package**

### Manual Package.swift

Add RichText to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/NuPlay/RichText.git", .upToNextMajor(from: "3.1.1"))
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["RichText"]
    )
]
```

---

## 📖 Documentation

| Document | Contents |
|---|---|
| [API Reference](docs/API.md) | Every initializer, modifier and utility |
| [Advanced Usage](docs/ADVANCED.md) | Custom fonts, theming, media handling, performance, full examples |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common issues and platform-specific notes |
| [Migration Guide](docs/MIGRATION.md) | Upgrading from v2.x |
| [Changelog](CHANGELOG.md) | Release notes |
| [Contributing](CONTRIBUTING.md) | How to report issues and send patches |

---

## 🌟 Used By

Open-source apps that render their content with RichText:

| Project | What it is |
|---|---|
| [IBM/mac-ibm-notifications](https://github.com/IBM/mac-ibm-notifications) | macOS agent for displaying notifications and alerts to managed devices |
| [AudioBooth](https://github.com/AudioBooth/AudioBooth) | iOS companion app for Audiobookshelf |

Each of these declares RichText in its public dependency manifest. No affiliation or endorsement is implied in either direction. Using RichText in your project? Open a PR to add it.

---

## 📄 License

RichText is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

## 🙏 Acknowledgments

- Built with [WebKit](https://webkit.org/) for reliable HTML rendering
- Inspired by the SwiftUI community's need for rich text solutions
- Thanks to all [contributors](https://github.com/NuPlay/RichText/contributors) and users

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/NuPlay/RichText/issues)
- **Discussions**: [GitHub Discussions](https://github.com/NuPlay/RichText/discussions)

---

*Made with ❤️ for the SwiftUI community*
