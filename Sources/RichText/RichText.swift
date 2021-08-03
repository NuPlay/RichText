import SwiftUI

public struct RichText: View {
    @State private var dynamicHeight : CGFloat = .zero
    
    var html : String
    
    var lineHeight : CGFloat = 170
    var imageRadius : CGFloat = 0
    var fontType : fontType = .default
    
    var colorScheme : colorScheme = .automatic
    var colorImportant : Bool = false
    
    var placeholder: AnyView?
    
    public init(html: String,lineHeight : CGFloat = 170, imageRadius : CGFloat = 0, fontType : fontType = .default,colorScheme : colorScheme = .automatic, colorImportant : Bool = false) {
        self.html = html
        self.lineHeight = lineHeight
        self.imageRadius = imageRadius
        self.fontType = fontType
        self.colorScheme = colorScheme
        self.colorImportant = colorImportant
    }
    
    public var body: some View {
        ZStack(alignment: .top){
            Webview(dynamicHeight: $dynamicHeight, html: html, lineHeight: lineHeight, imageRadius: imageRadius,colorScheme: colorScheme,colorImportant: colorImportant)
                .frame(height: dynamicHeight)
            
            if self.dynamicHeight == 0 {
                placeholder
            }
        }
    }
}


struct RichText_Previews: PreviewProvider {
    static var previews: some View {
        RichText(html: "", colorScheme: .light)
    }
}
extension RichText {
    public func placeholder<T>(@ViewBuilder content: () -> T) -> RichText where T : View {
        var result = self
        result.placeholder = AnyView(content())

        return result
    }
}

