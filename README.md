# RichText
![github](https://user-images.githubusercontent.com/73557895/128497417-52d47524-05bf-48af-ae0a-e0cdffdbedf5.png)


<p align="center">
    <a href="https://swift.org/">
        <img src="https://img.shields.io/badge/Swift-5.1+-F05138?labelColor=303840" alt="Swift: 5.1+">
    </a>
    <a href="https://www.apple.com/ios/">
        <img src="https://img.shields.io/badge/iOS-13.0+-007AFF?labelColor=303840" alt="iOS: 13.0+">
    </a>
    <a href="https://www.apple.com/macos/">
        <img src="https://img.shields.io/badge/macOS-10.15+-007AFF?labelColor=303840" alt="macOS-10.15+">
    </a>
</p>


| <img width="1440" alt="스크린샷 2021-08-28 오전 12 14 09" src="https://user-images.githubusercontent.com/73557895/131149958-bbc28435-02e2-4a02-8ad5-43627cd333e0.png"> 	| <img width="1440" alt="스크린샷 2021-08-28 오전 12 13 59" src="https://user-images.githubusercontent.com/73557895/131149926-211e2111-6d6e-4aac-94b8-44c7230b6244.png"> 	|
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------:	|:------------------------------------------------------------------------------------------------------------------------------:	|
| LightMode                                                                                                                                                                 	| DarkMode                                                                                                                        	|                   

## Code
```swift
import SwiftUI
import RichText

struct RichText_Test: View {
    @State var  html = ""
    
    var body: some View {
       ScrollView{
            RichText(html: html)
                .lineHeight(170)
                .colorScheme(.auto)
                .imageRadius(12)
                .fontType(.system)
                .foregroundColor(light: Color.primary, dark: Color.primary)
                .linkColor(light: Color.blue, dark: Color.blue)
                .colorPreference(forceColor: .onlyLinks)
                .linkOpenType(.SFSafariView())
                .customCSS("")
                .placeholder {
                    Text("loading")
                }
                .transition(.easeOut)
        }
    }
}

struct RichText_Test_Previews: PreviewProvider {
    static var previews: some View {
        RichText_Test()
    }
}

```
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding RichText as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/NuPlay/RichText.git", .upToNextMajor(from: "2.0.0"))
]
```

## More
```swift
import SwiftUI
import RichText

struct RichText_Test: View {
    @State var  html = ""
    
    let config: Configuration = Configuration(customCSS: String, fontType: FontType, fontColor: ColorSet, lineHeight: CGFloat, colorScheme: ColorScheme, imageRadius: CGFloat, linkOpenType: LinkOpenType, linkColor: ColorSet, isColorsImportant: ColorPreference)
    
    var body: some View {
       ScrollView{
        RichText(html: text, configuration: config, placeholder: AnyView?)
                .lineHeight(170)
                .colorScheme(.auto)
                .imageRadius(12)
                .fontType(.system)
                .foregroundColor(light: Color.primary, dark: Color.primary)
                .linkColor(light: Color.blue, dark: Color.blue)
                .colorPreference(forceColor: .onlyLinks)
                .linkOpenType(.SFSafariView())
                .customCSS("")
                .placeholder {
                    Text("loading")
                }
                .transition(.easeOut)
        }
    }
}

struct RichText_Test_Previews: PreviewProvider {
    static var previews: some View {
        RichText_Test()
    }
}
```

## Custom Font
```swift
import SwiftUI
import RichText

struct RichText_Test: View {
    @State private var  html = ""
    
    var body: some View {
       ScrollView{
        RichText(html: html)
        .fontType(.customName("Noto Sans"))
        .customCSS("""
                 @font-face {
                        font-family: 'Noto Sans';
                        src: url("NotoSans-Regular.ttf") format('truetype');
                            }
                """)
        }
    }
}

struct RichText_Test_Previews: PreviewProvider {
    static var previews: some View {
        RichText_Test()
    }
}
```

## Sample Text
<details>
<summary>Click</summary>
<div markdown="1">

```swift
import SwiftUI
import RichText

