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
        self.name = "Menu"
        
        let song = SKAudioNode(fileNamed: "menuloop.wav")
        song.autoplayLooped = true
        addChild(song)
        let mute = SKAction.changeVolume(to: 0, duration: 0)
        let fadeIn = SKAction.changeVolume(to: 1, duration: 3)
        let sequence = SKAction.sequence([mute, fadeIn])
        let fadeOut = SKAction.changeVolume(to: 0, duration: 1)
        song.run(sequence)
        
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
        let playButton = Button(defaultButtonImage: "launchbutton",
                                 activeButtonImage: "launchbutton",
                                 label: "")
        playButton.setScale(0.8)
        playButton.action = levelSelect
        playButton.position = CGPoint(x: (frame.size.width / 2),
                                      y: (frame.size.height / 2))
        addChild(playButton)
    }
}
