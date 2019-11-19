//
//  LevelSelectScene.swift
//  FinalProject
//
//  Created by Julian Davis on 10/14/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

var l1label = SKLabelNode(text: "Level 1")
var l2label = SKLabelNode(text: "Level 2")
var l3label = SKLabelNode(text: "Level 3")

var levelSelectCamera = SKCameraNode()

class LevelSelectScene : SKScene {
    override func didMove(to view: SKView) {
        l1label.fontColor = .black; l2label.fontColor = .black; l3label.fontColor = .black
        
        //setting up camera
        levelSelectCamera = self.childNode(withName: "levelSelectCamera") as! SKCameraNode
        levelSelectCamera.position = CGPoint(x: (frame.size.width / 2), y: (frame.size.height / 2))
        
        //setting scenes as variables
        var l1scene = SKScene(fileNamed: "Level1Scene")
        var l2scene = SKScene(fileNamed: "Level2Scene")
        var l3scene = SKScene(fileNamed: "Level3Scene")
        
        var transition: SKTransition = SKTransition.fade(withDuration: 1)
        
        //functions to switch scenes
        
        func playL1(){
            self.view?.presentScene(l1scene!, transition: transition)
        }
        func playL2(){
            self.view?.presentScene(l2scene!, transition: transition)
        }
        func playL3(){
            self.view?.presentScene(l3scene!, transition: transition)
        }
        
        //buttons to trigger functions
        let l1Button = Button(defaultButtonImage: "button",
                                 activeButtonImage: "button_active",
                                 buttonAction: playL1)
        l1Button.position = CGPoint(x: (frame.size.width / 4), y: (frame.size.height / 2))
        addChild(l1Button)
        l1Button.addChild(l1label)
        
        let l2Button = Button(defaultButtonImage: "button",
                              activeButtonImage: "button_active",
                              buttonAction: playL2)
        l2Button.position = CGPoint(x: (frame.size.width * (2/4)), y: (frame.size.height / 2))
        addChild(l2Button)
        l2Button.addChild(l2label)
        
        let l3Button = Button(defaultButtonImage: "button",
                              activeButtonImage: "button_active",
                              buttonAction: playL3)
        l3Button.position = CGPoint(x: (frame.size.width * (3/4)), y: (frame.size.height / 2))
        addChild(l3Button)
        l3Button.addChild(l3label)
    }
}
