//
//  Merged3DView.swift
//  3D Test
//
//  Created by Tirso López Ausens on 12/4/25.
//

import SwiftUI
import SceneKit

struct Model3DView: View {
    // Scene that will hold our 3D content
    let scene = SCNScene()
    
    // Name of the 3D model file (without extension)
    var modelName: String
    
    // Initialize with model name
    init(modelName: String) {
        self.modelName = modelName
        setupScene()
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Use custom SceneView with transparent background
            CustomModelSceneView(scene: scene)
                .background(Color.clear)
                .frame(width: 250, height: 250)
        }
        .background(Color.clear)
    }
    
    private func setupScene() {
        // Set scene background to clear/transparent
        scene.background.contents = UIColor.clear
        
        // Load the model
        loadModel()
        
        // Set up a camera - position it further back
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 2, 0) // Moved further back to see more of the scene
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
        print("🔍 Searching for model: \(modelName).usdz")
        print("📦 Bundle path: \(Bundle.main.bundlePath)")
        
        // List all USDZ files in the bundle
        let allUsdzFiles = Bundle.main.paths(forResourcesOfType: "usdz", inDirectory: nil)
        print("📋 All USDZ files in bundle: \(allUsdzFiles)")
        
        // Try to load the model from the bundle
        guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
            print("❌ Failed to find model: \(modelName).usdz")
            
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
        
        // Choose colors
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