struct RichText_Test: View {
    @State var  html = """
        <h1>Non quam nostram quidem, inquit Pomponius iocans;</h1>
        
        <img src = "https://user-images.githubusercontent.com/73557895/126889699-a735f993-2d95-4897-ae40-bcb932dc23cd.png">
        

        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quis istum dolorem timet? Sit sane ista voluptas. Quis est tam dissimile homini. Duo Reges: constructio interrete. <i>Quam illa ardentis amores excitaret sui! Cur tandem?</i> </p>

        <dl>
            <dt><dfn>Avaritiamne minuis?</dfn></dt>
            <dd>Placet igitur tibi, Cato, cum res sumpseris non concessas, ex illis efficere, quod velis?</dd>
            <dt><dfn>Immo videri fortasse.</dfn></dt>
            <dd>Quae qui non vident, nihil umquam magnum ac cognitione dignum amaverunt.</dd>
            <dt><dfn>Si longus, levis.</dfn></dt>
            <dd>Ita ne hoc quidem modo paria peccata sunt.</dd>
        </dl>


        <ol>
            <li>Possumusne ergo in vita summum bonum dicere, cum id ne in cena quidem posse videamur?</li>
            <li>Placet igitur tibi, Cato, cum res sumpseris non concessas, ex illis efficere, quod velis?</li>
            <li>Unum nescio, quo modo possit, si luxuriosus sit, finitas cupiditates habere.</li>
        </ol>


        <blockquote cite="http://loripsum.net">
            Aristoteles, Xenocrates, tota illa familia non dabit, quippe qui valitudinem, vires, divitias, gloriam, multa alia bona esse dicant, laudabilia non dicant.
        </blockquote>


        <p>Scrupulum, inquam, abeunti; Conferam tecum, quam cuique verso rem subicias; Audeo dicere, inquit. Maximus dolor, inquit, brevis est. Nos commodius agimus. </p>

        <ul>
            <li>Cur igitur, inquam, res tam dissimiles eodem nomine appellas?</li>
            <li>Omnia peccata paria dicitis.</li>
        </ul>


        <h2>Laboro autem non sine causa;</h2>

        <p>Itaque contra est, ac dicitis; <code>Illa argumenta propria videamus, cur omnia sint paria peccata.</code> </p>

        <pre>Nunc dicam de voluptate, nihil scilicet novi, ea tamen, quae
        te ipsum probaturum esse confidam.

        Sin est etiam corpus, ista explanatio naturae nempe hoc
        effecerit, ut ea, quae ante explanationem tenebamus,
        relinquamus.
        </pre>



        """
    
    var body: some View {
        ScrollView{
           RichText(html: html)
                .lineHeight(170)
                .colorScheme(.auto)
                .imageRadius(12)
                .fontType(.system)
                .foregroundColor(light: Color.primary, dark: Color.primary)
                .linkColor(light: Color.blue, dark: Color.blue)
                .colorPreference(forceColor: .onlyLinks)
                .customCSS("")
                .linkOpenType(.SFSafariView())
                .placeholder {
                    Text("loading")
                }
                .transition(.easeOut)
        }
    }
}

struct RichText_Test_Previews: PreviewProvider {
    static var previews: some View {
        RichText_Test()
    }
}
    
```
  
 </div>
</details>


### How To Use

Variable explanation

 - html : which you want to show (String type)   

### Modifier
Modifier | Default
--- | ---
`.foregroundColor(light: Color, dark: Color)` | `(light: "000000", dark: "F2F2F2")`
`.imageRadius(_ imageRadius: CGFloat)` | `0`
`.customCSS(_ customCSS: String)` | `""`
`.lineHeight(_ lineHeight: CGFloat)` | `170`
`.colorScheme(_ colorScheme: ColorScheme)` | `.auto`
`.fontType(_ fontType: FontType)` | `.system`
`.linkColor(_ linkColor: ColorSet)` | `ColorSet(light: "#007AFF", dark: "#0A84FF", isImportant: true)`
`.linkOpenType(_ linkOpenType: LinkOpenType)` | `.Safari`
`.placeholder<T>(@ViewBuilder content: () -> T)` | `nil`
`.colorPreference(forceColor: ColorPreference)` | `.onlyLinks`
`.transition(_ transition: Animation?)` | `.none`


 - foregroundColor (default: (light: "000000", dark: "F2F2F2")) : Color of Text
 - imageRadius (default: 0)  : Radius of image corner
 - customCSS(default: ""): You can add CSS if you want
 - lineHeight (default: 170)  : Height of each line
 - colorScheme(default: .auto) : light or dark mode (it changes text color)
 - fontType(default: .system): Font type in RichText view
 - linkColor (default: ColorSet(light: "#007AFF", dark: "#0A84FF")) : linkColor (Color or UIColor)
 - linkOpenType (default: .Safari) : When the user clicks the link contained in html, Way to Show Webview
 - placeholder (default: nil) : What to display until Richtext views are completely drawn (View type) 
 - transition(default: .none) : Transition between PlaceHolder and Content
 - colorPreference(default: .onlyLinks) : css '!important', It ignores the color in variable 'html'

### Known Issues
If you are trying to display very large content, it may not be displayed.

### Planned (Future work): 
A variety of options. 
If you need any options, leave them in the issues or discussion.
