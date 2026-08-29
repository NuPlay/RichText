# 🔧 Advanced Usage

### Custom Fonts

#### Using System-Installed Fonts

```swift
RichText(html: html)
    .fontType(.customName("SF Mono"))      // System monospace font
    .fontType(.customName("Helvetica"))    // System Helvetica
```

#### Using Bundled Fonts

```swift
RichText(html: html)
    .fontType(.customName("CustomFont-Regular"))
    .customCSS("""
        @font-face {
            font-family: 'CustomFont-Regular';
            src: url("CustomFont-Regular.ttf") format('truetype');
        }
    """)
```

#### Dynamic Type Support

```swift
let config = Configuration(
    supportsDynamicType: true               // Automatically use iOS Dynamic Type
)

RichText(html: html, configuration: config)
```

### Complex Color Schemes

#### Gradient Backgrounds

```swift
RichText(html: html)
    .backgroundColor(.transparent)
    .customCSS("""
        body {
            background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
            padding: 20px;
            border-radius: 12px;
        }
    """)
```

#### Theme-Aware Colors

```swift
RichText(html: html)
    .foregroundColor(light: .primary, dark: .primary)
    .linkColor(light: .blue, dark: .cyan)
    .backgroundColor(.system)
    .colorPreference(forceColor: .all)      // Override HTML colors
```

### Interactive Media Handling

```swift
struct ContentView: View {
    @State private var selectedImage: String?
    
    var body: some View {
        RichText(html: htmlWithImages)
            .onMediaClick { media in
                switch media {
                case .image(let src):
                    selectedImage = src
                case .video(let src):
                    openVideoPlayer(url: src)
                }
            }
            .fullScreenCover(item: Binding<String?>(
                get: { selectedImage },
                set: { selectedImage = $0 }
            )) { imageURL in
                ImageViewer(url: imageURL)
            }
    }
}
```

### Error Handling and Debugging

```swift
struct ContentView: View {
    @State private var lastError: RichTextError?
    
    var body: some View {
        VStack {
            if let error = lastError {
                ErrorBanner(error: error)
            }
            
            RichText(html: html)
                .onError { error in
                    lastError = error
                    // Log to analytics
                    Analytics.log("RichText Error", parameters: [
                        "error_type": String(describing: error),
                        "html_length": html.count
                    ])
                }
        }
    }
}
```

### Performance Optimization

#### For Large Content

```swift
RichText(html: largeHtmlContent)
    .imageRadius(0)                         // Disable image styling for performance
    .customCSS("""
        img {
            max-width: 100%;
            height: auto;
        }
    """)
    .loadingTransition(.none)              // Disable transitions for faster rendering
```

#### Memory Management

```swift
struct ContentView: View {
    @StateObject private var htmlManager = HTMLContentManager()
    
    var body: some View {
        RichText(html: htmlManager.currentHTML)
            .onError { error in
                htmlManager.handleError(error)
            }
            .onDisappear {
                htmlManager.cleanup()       // Custom cleanup logic
            }
    }
}
```

---

## 💡 Examples

### Blog Post Renderer

```swift
struct BlogPostView: View {
    let post: BlogPost
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                RichText(html: post.content)
                    .lineHeight(175)
                    .imageRadius(8)
                    .backgroundColor(.system)
                    .linkOpenType(.SFSafariView())
                    .onMediaClick { media in
                        handleMediaClick(media)
                    }
                    .customCSS("""
                        blockquote {
                            border-left: 4px solid #007AFF;
                            padding-left: 16px;
                            margin: 16px 0;
                            font-style: italic;
                        }
                        code {
                            background-color: #f5f5f5;
                            padding: 2px 4px;
                            border-radius: 3px;
                        }
                    """)
            }
            .padding()
        }
    }
    
    private func handleMediaClick(_ media: MediaClickType) {
        // Custom media handling
    }
}
```

### Email Content Viewer

```swift
struct EmailView: View {
    let emailHTML: String
    @State private var isLoading = true
    
    var body: some View {
        RichText(html: emailHTML)
            .backgroundColor(.system)
            .lineHeight(160)
            .fontType(.system)
            .linkOpenType(.custom { url in
                // Custom link handling for email safety
                if url.host?.contains("trusted-domain.com") == true {
                    UIApplication.shared.open(url)
                } else {
                    showLinkConfirmation(url)
                }
            })
            .placeholder {
                Text("Loading email...")
            }
            .loadingTransition(.fade)
            .onError { error in
                print("Email loading error: \(error)")
            }
    }
    
    private func showLinkConfirmation(_ url: URL) {
        // Show confirmation dialog
    }
}
```

### Documentation Viewer

```swift
struct DocumentationView: View {
    let markdownHTML: String
    
    var body: some View {
        NavigationView {
            RichText(html: markdownHTML)
                .fontType(.system)
                .lineHeight(170)
                .backgroundColor(.transparent)
                .customCSS("""
                    h1, h2, h3 { 
                        color: #1d4ed8; 
                        margin-top: 24px;
                        margin-bottom: 12px;
                    }
                    pre {
                        background-color: #f8f9fa;
                        padding: 12px;
                        border-radius: 6px;
                        overflow-x: auto;
                    }
                    code {
                        font-family: 'SF Mono', 'Monaco', 'Consolas', monospace;
                    }
                """)
                .navigationTitle("Documentation")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
```

---

[← Back to README](../README.md)
