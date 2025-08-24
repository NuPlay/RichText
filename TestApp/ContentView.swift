import SwiftUI
import RichText

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Basic Usage", destination: BasicUsageView())
                NavigationLink("Background Colors", destination: BackgroundColorView())
                NavigationLink("Font Types", destination: FontTypesView())
                NavigationLink("Color Schemes", destination: ColorSchemesView())
                NavigationLink("Media Handling", destination: MediaHandlingView())
                NavigationLink("Error Handling", destination: ErrorHandlingView())
                NavigationLink("Loading States", destination: LoadingStatesView())
                NavigationLink("Custom CSS", destination: CustomCSSView())
                NavigationLink("Link Handling", destination: LinkHandlingView())
                NavigationLink("Performance Test", destination: PerformanceTestView())
                NavigationLink("Backward Compatibility", destination: BackwardCompatibilityView())
            }
            .navigationTitle("RichText Tests")
        }
    }
}

// MARK: - Basic Usage Test
struct BasicUsageView: View {
    let basicHTML = """
        <h1>Basic RichText Test</h1>
        <p>This is a <strong>simple test</strong> of basic HTML rendering.</p>
        <p>It should display <em>italic text</em> and <u>underlined text</u>.</p>
        <ul>
            <li>List item 1</li>
            <li>List item 2</li>
            <li>List item 3</li>
        </ul>
    """
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Basic HTML Rendering")
                    .font(.title2)
                    .fontWeight(.bold)
                
                RichText(html: basicHTML)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                Text("With Default Styling")
                    .font(.headline)
                
                RichText(html: basicHTML)
                    .lineHeight(170)
                    .colorScheme(.auto)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Basic Usage")
    }
}

// MARK: - Background Color Tests
struct BackgroundColorView: View {
    let testHTML = """
        <h2>Background Color Test</h2>
        <p>This content tests different background color options.</p>
        <p>The background should change based on the selected option.</p>
    """
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Transparent Background (Default)")
                            .font(.headline)
                        
                        RichText(html: testHTML)
                            .transparentBackground()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("System Background")
                            .font(.headline)
                        
                        RichText(html: testHTML)
                            .backgroundColor(.system)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hex Color Background")
                            .font(.headline)
                        
                        RichText(html: testHTML)
                            .backgroundColorHex("E3F2FD")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SwiftUI Color Background")
                            .font(.headline)
                        
                        RichText(html: testHTML)
                            .backgroundColorSwiftUI(.blue.opacity(0.1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Test backward compatibility
                VStack(alignment: .leading, spacing: 10) {
                    Text("Backward Compatible (Deprecated)")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .backgroundColor("#FFE0E0")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle("Background Colors")
    }
}

// MARK: - Font Types Test
struct FontTypesView: View {
    let testHTML = """
        <p>This is sample text to test different font types.</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
        <code>console.log("Hello, World!");</code>
    """
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("System Font (Default)")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .fontType(.system)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Monospaced Font")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .fontType(.monospaced)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Italic Font")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .fontType(.italic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Custom Font (Helvetica)")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .fontType(.customName("Helvetica"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle("Font Types")
    }
}

// MARK: - Color Schemes Test
struct ColorSchemesView: View {
    let testHTML = """
        <h2>Color Scheme Test</h2>
        <p>This tests light and dark mode support.</p>
        <p>Text should adapt to the selected color scheme.</p>
        <a href="https://example.com">This is a test link</a>
    """
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Auto Color Scheme")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .colorScheme(.auto)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Light Mode")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .colorScheme(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Dark Mode")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .colorScheme(.dark)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Custom Colors")
                        .font(.headline)
                    
                    RichText(html: testHTML)
                        .foregroundColor(light: Color.red, dark: .cyan)
                        .linkColor(light: Color.blue, dark: .orange)
                        .colorPreference(forceColor: .all)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle("Color Schemes")
    }
}

// MARK: - Media Handling Test
struct MediaHandlingView: View {
    let mediaHTML = """
        <h2>Media Click Test</h2>
        <p>Click on the image or video below to test media handling:</p>
        <img src="https://via.placeholder.com/300x200/0066CC/FFFFFF?text=Click+Me" alt="Test Image" />
        <p>Image caption: This should be clickable</p>
        <video width="300" height="200" controls>
            <source src="https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4" type="video/mp4">
            Your browser does not support the video tag.
        </video>
        <p>Video caption: This should also be clickable</p>
    """
    
