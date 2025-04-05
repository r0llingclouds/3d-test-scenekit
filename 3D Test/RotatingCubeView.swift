//
//  RotatingCubeView.swift
//  3D Test
//
//  Created by Tirso López Ausens on 5/4/25.
//

import SwiftUI
import SceneKit

struct RotatingCubeView: View {
    // Create the scene that will hold our 3D content
    let scene = SCNScene()
    
    // Controls whether we use dark or light materials
    var isNight: Bool
    
    init(isNight: Bool) {
        self.isNight = isNight
        setupScene()
    }
    
    var body: some View {
        ZStack {
            // Make the entire background transparent
            Color.clear
            
            // Use custom SceneView with transparent background
            CustomSceneView(scene: scene, isNight: isNight)
                .frame(width: 180, height: 180)
        }
        .frame(width: 180, height: 180)
    }
    
    private func setupScene() {
        // Set scene background to clear/transparent
        scene.background.contents = UIColor.clear
        
        // Create a cube geometry with size 1.0
        let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.05)
        
        // Create different materials for each face of the cube
        let materials = createMaterials()
        cubeGeometry.materials = materials
        
        // Create a node with the cube geometry
        let cubeNode = SCNNode(geometry: cubeGeometry)
        
        // Add rotation animation
        let rotationAction = SCNAction.rotate(by: .pi * 2, around: SCNVector3(1, 1, 0), duration: 5.0)
        let repeatAction = SCNAction.repeatForever(rotationAction)
        cubeNode.runAction(repeatAction)
        
        // Add the cube node to the scene
        scene.rootNode.addChildNode(cubeNode)
        
        // Set up a camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 3) // Position the camera
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func createMaterials() -> [SCNMaterial] {
        var materials = [SCNMaterial]()
        
        // Colors for day mode
        let dayColors: [UIColor] = [
            .systemBlue, .systemYellow, .systemGreen,
            .systemOrange, .systemPurple, .systemPink
        ]
        
        // Colors for night mode
        let nightColors: [UIColor] = [
            .darkGray, .lightGray, .systemIndigo,
            .systemTeal, .darkGray, .systemBlue
        ]
        
        // Choose colors based on isNight state
        let colors = isNight ? nightColors : dayColors
        
        // Create materials for each face
        for color in colors {
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.specular.contents = UIColor.white
            material.shininess = 0.7
            materials.append(material)
        }
        
        return materials
    }
}

// Custom UIViewRepresentable wrapper for SCNView with transparent background
struct CustomSceneView: UIViewRepresentable {
    var scene: SCNScene
    var isNight: Bool
    
    func makeUIView(context: Context) -> SCNView {
        // Create SceneView with appropriate options
        let scnView = SCNView()
        
        // Configure the view for transparency
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.clear
        scnView.isJitteringEnabled = true
        scnView.preferredFramesPerSecond = 60
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update any view properties if needed
        uiView.backgroundColor = UIColor.clear
        
        // Ensure scene's background is clear
        if let scene = uiView.scene {
            scene.background.contents = UIColor.clear
        }
    }
}
