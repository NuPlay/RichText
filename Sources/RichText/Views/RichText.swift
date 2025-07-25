//
//  RichText.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI

public struct RichText: View {
    @State private var dynamicHeight: CGFloat = .zero
    
    let html: String
    var configuration: Configuration
    var placeholder: AnyView?
    
    public init(html: String, configuration: Configuration = .init(), placeholder: AnyView? = nil) {
        self.html = html
        self.configuration = configuration
        self.placeholder = placeholder
    }

    public var body: some View {
        GeometryReader{ proxy in
            ZStack(alignment: .top) {
                WebView(width: proxy.size.width, dynamicHeight: $dynamicHeight, html: html, configuration: configuration)

                if self.dynamicHeight == 0 {
                    placeholder
                }
            }
        }
        .frame(height: dynamicHeight)
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