    @State private var lastClickedMedia: String = "No media clicked yet"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Last Clicked Media:")
                    .font(.headline)
                
                Text(lastClickedMedia)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                RichText(html: mediaHTML)
                    .imageRadius(12)
                    .onMediaClick { media in
                        switch media {
                        case .image(let src):
                            lastClickedMedia = "Image clicked: \(src)"
                        case .video(let src):
                            lastClickedMedia = "Video clicked: \(src)"
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Media Handling")
    }
}

// MARK: - Error Handling Test
struct ErrorHandlingView: View {
    let invalidHTML = """
        <h2>Error Handling Test</h2>
        <p>This tests error handling capabilities.</p>
        <img src="https://invalid-url-that-should-fail.com/image.jpg" alt="This should fail">
        <p>The image above should fail to load.</p>
    """
    
    @State private var lastError: String = "No errors yet"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Last Error:")
                    .font(.headline)
                
                Text(lastError)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                
                RichText(html: invalidHTML)
                    .onError { error in
                        lastError = "Error: \(error.localizedDescription)"
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Test CSS Generation Error") {
                    // This should trigger CSS generation
                    let richText = RichText(html: invalidHTML)
                    let _ = richText.generateCSS()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Error Handling")
    }
}

// MARK: - Loading States Test
struct LoadingStatesView: View {
    let slowHTML = """
        <h2>Loading States Test</h2>
        <p>This tests different loading states and transitions.</p>
        <img src="https://via.placeholder.com/600x400?text=Large+Image" alt="Large image for testing">
        <p>The content above should show loading states.</p>
    """
    
    @State private var showContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button("Toggle Content") {
                    showContent.toggle()
                }
                .buttonStyle(.bordered)
                
                if showContent {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("With Loading Placeholder")
                            .font(.headline)
                        
                        RichText(html: slowHTML)
                            .loadingPlaceholder("Loading content...")
                            .loadingTransition(.fade)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Custom Placeholder")
                            .font(.headline)
                        
                        RichText(html: slowHTML)
                            .placeholder {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("Custom loading view...")
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: 100)
                            }
                            .loadingTransition(.scale)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Slide Transition")
                            .font(.headline)
                        
                        RichText(html: slowHTML)
                            .loadingText("Please wait...")
                            .loadingTransition(.slide)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Loading States")
    }
}

// MARK: - Custom CSS Test
struct CustomCSSView: View {
    let testHTML = """
        <h1 class="custom-title">Custom Styled Title</h1>
        <p class="highlight">This paragraph has custom styling.</p>
        <div class="box">
            <p>This is inside a custom box.</p>
        </div>
        <blockquote>This is a styled blockquote.</blockquote>
    """
    
    let customCSS = """
        .custom-title {
            color: #FF6B6B;
            text-align: center;
            border-bottom: 2px solid #4ECDC4;
            padding-bottom: 10px;
        }
        .highlight {
            background-color: #FFF3CD;
            padding: 10px;
            border-left: 4px solid #FFC107;
            border-radius: 4px;
        }
        .box {
            background-color: #E7F3FF;
            border: 2px dashed #0066CC;
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
        }
        blockquote {
            font-style: italic;
            border-left: 4px solid #6C757D;
            padding-left: 20px;
            margin: 20px 0;
            background-color: #F8F9FA;
            padding: 15px 20px;
        }
    """
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Without Custom CSS")
                    .font(.headline)
                
                RichText(html: testHTML)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                Text("With Custom CSS")
                    .font(.headline)
                
                RichText(html: testHTML)
                    .customCSS(customCSS)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                Text("CSS Generation Test")
                    .font(.headline)
                
                Button("Generate CSS") {
                    let richText = RichText(html: testHTML)
                        .lineHeight(180)
                        .imageRadius(10)
                        .customCSS(customCSS)
                    
                    let generatedCSS = richText.generateCSS(colorScheme: .light)
                    print("Generated CSS:\n\(generatedCSS)")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Custom CSS")
    }
}

