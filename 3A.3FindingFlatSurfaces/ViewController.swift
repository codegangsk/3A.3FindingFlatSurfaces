//
//  ViewController.swift
//  3A.3FindingFlatSurfaces
//
//  Created by Sophie Kim on 2020/08/26.
//  Copyright © 2020 Sophie Kim. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "art.scnassets/planeDetect.scn")!
        
        sceneView.scene = scene
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
        ARSCNDebugOptions.showWorldOrigin]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal, .vertical]

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node:
       SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let floor = createFloor(planeAnchor: planeAnchor)
        node.addChildNode(floor)
        
        let ship = createShip(planeAnchor: planeAnchor)
        node.addChildNode(ship)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        node.geometry = geometry
        
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 0.25
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node:
       SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor
            else { return }
        
        for node in node.childNodes {
                node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            if let plane = node.geometry as? SCNPlane {
                plane.width = CGFloat(planeAnchor.extent.x)
                plane.height = CGFloat(planeAnchor.extent.z)
            }
        }
    }
    
    func createShip(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.clone()
        node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        return node
    }
}
