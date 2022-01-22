import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MasterView()
        }
    }
}



struct MasterView: View {
    
    @State var showControls = true //actually toggles width of DrawView
    @State var proxy: GeometryProxy? //store the overall size
    let controlsWidth: CGFloat = 300.0 //hardcode the controls view width
    //instead of hardcoding, the ControlsView could be in a GeometryReader too
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            GeometryReader { geo in     //Z level 0
                HStack(spacing: 0) {
                    DrawView()
                        .frame(width: showControls ?       //expand or retract the width
                               (proxy?.size.width ?? 5) - controlsWidth :
                                proxy?.size.width ?? 5)
                    ControlsView()           //this gets pushed off when DrawView is expanded
                        .frame(minWidth: controlsWidth, maxWidth: controlsWidth)
                }
                .onAppear{ proxy = geo } //save the proxy
            }
            
            Button("toggle") {          //Z level 1
                withAnimation { showControls.toggle() } //toggle DrawView size
            }
            .padding(10)
            .background(.black.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(5)
            
        }
    }
    
}



struct DrawView: View {
    var body: some View {
        VStack {
            Text("DrawingView")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
    }
}



struct ControlsView: View {
    @State var testBool = false
    @State var testFloat = 0.0
    var body: some View {
        VStack {
            Text("these are the controls")
            Toggle("earth is hot", isOn: $testBool)
                .padding(.horizontal, 40)
            Slider(value: $testFloat)
                .padding(.horizontal, 40)
            List(0..<20) { i in
                Text("\(i)")
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.purple)
    }
}
