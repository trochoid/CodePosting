import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        HStack {
            RegularView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(ClockView(), alignment: .topLeading)
            RepresentedView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(white: 0.1))
                .overlay(ClockView(), alignment: .topLeading)
        }
    }
}


struct RegularView: View {
    var body: some View {
        Text("regular side")
    }
}


struct RepresentedView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView { 
        return UIView() 
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct ClockView: View {
    @State var isOn = false
    var body: some View {
        Image(systemName: "clock")
            .foregroundColor(isOn ? .green : .gray)
            .onTapGesture { isOn.toggle() }
    }
}






