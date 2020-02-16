//
//  MenuScene.swift
//  FinalProject
//
//  Created by Julian Davis on 10/13/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

var menuCamera = SKCameraNode()


class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        //setting up camera
        menuCamera = self.childNode(withName: "menuCamera") as! SKCameraNode
        menuCamera.position = CGPoint(x: (frame.size.width / 2),
                                      y: (frame.size.height / 2))

        //setting scene to transition to
        var scene = SKScene(fileNamed: "LevelSelectScene")
        var transition: SKTransition = SKTransition.fade(withDuration: 1)
        
        func levelSelect(){
            self.view?.presentScene(scene!,
                                    transition: transition)
            self.removeAllChildren()
            self.removeAllActions()
        }
        
        //button triggers actual transition
        let playButton = Button(defaultButtonImage: "play",
                                 activeButtonImage: "play",
                                 buttonAction: levelSelect,
                                 label: "")
        playButton.position = CGPoint(x: (frame.size.width / 2),
                                      y: (frame.size.height / 2))
        addChild(playButton)
    }
}
