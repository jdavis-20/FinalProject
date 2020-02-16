//
//  LevelSelectScene.swift
//  FinalProject
//
//  Created by Julian Davis on 10/14/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

var levelSelectCamera = SKCameraNode()

class LevelSelectScene : SKScene {
    override func didMove(to view: SKView) {
        
//        TODO: fix overlay touch through
//        let overlay = childNode(withName: "overlay")
//        overlay?.isUserInteractionEnabled = false;
        
        //setting up camera
        levelSelectCamera = self.childNode(withName: "levelSelectCamera") as! SKCameraNode
        levelSelectCamera.position = CGPoint(x: 0,
                                             y: 0)
        
        print(frame.size)
        
        //setting scenes as variables
        var l1scene = SKScene(fileNamed: "Level1Scene")
        var l2scene = SKScene(fileNamed: "Level2Scene")
        var l3scene = SKScene(fileNamed: "Level3Scene")
        var l4scene = SKScene(fileNamed: "Level4Scene")
        
        var transition: SKTransition = SKTransition.fade(withDuration: 1)
        
        //functions to switch scenes
        
        func playL1(){
            self.view?.presentScene(l1scene!,
                                    transition: transition)
            self.removeAllChildren()
            self.removeAllActions()
        }
        func playL2(){
            self.view?.presentScene(l2scene!,
                                    transition: transition)
            self.removeAllChildren()
            self.removeAllActions()
        }
        func playL3(){
            self.view?.presentScene(l3scene!,
                                    transition: transition)
            self.removeAllChildren()
            self.removeAllActions()
        }
        func playL4(){
            self.view?.presentScene(l4scene!,
                                    transition: transition)
            self.removeAllChildren()
            self.removeAllActions()
        }
        
        //buttons to trigger functions
        
        let l1Button = Button(defaultButtonImage: "yel",
                                 activeButtonImage: "yell",
                                 buttonAction: playL1,
                                 label: "")
        l1Button.setScale(0.4)
        l1Button.position = CGPoint(x: ((-frame.size.width/2) + 100),
                                    y: ((frame.size.height/2) - 100))
        addChild(l1Button)
        
        let l2Button = Button(defaultButtonImage: "blu",
                              activeButtonImage: "blul",
                              buttonAction: playL2,
                              label: "")
        l2Button.setScale(0.4)
        l2Button.position = CGPoint(x: (-frame.size.width/16),
                                    y: ((-frame.size.height/2) + 110))
        addChild(l2Button)
        
        let l3Button = Button(defaultButtonImage: "pur",
                              activeButtonImage: "purl",
                              buttonAction: playL3,
                              label: "")
        l3Button.setScale(0.4)
        l3Button.position = CGPoint(x: (frame.size.width * (1/8)),
                                    y: (frame.size.height/2) - 60)
        addChild(l3Button)
        
        let l4Button = Button(defaultButtonImage: "red",
                              activeButtonImage: "redl",
                              buttonAction: playL4,
                              label: "")
        l4Button.setScale(0.4)
        l4Button.position = CGPoint(x: ((frame.size.width/2) - 90),
                                    y: 0)
        addChild(l4Button)
    }
}
