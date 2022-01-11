import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}



//stand-in for my class with CGBlendMode property
class Foo : ObservableObject {
    @Published var blend = CGBlendMode.normal
}

//a global place to store an instance
class Storage { static var foo = Foo() }



//observes the foo object with a Menu to set its CGBlendMode property
struct ContentView: View {
    
    @ObservedObject var foo = Storage.foo
    
    var body: some View {
        HStack {
            Text("Mode:")
            
            Menu {
                BlendMenuRowView($foo.blend, .normal) //pass a Binding and each enum case
                BlendMenuRowView($foo.blend, .clear)
                BlendMenuRowView($foo.blend, .color)
                BlendMenuRowView($foo.blend, .colorBurn)
                BlendMenuRowView($foo.blend, .colorDodge)
                BlendMenuRowView($foo.blend, .copy)
                BlendMenuRowView($foo.blend, .darken)
                BlendMenuRowView($foo.blend, .destinationAtop)
            } label: {
                Text(textOfBlendEnum(foo.blend)) //show current choice
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .frame(maxWidth: 200)
        .padding(10)
        .background(.gray.opacity(0.2))
        .cornerRadius(10)
    }
}



//wraps a Button for a Menu row
//initialized with a Binding to the objects property and the enum case this row represents
struct BlendMenuRowView: View {
    
    @Binding var currentChoice: CGBlendMode
    let thisRowsEnum: CGBlendMode
    
    init(_ current: Binding<CGBlendMode>, _ rowValue: CGBlendMode) {
        _currentChoice = current
        thisRowsEnum = rowValue
    }
    
    var body: some View {
        Button(
            action: { currentChoice = thisRowsEnum }, //assign new enum case
            label: { Label(
                    textOfBlendEnum(thisRowsEnum), //show this enum name, and maybe checkmark
                    systemImage: currentChoice == thisRowsEnum ? "checkmark" : ""
            ) }
        )
    }
    
}


//map each enum case to a display string
func textOfBlendEnum(_ e: CGBlendMode) -> String {
    switch e {
    case .normal: return "Normal"
    case .clear: return "Clear"
    case .color: return "Color"
    case .colorBurn: return "Color Burn"
    case .colorDodge: return "Color Dodge"
    case .copy: return "Copy"
    case .darken: return "Darken"
    case .destinationAtop: return "Destination Atop"
    default: return "default"
    }
}

