//
//  ViewController.swift
//  AR Measurement Tool
//
//  Created by Bilal on 2018-03-22.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
    
    }
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            
            dotNodes = [SCNNode]()
            
        }
     
        if let  touchLocations = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocations, types: .featurePoint)
        
            if let hitResult = hitTestResults.first {
                
                addDot(at : hitResult)
                
            }
            
        
        }
        
        
    }
    
    
    func addDot(at hitResult : ARHitTestResult){
        
        let dotGeometry = SCNSphere(radius : 0.005)
        
        let sphereMaterial = SCNMaterial()
        
        sphereMaterial.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [sphereMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            self.calculate()
            
        }
    }
    
    func calculate(){
        
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        
        var distance = sqrt(
        pow(end.position.x - start.position.x, 2 ) +
        pow(end.position.y - start.position.y, 2 ) +
        pow(end.position.z - start.position.z, 2 )
        )
        
        
        distance = round(10000.0 * distance) / 100.0
      
        
        
        updateText(text: "\(distance) Cm", atPosition: end.position)
        
    }
    
    
    func updateText(text : String, atPosition position: SCNVector3){
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.green
        
        textNode =  SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        textNode.runAction(
            
            SCNAction.rotateBy(x: CGFloat(-Float.pi / 4) , y: 0, z: 0, duration: 0.1)
        
        )
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
    }
    
    
    
    
    
    
    
}
