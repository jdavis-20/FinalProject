//
//  Level1Scene.swift
//  FinalProject
//
//  Created by Julian Davis on 10/13/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox


var level1Label = SKLabelNode()

class Level1Scene: GameScene {
    override func didMove(to view: SKView) {
        level1Label.text = "Level 1"
        level1Label.fontSize = 30
        level1Label.zPosition = 5
        level1Label.position = CGPoint(x:0, y:0)
        addChild(level1Label)
        
        // runs through all nodes in the scene, finds those with a specific name and sets the physics for them as walls
        scene?.enumerateChildNodes(withName: "MazeWall") {
            (node, stop) in
            let mazeNode = node as? MazeWall
            mazeNode?.setWallPhysics()
        }
        
        let firstItem = Item(image: "item_temp", position: CGPoint(x: (frame.size.width / 4), y: (frame.size.height / 4)))
        worldNode.addChild(firstItem)
        //collision handling is in the gamescene class
        
    
        

        
//        let leftWall: Wall =
//            Wall(height: 400.0,
//                 width: 10.0,
//                 color: .blue,
//                 position: CGPoint(x:(frame.size.width / 10),
//                                   y:(frame.size.height / 2)))
//        addChild(leftWall)
//
//        let rightWall: Wall =
//            Wall(height: 400.0,
//                 width: 10.0,
//                 color: .blue,
//                 position: CGPoint(x:(frame.size.width * (9/10)),
//                                   y:(frame.size.height / 2)))
//        addChild(rightWall)
//
//        let topWall: Wall =
//            Wall(height: 10,
//                 width: 600,
//                 color: .blue,
//                 position: CGPoint(x:(frame.size.width / 2),
//                                   y:(frame.size.height / 10)))
//        addChild(topWall)
//
//        let bottomWall: Wall =
//            Wall(height: 10,
//                 width: 600,
//                 color: .blue,
//                 position: CGPoint(x:(frame.size.width / 2),
//                                   y:(frame.size.height * (9/10))))
//        addChild(bottomWall)
        
        super.didMove(to: view)
    }
    
}
