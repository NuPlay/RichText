import SwiftUI

public struct RichText: View {
    @State private var dynamicHeight : CGFloat = .zero
    
    var html : String
    var lineHeight : CGFloat = 170
    var imageRadius : CGFloat = 0
    
    var colorScheme : colorScheme
    public init(html: String,lineHeight : CGFloat = 170, imageRadius : CGFloat = 0, colorScheme : colorScheme) {
        self.html = html
        self.lineHeight = lineHeight
        self.imageRadius = imageRadius
        self.colorScheme = colorScheme
    }
    
    
    
    public var body: some View {
        Webview(dynamicHeight: $dynamicHeight, html: html, lineHeight: lineHeight, imageRadius: imageRadius,colorScheme: colorScheme)
            .frame(height: dynamicHeight)
    }
}

struct RichText_Previews: PreviewProvider {
    static var previews: some View {
        RichText(html: "", colorScheme: .light)
    }
}

public enum colorScheme: String {
    case light = "light"
    case dark = "dark"
}
