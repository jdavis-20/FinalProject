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
        let transition = SKTransition.fade(withDuration: 1)
        if let userData = self.userData, let previousScene = userData["previousScene"] as? SKScene
        {
            print(previousScene.name)
            self.view!.presentScene(previousScene, transition: transition)
        }
        
        super.didMove(to: view)
    }
}
