import SwiftUI

public struct RichText: View {
    @State private var dynamicHeight : CGFloat = .zero
    
    let html : String
    
    var lineHeight : CGFloat = 170
    var imageRadius : CGFloat = 0
    var fontType : fontType = .default
    
    var colorScheme : colorScheme = .automatic
    var colorImportant : Bool = false
    
    var placeholder: AnyView?
    
    var linkOpenType : linkOpenType = .SFSafariView
    
    public init(html: String) {
        self.html = html
    }
    
    public var body: some View {
        ZStack(alignment: .top){
            Webview(dynamicHeight: $dynamicHeight, html: html, lineHeight: lineHeight, imageRadius: imageRadius,colorScheme: colorScheme,colorImportant: colorImportant,linkOpenType: linkOpenType)
                .frame(height: dynamicHeight)
            
            if self.dynamicHeight == 0 {
                placeholder
            }
        }
    }
}


struct RichText_Previews: PreviewProvider {
    static var previews: some View {
        RichText(html: "")
    }
}


