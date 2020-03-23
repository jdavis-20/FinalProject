//
//  Popup.swift
//  FinalProject
//
//  Created by Julian Davis on 2/11/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import SpriteKit
import UIKit

class Popup: SKNode {
    
    let popupNode: SKSpriteNode
    var label = SKLabelNode()
    var itemName = SKLabelNode()
    var character: String
    
    var char1button: Button, char2button: Button, char3button: Button
    var loseReturnButton: Button, winReturnButton: Button, startButton: Button
    var tiltResetButton: Button
    
    var sfxVol = VolumeControl(label: "SFX")
    var musicVol = VolumeControl(label: "Music")


    func char1() {
        character = "Med"
        print("POPUP: select 1, Medical, effect enemy slowdown")
        // effects are located in Enemy.swift pathfinding method
        for button in [char2button, char3button] {
            if button.activeButton.isHidden == false {
                button.toggle()
            }
        }
    }
    func char2() {
        character = "Bot"
        print("POPUP: select 2, Botanical, effect player camo")
        // effects are located in Enemy.swift pathfinding method, opacity effect in GameScene.swift update method
        for button in [char1button, char3button] {
            if button.activeButton.isHidden == false {
                button.toggle()
            }
        }
    }
    func char3() {
        character = "Arch"
        print("POPUP: select 3, Archaeological, effect item attract")
        // effects are located in Item.swift attract method
        for button in [char1button, char2button] {
            if button.activeButton.isHidden == false {
                button.toggle()
            }
        }
    }
    func resetChar() {
        character = ""
        print("POPUP: character deselected")
    }
    
    init(type: String, worldNode: SKNode) {
        
        popupNode = SKSpriteNode(imageNamed: "pop")
        popupNode.isHidden = true
        popupNode.name = "popupNode"
        label.isHidden = true
        popupNode.zPosition = 3
        label.fontName = "Conductive"
//        label.zPosition = 4
        label.position = CGPoint(x: 0, y: popupNode.frame.size.height/4)
//        itemName.zPosition = 4
        popupNode.position = CGPoint(x: 0, y: 0)
        popupNode.alpha = 0.8
        itemName.fontName = "Conductive"
        
        sfxVol.position = CGPoint(x: 0, y: 40)
//        sfxVol.zPosition = 4
        musicVol.position = CGPoint(x: 0, y: -40)
//        musicVol.zPosition = 4

        
        character = ""

        char1button = Button(defaultButtonImage: "button",
                             activeButtonImage: "buttonflat",
                             label: "ch1",
                             toggle: true)
        char1button.position = CGPoint(x: -popupNode.frame.size.width/4, y: 0)
//        char1button.zPosition = 3
        char2button = Button(defaultButtonImage: "button",
                             activeButtonImage: "buttonflat",
                             label: "ch2",
                             toggle: true)
        char2button.position = CGPoint(x: 0, y: 0)
//        char2button.zPosition = 3
        char3button = Button(defaultButtonImage: "button",
                             activeButtonImage: "buttonflat",
                             label: "ch3",
                             toggle: true)
        char3button.position = CGPoint(x: popupNode.frame.size.width/4, y: 0)
//        char3button.zPosition = 3
        
        loseReturnButton = Button(defaultButtonImage: "button",
                                  activeButtonImage: "buttonflat",
                                  label: "main menu",
                                  toggle: false)
        loseReturnButton.position = CGPoint(x: 0, y: 40)
//        loseReturnButton.zPosition = 3
        
        winReturnButton = Button(defaultButtonImage: "button",
                                 activeButtonImage: "buttonflat",
                                 label: "main menu",
                                 toggle: false)
        winReturnButton.position = CGPoint(x: 0, y: 40)
//        winReturnButton.zPosition = 3
        
        startButton = Button(defaultButtonImage: "button",
                             activeButtonImage: "buttonflat",
                             label: "START",
                             toggle: false)
        startButton.position = CGPoint(x: 0,
                                       y: -80)
//        startButton.zPosition = 3
        tiltResetButton = Button(defaultButtonImage: "button",
                                 activeButtonImage: "buttonflat",
                                 label: "reset tilt",
                                 toggle: false)
        tiltResetButton.position = CGPoint(x: 0,
                                           y: -100)
//        tiltResetButton.zPosition = 3
        
        super.init()

        char1button.action = char1
        char2button.action = char2
        char3button.action = char3
        char1button.altAction = resetChar
        char2button.altAction = resetChar
        char3button.altAction = resetChar
        
        self.addChild(popupNode)
        self.addChild(label)
        
        if type == "win" {
            label.text = "win"
            self.addChild(winReturnButton)
        }
            
        if type == "lose"{
            label.text = "lose"
            self.addChild(loseReturnButton)
        }
            
        if type == "item"{
            label.text = "got item"
            self.addChild(itemName)
        }
            
        if type == "options"{
            label.text = "options"
            self.addChild(sfxVol)
            self.addChild(musicVol)
            self.addChild(tiltResetButton)
        }
        
        if type == "charsel"{
            label.text = "character select"
            for button in [char1button, char2button, char3button, startButton] {
                self.addChild(button)
            }
        }
        
        isUserInteractionEnabled = true
}
    
    func visible() {
        worldNode.isPaused = true
        popupNode.isUserInteractionEnabled = true
        for node in [popupNode, label, itemName] as [SKNode] {
            node.isHidden = false
        }
        for child in self.children {
            child.isHidden = false
        }
    }
    func invisible() {
        worldNode.isPaused = false
        popupNode.isUserInteractionEnabled = false
        for node in [popupNode, label, itemName] as [SKNode] {
            node.isHidden = true
        }
        for child in self.children {
            child.isHidden = true
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
