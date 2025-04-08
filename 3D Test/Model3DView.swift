//
//  Model3DView.swift
//  3D Test
//
//  Created by Tirso López Ausens on 5/4/25.
//

import SwiftUI
import SceneKit

struct Model3DView: View {
    // Create the scene that will hold our 3D content
    let scene = SCNScene()
        
    // Name of the 3D model file (without extension)
    var modelName: String
    
    // Initialize with model name and night mode state
    init(modelName: String) {
        self.modelName = modelName
        setupScene()
    }
    
    var body: some View {
        ZStack {
            // Use custom SceneView with transparent background
            CustomModelSceneView(scene: scene)
                .frame(width: 360, height: 360)
        }
    }
    
    private func setupScene() {
        // Set scene background to clear/transparent
        scene.background.contents = UIColor.clear
        
        // Load the model
        loadModel()
        
        // Set up a camera - position it further back
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 0) // Moved further back to see more of the scene
        cameraNode.eulerAngles = SCNVector3(0, 0, 0) // Look directly at model
        scene.rootNode.addChildNode(cameraNode)
        
        // Add stronger lighting for better visibility
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.9, alpha: 1.0) // Brighter ambient light
        scene.rootNode.addChildNode(ambientLight)
        
        // Add directional light for shadows and definition
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 1000 // Much stronger light
        directionalLight.eulerAngles = SCNVector3(-Float.pi/4, Float.pi/4, 0) // I think I like this angle better
        scene.rootNode.addChildNode(directionalLight)
    }
    
    private func loadModel() {
        // Print debug info about available resources
        print("🔍 Searching for model: \(modelName).dae")
        print("📦 Bundle path: \(Bundle.main.bundlePath)")
        
        // List all DAE files in the bundle
        let allDaeFiles = Bundle.main.paths(forResourcesOfType: "dae", inDirectory: nil)
        print("📋 All DAE files in bundle: \(allDaeFiles)")
        
        // Try to load the model from the bundle
        guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "dae") else {
            print("❌ Failed to find model: \(modelName).dae")
            
            // Create a fallback cube model since the file wasn't found
            createFallbackCube()
            return
        }
        
        do {
            // Load the model scene
            print("✅ Found model URL: \(modelUrl)")
            let modelScene = try SCNScene(url: modelUrl, options: [SCNSceneSource.LoadingOption.animationImportPolicy: SCNSceneSource.AnimationImportPolicy.playRepeatedly])
            
            // Print node hierarchy for debugging
            print("📊 Model scene node hierarchy:")
            printNodeHierarchy(modelScene.rootNode)
            
            // Get the model's root node
            guard let modelNode = modelScene.rootNode.childNodes.first else {
                print("❌ No nodes found in model")
                createFallbackCube()
                return
            }
            
            print("✅ Found model node: \(modelNode.name ?? "unnamed")")
            
            // Position the model at the center and slightly rotate for better view
            modelNode.position = SCNVector3(0, -11, -30)
            
            // Scale the model to be much larger - your model might be very small
            modelNode.scale = SCNVector3(0.15, 0.15, 0.15)
            
            // fix initial rotation
            modelNode.eulerAngles = SCNVector3(0, 0, 0)
            
            
            // Preserve the original materials instead of overriding them
            // Commenting out material application to use the model's original materials
            // applyMaterials(to: modelNode)
            
            // Add rotation animation
            let rotationAction = SCNAction.rotate(by: CGFloat(Float.pi) * 2, around: SCNVector3(0, 1, 0), duration: 8.0)
            let repeatAction = SCNAction.repeatForever(rotationAction)
            modelNode.runAction(repeatAction)
            
            // Add the model to our scene
            scene.rootNode.addChildNode(modelNode)
            
        } catch {
            print("❌ Error loading model: \(error.localizedDescription)")
            createFallbackCube()
        }
    }
    
    // Helper function to print node hierarchy for debugging
    private func printNodeHierarchy(_ node: SCNNode, depth: Int = 0) {
        let indent = String(repeating: "  ", count: depth)
        let nodeName = node.name ?? "unnamed"
        print("\(indent)- \(nodeName) (geometry: \(node.geometry != nil ? "yes" : "no"))")
        
        for childNode in node.childNodes {
            printNodeHierarchy(childNode, depth: depth + 1)
        }
    }
    
    // Create a fallback cube if model loading fails
    private func createFallbackCube() {
        print("⚠️ Creating fallback cube model")
        let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.05)
        
        // Create different materials for each face
        var materials = [SCNMaterial]()
        
        // Choose colors based on isNight state
        let colors: [UIColor] = [.darkGray, .lightGray, .systemIndigo, .systemTeal, .darkGray, .systemBlue]

        for color in colors {
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.specular.contents = UIColor.white
            material.shininess = 0.7
            materials.append(material)
        }
        
        cubeGeometry.materials = materials
        
        // Create node with the cube geometry
        let cubeNode = SCNNode(geometry: cubeGeometry)
        
        // Add rotation animation
        let rotationAction = SCNAction.rotate(by: CGFloat(Float.pi) * 2, around: SCNVector3(1, 1, 0), duration: 5.0)
        let repeatAction = SCNAction.repeatForever(rotationAction)
        cubeNode.runAction(repeatAction)
        
        // Add the cube to the scene
        scene.rootNode.addChildNode(cubeNode)
    }
    
    // to tweak the colors of the model
//    private func applyMaterials(to node: SCNNode) {
//        // Colors to use based on day/night mode
//        let baseColor = isNight ? UIColor.darkGray : UIColor.systemBlue
//        let accentColor = isNight ? UIColor.systemIndigo : UIColor.systemTeal
//        
//        // Apply materials to the node and its children
//        applyColorRecursively(to: node, baseColor: baseColor, accentColor: accentColor)
//    }
//    
//    private func applyColorRecursively(to node: SCNNode, baseColor: UIColor, accentColor: UIColor, depth: Int = 0) {
//        // If this node has geometry, apply material
//        if let geometry = node.geometry {
//            let material = SCNMaterial()
//            // Alternate between base and accent colors based on depth
//            material.diffuse.contents = depth % 2 == 0 ? baseColor : accentColor
//            material.specular.contents = UIColor.white
//            material.shininess = 0.7
//            
//            // Apply to all geometry materials
//            geometry.materials = [material]
//        }
//        
//        // Recursively apply to child nodes
//        for (index, childNode) in node.childNodes.enumerated() {
//            applyColorRecursively(to: childNode, baseColor: baseColor, accentColor: accentColor, depth: depth + index)
//        }
//    }
}

// Custom UIViewRepresentable wrapper for SCNView
struct CustomModelSceneView: UIViewRepresentable {
    var scene: SCNScene
    
    func makeUIView(context: Context) -> SCNView {
        // Create SceneView with appropriate options
        let scnView = SCNView()
        
        // Configure the view for transparency
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.isJitteringEnabled = true
        scnView.preferredFramesPerSecond = 60
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {

        uiView.backgroundColor = UIColor.clear
        
        if let scene = uiView.scene {
            scene.background.contents = UIColor.clear
        }
    }
}
