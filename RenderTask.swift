import SwiftUI

//this demo uses Strings in place of CGContext/CGImage

struct ContentView: View {
    @StateObject var engine = ChaosEngine()
    var body: some View {
        VStack(spacing: 30) {
            Button("render") { engine.render() }.disabled(engine.isRunning)
            Button("cancel") { engine.cancel() }.disabled(!engine.isRunning)
            Text("render result: \(engine.renderResult)")
            Text("is running: \(String(engine.isRunning))")
        }
    }
}


//wraps a CGContext for easy creation etc
class EZContext : ObservableObject {
    @Published var context = "nil context"
}


class ChaosEngine : ObservableObject {
    @Published var renderResult = "render result"
    @Published var isRunning = false
    var renderTask: Task<Void, Never>?
    
    func render() {
        if isRunning { return }
        isRunning = true //if this is inside Task it has same problem as when setting false
        renderTask = Task {
            let g = EZContext() //create a 'CGContext' to draw into
            drawChaos(g: g) //draw it
            renderResult = g.context //store a 'CGImage', published
            isRunning = false //mark that its done, published
        }
    }
    
    func cancel() {
        if let t = renderTask {
            t.cancel()
        }
    }
    
    func drawChaos(g: EZContext) {
        var s = 0
        for _ in 0...9 { //work in batches
            for _ in 0...1000000 { //iterate and plot points
                s += 1
            }
            if let t = renderTask { //test for cancellation
                if t.isCancelled {
                    break
                }
            }
        }
        g.context = "drew \(s) (\(Int.random(in: 0...99)))"
    }
    
}







