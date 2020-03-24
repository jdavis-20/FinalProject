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
        self.name = "LevelSelect"
        
//        let song = SKAudioNode(fileNamed: "menuloop.wav")
//        song.autoplayLooped = true
//        let mute = SKAction.changeVolume(to: 0, duration: 0)
//        let fadeIn = SKAction.changeVolume(to: 1, duration: 2)
//        let sequence = SKAction.sequence([mute, fadeIn])
//        let fadeOut = SKAction.changeVolume(to: 0, duration: 1)
//        song.run(mute)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//        self.addChild(song)
//        song.run(fadeIn)
//        }
        
//        let music = SKAction.playSoundFileNamed("menuloop.wav", waitForCompletion: true)
//        let musicLoop = SKAction.repeatForever(music)
//        SKAction.changeVolume(to: 0, duration: 1)
//        self.run(musicLoop)
        
        let overlayBottom = childNode(withName: "overlaybottom")
        let obWidth = overlayBottom!.frame.size.width
        overlayBottom?.setScale(self.frame.size.width/obWidth)
        overlayBottom?.position = CGPoint(x: 0, y: -self.frame.size.height/2)
        
        let overlayLeft = childNode(withName: "overlayleft")
        overlayLeft?.setScale(self.frame.size.width/obWidth)
        overlayLeft?.position = CGPoint(x: -self.frame.size.width/2, y: 0)
        
        let overlayRight = childNode(withName: "overlayright")
        overlayRight?.setScale(self.frame.size.width/obWidth)
        overlayRight?.position = CGPoint(x: self.frame.size.width/2, y: 0)
        
        let bkgd = childNode(withName: "bkgd")
        bkgd?.setScale(self.frame.size.width/bkgd!.frame.size.width)
        
        //setting up camera
        levelSelectCamera = self.childNode(withName: "levelSelectCamera") as! SKCameraNode
        levelSelectCamera.position = CGPoint(x: 0,
                                             y: 0)
        
        print("INIT: \(frame.size)")
        
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
                                 activeButtonImage: "yell")
        l1Button.action = playL1
        l1Button.setScale(0.38)
        l1Button.defaultButton.anchorPoint = CGPoint(x: 0, y: 1)
        l1Button.activeButton.anchorPoint = CGPoint(x: 0, y: 1)
        l1Button.position = CGPoint(x: (-frame.size.width/2),
                                    y: (frame.size.height/2))
        addChild(l1Button)
        
        let l2Button = Button(defaultButtonImage: "blu",
                              activeButtonImage: "blul")
        l2Button.action = playL2
        l2Button.setScale(0.38)
        l2Button.defaultButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        l2Button.activeButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        l2Button.position = CGPoint(x: (-frame.size.width/16),
                                    y: (-frame.size.height/2))
        addChild(l2Button)
        
        let l3Button = Button(defaultButtonImage: "pur",
                              activeButtonImage: "purl")
        l3Button.action = playL3
        l3Button.setScale(0.38)
        l3Button.defaultButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        l3Button.activeButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        l3Button.position = CGPoint(x: (frame.size.width/8),
                                    y: (frame.size.height/2))
        addChild(l3Button)
        
        let l4Button = Button(defaultButtonImage: "red",
                              activeButtonImage: "redl")
        l4Button.action = playL4
        l4Button.setScale(0.38)
        l4Button.defaultButton.anchorPoint = CGPoint(x: 1, y: 0.5)
        l4Button.activeButton.anchorPoint = CGPoint(x: 1, y: 0.5)
        l4Button.position = CGPoint(x: (frame.size.width/2),
                                    y: 0)
        addChild(l4Button)
    }
}
