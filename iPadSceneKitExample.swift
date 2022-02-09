import SwiftUI
import SceneKit



struct ContentView: View {
    
    let ezscene = EZScene() //creates the scene, camera and viewOptions
    
    var body: some View {
        VStack {
            
            SceneView(
                scene: ezscene.scene,
                pointOfView: ezscene.camera,
                options: ezscene.viewOptions
            )
            
            HStack { //manipulate the scene
                Button("remove box") {
                    ezscene.scene.rootNode.geometry = nil
                }
                Spacer()
                Button("replace box") {
                    ezscene.createAndPutBoxOnRoot()
                }
            }
            
        }
    }
    
}



class EZScene {
    
    let scene: SCNScene
    let camera: SCNNode
    let viewOptions: SceneView.Options
    
    init() {
        
        //create the stuff for SceneView
        scene = SCNScene()
        
        camera = SCNNode()
        camera.camera = SCNCamera()
        camera.position = SCNVector3(x: 0, y: 0, z: 1)
        
        viewOptions = [
            .allowsCameraControl,
            .autoenablesDefaultLighting,
            .temporalAntialiasingEnabled
        ]
        
        //set up the scene object
        scene.background.contents = UIColor.purple
        createAndPutBoxOnRoot()
        
    }
    
    
    func createAndPutBoxOnRoot() {
        
        //create box geometry
        let box = SCNBox(width: 2, height: 2, length: 1, chamferRadius: 0.2)
        
        //create material for box geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        material.lightingModel = .phong
        
        //set the material on the box (array because several materials can be applied)
        box.materials = [material]
        
        //set the box as the geometry of the scenes root node (the only SCNNode in this scene)
        scene.rootNode.geometry = box
        
    }
    
}
