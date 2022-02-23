import SwiftUI




//for communicating between the Task and UI
//the UI can use this like a regular ObservableObject
//but the Task needs setters to set values
@MainActor
class RenderState : ObservableObject {
    @Published var renderedImage: CGImage?
    @Published var isRunning = false
    var shouldCancel = false
    @Published var renderTime = 0.0
    @Published var renderProgress = 0.5
    
    func setRenderedImage(_ img: CGImage?) { renderedImage = img }
    func setIsRunning(_ state: Bool) { isRunning = state }
    func setShouldCancel(_ state: Bool) { shouldCancel = state }
    func setRenderTime(_ time: Double) { renderTime = time }
    func setRenderProgress(_ progress: Double) { renderProgress = progress }
}






struct ContentView: View {
    
    @StateObject var renderState = RenderState() //create and store a RenderState MainActor
    
    var body: some View {
        HStack(spacing: 0) {
            
            Button(renderState.isRunning ? "cancel" : "render") {
                renderState.isRunning ? doCancel() : doRender() //call doRender or doCancel
            }
            
        }
    } 
    
    func doRender() {
        if renderState.isRunning { return }
        guard let size = currentCanvasSize?.size else { return }
        guard let eq = eqHolder.eq else { return }
        
        //call the rendering function that has the Task, passing in the RenderState instance
        ChaosEngine.renderEq(eq: eq, state: renderState, canvasSize: size, scale: scale, pixGrowth: pixelGrowth, res: renderRes, initialX: 0.1, initialY: 0.1)
    }
    
    func doCancel() {
        if renderState.isRunning { renderState.shouldCancel = true }
    }
    
}







class ChaosEngine {
    
    static func renderEq(eq: ChaosEquation, state: RenderState, canvasSize: CGSize, scale: Double, pixGrowth: Double, res: Int, initialX: Double, initialY: Double) {
        
        let size = canvasSize.intClamp().doubleSize()
        
        guard let g = makeContextRGB(width: Int(size.width), height: Int(size.height)) 
        else { return }
        
        prepContext(g: g, pixGrowth: pixGrowth / 2)
        
        let drawRes = Int(res / 100)
        let point = Point(0.1, 0.1)
        eq.copyParams()
        
        Task(priority: .userInitiated) { //start the Task
            await state.setIsRunning(true) //to set values on the renderState use await and setter func
            CodeTime.markStart()
            
        outer: 
            for _ in 0...9 { 
                for _ in 0...9 {
                    drawPointsEq(
                        eq: eq,
                        g: g, res: drawRes, initialPoint: point, 
                        centerX: size.width/2, centerY: size.height/2, scale: scale)
                    if await state.shouldCancel { //getting a value from renderState only need await
                        await state.setShouldCancel(false)
                        break outer
                    }
                }
                if let img = g.makeImage() { await state.setRenderedImage(img) }
            }
            
            CodeTime.markEnd()
            await state.setIsRunning(false)
            await state.setRenderTime(CodeTime.elapsedSeconds())
        } //Task
        
    } //renderEq
    
}









