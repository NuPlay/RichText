# RichText


| <img width="1436" alt="스크린샷 2021-07-25 오후 3 22 03" src="https://user-images.githubusercontent.com/73557895/126889821-a346bb72-c65a-47ae-9492-fc4dcfe79f02.png"> 	| <img width="1431" alt="스크린샷 2021-07-25 오후 3 22 11" src="https://user-images.githubusercontent.com/73557895/126889824-9e5c6b48-6d75-42bb-b3f2-69c469dd5e86.png"> 	|
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------	|--------------------------------------------------------------------------------------------------------------------------------	|
| LightMode                                                                                                                                                                 	| DarkMode                                                                                                                        	|                                                                                               	|


## Code
```swift
import SwiftUI
import RichText

struct RichText_Test: View {
    @State var  html = ""
    
    var body: some View {
       ScrollView{
            RichText(html: html, lineHeight: 170, imageRadius: 0, fontType: .default, colorScheme: .automatic, colorImportant: false)
                .placeholder {
                    Text("loading")
                }
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
<summary>Sample</summary>
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
            RichText(html: html, lineHeight: 170, imageRadius: 16, fontType: .default, colorScheme: .automatic, colorImportant: false)
                .placeholder {
                    Text("loading")
                }
                    .disabled(true)// if you don't want interaction
                    .padding(.horizontal, 16)
        }
        //        .background(
        //            Color.black.ignoresSafeArea()
        //        )
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

### Optional
 - lineHeight (optional, default: 170) : Height of each line  
 - imageRadius (optional, default: 0)  : Radius of image corner 
 - fontType(optional, default : default): Font type in html view but not yet working properly
 - colorScheme(optional, default : automatic) : light or dark mode (it changes text color) 
 - colorImportant (optional, default: false) : css '!important', It ignores the color in variable 'html' when colorImportant is true.
 - placeholder(optional,default: EmptyView()) : What to display until Richtext views are completely drawn (View type)

### Planned (Future work): 
moreOption



