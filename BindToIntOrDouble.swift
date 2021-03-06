import SwiftUI



struct ContentView: View {
    var body: some View { FooView() }
}


//model object containing Int and Double values that i want to manipulate in a ScrubberView
class Foo : ObservableObject {
    @Published var valueInt = 0
    @Published var valueDouble = 0.0
}



struct FooView: View {
    
    @StateObject var foo = Foo() //instance of model
    
    @State var dummyInt = 0 //dummy vars for the unused binding
    @State var dummyDouble = 0.0
    
    var body: some View {
        VStack {
            //create ScrubberViews passing a binding to the real value and 
            //a binding to a unused dummy value and a boolean of which is real
            ScrubberView($foo.valueInt, $dummyDouble, asInt: true)
            ScrubberView($dummyInt, $foo.valueDouble, asInt: false)
        }
        Text("values: int \(foo.valueInt), double \(String(format: "%.2f", foo.valueDouble))")
            .padding().border(.yellow)
    }
}



struct ScrubberView: View {
    
    @Binding var intValue: Int //have bindings to both types of values
    @Binding var doubleValue: Double
    let isInt: Bool //track which is the 'real' value to show and manipulate
    
    init(_ theInt: Binding<Int>, _ theDouble: Binding<Double>, asInt: Bool) {
        self._intValue = theInt
        self._doubleValue = theDouble
        isInt = asInt
    }
    
    var body: some View {
        VStack {
            Text("ScrubberView")
            Text("linked to \(isInt ? "Int" : "Double")")
            Text("value \(isInt ? String(intValue) : String(format: "%.2f", doubleValue))")
            Button("incr") { 
                if isInt { 
                    intValue += 1
                } else { 
                    doubleValue += 0.1
                }
            }.padding(9).background(.black).cornerRadius(9)
        }.padding().border(.green)
    }
}


