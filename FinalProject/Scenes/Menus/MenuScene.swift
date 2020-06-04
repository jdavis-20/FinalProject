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
        let bkgd = childNode(withName: "background")
        let menuScale = self.frame.size.width/bkgd!.frame.size.width
        bkgd?.setScale(menuScale)
        bkgd?.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
        let textbox = childNode(withName: "textbox")
        textbox?.setScale(menuScale)
        textbox?.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
//        let song = SKAudioNode(fileNamed: "menuloop.wav")
//        song.autoplayLooped = true
//        let mute = SKAction.changeVolume(to: 0, duration: 0)
//        let fadeIn = SKAction.changeVolume(to: 1, duration: 2)
//        let sequence = SKAction.sequence([mute, fadeIn])
//        let fadeOut = SKAction.changeVolume(to: 0, duration: 1)
//        song.run(mute)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.addChild(song)
//            song.run(fadeIn)
//        }
        
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
        let playButton = Button(defaultButtonImage: "transparent",
                                activeButtonImage: "transparent",
                                label: "Launch",
                                textMove: false)
        playButton.action = levelSelect
        playButton.buttonLabel.fontSize = 34
        playButton.buttonLabel.position = CGPoint(x: 0, y: 8)
        playButton.position = CGPoint(x: (frame.size.width / 2),
                                      y: (frame.size.height / 2))
        addChild(playButton)
        
        func exitApp() {
            print("EXIT")
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        }
        
        let exitButton = Button(defaultButtonImage: "transparent",
                                activeButtonImage: "transparent",
                                label: "Exit",
                                textMove: false)
        exitButton.action = exitApp
        exitButton.position = CGPoint(x: frame.size.width/2, y: frame.size.height/3)
        
        addChild(exitButton)
    }
}