// MARK: - Link Handling Test
struct LinkHandlingView: View {
    let linkHTML = """
        <h2>Link Handling Test</h2>
        <p>Different types of links:</p>
        <ul>
            <li><a href="https://www.apple.com">HTTPS Link (apple.com)</a></li>
            <li><a href="http://www.example.com">HTTP Link (example.com)</a></li>
            <li><a href="mailto:test@example.com">Email Link</a></li>
            <li><a href="tel:+1234567890">Phone Link</a></li>
            <li><a href="custom://app">Custom URL Scheme</a></li>
        </ul>
    """
    
    @State private var lastLinkClicked: String = "No links clicked yet"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Last Link Clicked:")
                    .font(.headline)
                
                Text(lastLinkClicked)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Safari Link Opening")
                        .font(.headline)
                    
                    RichText(html: linkHTML)
                        .linkOpenType(.Safari)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                #if os(iOS)
                VStack(alignment: .leading, spacing: 15) {
                    Text("SFSafariView Link Opening")
                        .font(.headline)
                    
                    RichText(html: linkHTML)
                        .linkOpenType(.SFSafariView())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                #endif
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Custom Link Handling")
                        .font(.headline)
                    
                    RichText(html: linkHTML)
                        .linkOpenType(.custom { url in
                            lastLinkClicked = "Custom handler: \(url.absoluteString)"
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("No Link Handling")
                        .font(.headline)
                    
                    RichText(html: linkHTML)
                        .linkOpenType(.none)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle("Link Handling")
    }
}

// MARK: - Performance Test
struct PerformanceTestView: View {
    let largeHTML: String = {
        var html = "<h1>Performance Test</h1>"
        for i in 1...100 {
            html += """
                <h2>Section \(i)</h2>
                <p>This is paragraph \(i) with some <strong>bold text</strong> and <em>italic text</em>.</p>
                <ul>
                    <li>Item 1 in section \(i)</li>
                    <li>Item 2 in section \(i)</li>
                    <li>Item 3 in section \(i)</li>
                </ul>
            """
            if i % 10 == 0 {
                html += "<img src=\"https://via.placeholder.com/300x200?text=Image+\(i)\" alt=\"Image \(i)\">"
            }
        }
        return html
    }()
    
    @State private var renderTime: String = "Not measured"
    @State private var showContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Render Time: \(renderTime)")
                        .font(.headline)
                    
                    Button("Start Performance Test") {
                        let startTime = CFAbsoluteTimeGetCurrent()
                        showContent = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                            renderTime = String(format: "%.3f seconds", timeElapsed)
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Clear Content") {
                        showContent = false
                        renderTime = "Not measured"
                    }
                    .buttonStyle(.bordered)
                }
                
                if showContent {
                    Text("Large Content (100 sections)")
                        .font(.headline)
                    
                    RichText(html: largeHTML)
                        .lineHeight(160)
                        .imageRadius(8)
                        .loadingTransition(.none) // Disable for performance
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle("Performance")
    }
}

// MARK: - Backward Compatibility Test
struct BackwardCompatibilityView: View {
    let testHTML = """
        <h2>Backward Compatibility Test</h2>
        <p>This tests deprecated methods that should still work.</p>
        <p>All deprecated methods should function correctly.</p>
    """
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Testing deprecated methods (should show warnings but work)")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Deprecated backgroundColor String Method")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    RichText(html: testHTML)
                        .backgroundColor("transparent") // Deprecated
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Deprecated backgroundColor with Hex")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    RichText(html: testHTML)
                        .backgroundColor("#E8F5E8") // Deprecated
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Configuration with All Parameters")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    let config = Configuration(
                        customCSS: "p { color: #333; }",
                        supportsDynamicType: false,
                        fontType: .system,
                        fontColor: ColorSet(light: "000000", dark: "FFFFFF"),
                        lineHeight: 170,
                        colorScheme: .auto,
                        forceColorSchemeBackground: false,
                        backgroundColor: .transparent,
                        imageRadius: 5,
                        linkOpenType: .Safari,
                        linkColor: ColorSet(light: "007AFF", dark: "0A84FF", isImportant: true),
                        baseURL: Bundle.main.bundleURL,
                        mediaClickHandler: nil,
                        errorHandler: nil,
                        isColorsImportant: .onlyLinks,
                        transition: .easeInOut(duration: 0.3)
                    )
                    
                    RichText(html: testHTML, configuration: config)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationTitle("Backward Compatibility")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
