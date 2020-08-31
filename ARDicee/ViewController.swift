//
//  ViewController.swift
//  ARDicee
//
//  Created by user177767 on 8/30/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        //Creación de una geometría tridimensional, en este caso un cubo
//        let cube = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.01)
//
//        //Creación y asignación del material que conforma el cubo
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//
//        cube.materials = [material]
//
//        //Creación un nodo (Un punto en un espacio en 3D)
//        let node = SCNNode()
//        node.position = SCNVector3(0.0, 0.1, -0.5)
//
//        //Asignamos una geometría al nodo creado
//        node.geometry = cube
//
//        //Asignación de childNode al rootNode
//        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(0, 0, -0.1)
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
//
////        // Set the scene to the view
////        sceneView.scene = diceScene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if !results.isEmpty {
                print("touched the plane")
            } else {
                print("touched somewhere else")
            }
            
        }
        
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {

            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x) , height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
        
    }
    
}
