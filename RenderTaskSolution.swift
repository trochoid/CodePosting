import SwiftUI


struct ContentView: View {
    
    @StateObject var renderInfo = RenderInfo()
    @State var dummy = 1.0 //some value for the Slider, just to test View interactivity
    
    var body: some View {
        VStack(spacing: 30) {
            
            Button("render") { 
                RenderEngine.render(info: renderInfo) 
            }
            .disabled(renderInfo.isRunning)
            
            Button("cancel") { 
                renderInfo.shouldCancel = true 
            }
            .disabled(!renderInfo.isRunning)
            
            Text("result: \(renderInfo.renderResult)")
            Text("is running: \(String(renderInfo.isRunning))")
            
            Slider(value: $dummy, in: 0...2)
        }
    }
    
}


@MainActor
class RenderInfo : ObservableObject { //acts as a communication bridge between View and the rendering Task
    @Published var renderResult = "nil"
    @Published var isRunning = false
    var shouldCancel = false
    
    func setResult(result: String) { renderResult = result } //setters allow Task to set values
    func setIsRunning(state: Bool) { isRunning = state }
    func setShouldCancel(state: Bool) { shouldCancel = state }
}


class RenderEngine {
    static func render(info: RenderInfo) { //runs like a 'thread'. Use await to access info
        Task {
            await info.setIsRunning(state: true)
            for i in 0...9 {
                drawChaos()
                await info.setResult(result: "pass \(i)")
                if await info.shouldCancel {
                    await info.setShouldCancel(state: false)
                    break
                }
            }
            await info.setResult(result: "finished " + (await info.renderResult))
            await info.setIsRunning(state: false)
        }
    }
}


func drawChaos() { //eat up some number crunching time
    var s = 1.0
    for _ in 0...1900000 {
        s += 1 / s
    }
}
