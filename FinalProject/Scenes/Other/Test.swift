//
//  Test.swift
//  FinalProject
//
//  Created by Julian Davis on 4/6/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import SpriteKit

var testSceneCam = SKCameraNode()

class Test: SKScene {
    override func didMove(to view: SKView) {
        testSceneCam = self.childNode(withName: "testSceneCam") as! SKCameraNode
        
        super.didMove(to: view)
    }
    
    override func update(_ currentTime: TimeInterval) {
//        let transition = SKTransition.fade(withDuration: 1)
//        fix later, some force unwrap of a nil value is causing crassh
//        if let previousScene = self.userData!["previousScene"] as? SKScene {
//            print(previousScene.name)
//            self.view!.presentScene(previousScene, transition: transition)
//        }
        
    }
}
