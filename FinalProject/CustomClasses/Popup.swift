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
    
//    let popupNode: SKSpriteNode
    let popupNodeButton: Button
    var label = SKLabelNode()
    var itemName = SKLabelNode()
    var character: String
    let gameScene = GameScene.self()
    
    var char1button: Button, char2button: Button, char3button: Button
    var loseReturnButton: Button, winReturnButton: Button, startButton: Button
    var retryButton: Button, levSelButton: Button
    var tiltResetButton: Button, vibrateButton: Button
    
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
    
    init(type: String) {
        popupNodeButton = Button(defaultButtonImage: "pop", activeButtonImage: "pop", textMove: false)
        popupNodeButton.name = "popupNodeButton"
        popupNodeButton.isHidden = true
        label.isHidden = true
        popupNodeButton.zPosition = 3
        label.fontName = "Conductive"
        label.position = CGPoint(x: 0, y: popupNodeButton.defaultButton.frame.size.height/4)
        popupNodeButton.position = CGPoint(x: 0, y: 0)
        popupNodeButton.alpha = 0.8
        itemName.fontName = "Conductive"
        
        sfxVol.position = CGPoint(x: -75, y: 40)
        musicVol.position = CGPoint(x: 75, y: 40)

        character = ""

        char1button = Button(label: "Slow", toggle: true)
        char1button.position = CGPoint(x: -popupNodeButton.defaultButton.frame.size.width/4, y: 0)
        char2button = Button(label: "Camo", toggle: true)
        char2button.position = CGPoint(x: 0, y: 0)
        char3button = Button(label: "Pull", toggle: true)
        char3button.position = CGPoint(x: popupNodeButton.defaultButton.frame.size.width/4, y: 0)
        
        loseReturnButton = Button(label: "Menu")
        loseReturnButton.position = CGPoint(x: 0, y: 40)
        
        retryButton = Button(label: "Retry")
        retryButton.position = CGPoint(x: 0, y: -40)
        
        winReturnButton = Button(label: "Menu")
        winReturnButton.position = CGPoint(x: 0, y: 40)

        levSelButton = Button(label: "Continue")
        levSelButton.position = CGPoint(x: 0, y: -40)
        
        startButton = Button(label: "Start")
        startButton.position = CGPoint(x: 0, y: -80)
        
        tiltResetButton = Button(defaultButtonImage: "buttonwide", activeButtonImage: "flatwide",
                                 label: "Recalibrate")
        tiltResetButton.position = CGPoint(x: 0, y: -30)
        vibrateButton = Button(defaultButtonImage: "buttonwide", activeButtonImage: "flatwide",
                               label: "Vibrate On", toggle: true)
        vibrateButton.position = CGPoint(x: 0, y: -100)
        
        super.init()

        char1button.action = char1
        char2button.action = char2
        char3button.action = char3
        char1button.altAction = resetChar
        char2button.altAction = resetChar
        char3button.altAction = resetChar
        
        self.addChild(popupNodeButton)
        self.addChild(label)
        self.isUserInteractionEnabled = true
        self.name = "popup"
        
        if type == "win" {
            label.text = "You win!"
            self.addChild(winReturnButton)
            self.addChild(levSelButton)
        }
            
        if type == "lose"{
            label.text = "You lost!"
            self.addChild(loseReturnButton)
            self.addChild(retryButton)
        }
            
        if type == "item"{
            label.text = "Got Item"
            self.addChild(itemName)
        }
            
        if type == "options"{
            label.text = "Options"
            self.addChild(sfxVol)
            self.addChild(musicVol)
            self.addChild(tiltResetButton)
            self.addChild(vibrateButton)
        }
        
        if type == "charsel"{
            label.text = "Character Select"
            for button in [char1button, char2button, char3button, startButton] {
                self.addChild(button)
            }
        }
}
    
    func visible() {
        if let worldNode = gameScene.childNode(withName: "worldNode") {
            worldNode.isPaused = true
        }
        for node in [popupNodeButton, label, itemName] as [SKNode] {
            node.isHidden = false
        }
        for child in self.children {
            child.isHidden = false
        }
    }
    func invisible() {
        if let worldNode = gameScene.childNode(withName: "worldNode") {
            worldNode.isPaused = false
        }
        for node in [popupNodeButton, label, itemName] as [SKNode] {
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
