//
//  RichText.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI

/// A SwiftUI view that renders HTML content with customizable styling and behavior.
/// 
/// RichText provides a powerful way to display HTML content within SwiftUI applications,
/// offering extensive customization options for styling, theming, and interaction handling.
///
/// ## Example Usage
/// ```swift
/// RichText(html: "<h1>Hello World</h1><p>This is a paragraph.</p>")
///     .colorScheme(.auto)
///     .fontType(.system)
///     .lineHeight(150)
///     .imageRadius(8)
///     .linkColor(light: .blue, dark: .cyan)
///     .placeholder {
///         ProgressView("Loading...")
///     }
/// ```
///
/// ## Key Features
/// - Cross-platform support (iOS 13.0+, macOS 10.15+)
/// - Automatic height adjustment based on content
/// - Customizable color schemes (light, dark, auto)
/// - Support for custom fonts and CSS
/// - Configurable link handling
/// - Dynamic Type support
/// - Placeholder view support during loading
/// - Image styling with border radius
/// - Comprehensive theming options
public struct RichText: View {
    @State private var dynamicHeight: CGFloat = .zero
    
    /// The HTML content to be rendered
    let html: String
    
    /// Configuration object containing all styling and behavior options
    var configuration: Configuration
    
    /// Optional placeholder view displayed while content is loading
    var placeholder: AnyView?
    
    /// Initializes a RichText view with HTML content and optional configuration
    /// - Parameters:
    ///   - html: The HTML string to render
    ///   - configuration: Configuration object with styling options (defaults to basic configuration)
    ///   - placeholder: Optional view to show while content is loading
    public init(html: String, configuration: Configuration = .init(), placeholder: AnyView? = nil) {
        self.html = html
        self.configuration = configuration
        self.placeholder = placeholder
    }

    /// The view body that renders the HTML content
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                // Main WebView that renders the HTML content
                WebView(
                    width: proxy.size.width, 
                    dynamicHeight: $dynamicHeight, 
                    html: html, 
                    configuration: configuration
                )

                // Show placeholder while content is loading (height is 0)
                if self.dynamicHeight == 0 {
                    placeholder
                }
            }
        }
        .frame(height: dynamicHeight) // Dynamic height based on content
    }
}

struct RichText_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            RichText(
                html: """
            <h1 style="background-color: white;">Lorem Ipsum Test</h1>
            <img 
                src="https://miro.medium.com/v2/resize:fit:1400/1*JLYlSLSK8-AZo8gt9UdYqA.jpeg" 
                alt="Denali mountain landscape" 
              />
            <p style="background-color: white;">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae suscipit neque. Nullam
              imperdiet justo at felis dictum, nec laoreet risus fermentum. Mauris suscipit libero vel
              erat porttitor, ac porttitor nisi pulvinar.
            </p>
            <p style="background-color: white;">
              Donec in mi vel sem pharetra pulvinar. Aliquam erat volutpat. Morbi posuere justo at
              efficitur pharetra. Aenean nec blandit nibh. Proin vel urna eget odio posuere blandit.
            </p>
            <h2 style="background-color: white;">Subheading</h2>
            <p style="background-color: white;">
              Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;
              Cras malesuada velit sit amet metus dapibus, at tristique est porttitor. Nunc lacinia
              lectus sed quam lacinia, vel porta nulla fermentum. Curabitur at urna non nisl
              scelerisque consequat.
            </p>
            <p style="background-color: white;">
              Sed vitae turpis vitae purus accumsan faucibus. Suspendisse vel nibh tellus. Etiam et
              tempor ante. Suspendisse sit amet orci id nisi euismod blandit. In hac habitasse platea
              dictumst.
            </p>
            <p style="background-color: white;">
              Pellentesque dignissim lacinia nisl at pretium. Etiam a rutrum nisi. Integer tincidunt
              ipsum ut sapien gravida, a bibendum massa fermentum. Vivamus lacinia libero in nunc
              eleifend suscipit. Maecenas ut tristique magna.
            </p>
            """
            )
            .forceColorSchemeBackground(true)
            .padding()
        }
    }
}
