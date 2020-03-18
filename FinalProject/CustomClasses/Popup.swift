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
    
    var char1button: Button
    var char2button: Button
    var char3button: Button
    var loseReturnButton: Button
    var winReturnButton: Button
    var startButton: Button
    
    var sfxVol = VolumeControl(label: "SFX")
    var musicVol = VolumeControl(label: "Music")

    func char1() {
        character = "Med"
        print("POPUP: select 1, Medical, effect enemy slowdown")
        // effects are located in Enemy.swift pathfinding method
        if char2button.activeButton.isHidden == false {
            char2button.toggle()
        }
        if char3button.activeButton.isHidden == false {
            char3button.toggle()
        }
    }
    func char2() {
        character = "Bot"
        print("POPUP: select 2, Botanical, effect player camo")
        // effects are located in Enemy.swift pathfinding method, opacity effect in GameScene.swift update method
        if char1button.activeButton.isHidden == false {
            char1button.toggle()
        }
        if char3button.activeButton.isHidden == false {
            char3button.toggle()
        }
    }
    func char3() {
        character = "Arch"
        print("POPUP: select 3, Archaeological, effect item attract")
        // effects are located in Item.swift attract method
        if char1button.activeButton.isHidden == false {
            char1button.toggle()
        }
        if char2button.activeButton.isHidden == false {
            char2button.toggle()
        }
    }
    func resetChar() {
        character = ""
        print("POPUP: character deselected")
    }
    
    init(image: String, type: String, worldNode: SKNode) {
        
        popupNode = SKSpriteNode(imageNamed: image)
        popupNode.isHidden = true
        label.isHidden = true
        popupNode.zPosition = 2
        label.zPosition = 3
        label.position = CGPoint(x: 0, y: popupNode.frame.size.height/4)
        itemName.zPosition = 3
        popupNode.position = CGPoint(x: 0, y: 0)
        popupNode.alpha = 0.8
        
        sfxVol.position = CGPoint(x: 0, y: 30)
        sfxVol.zPosition = 3
        musicVol.position = CGPoint(x: 0, y: -30)
        musicVol.zPosition = 3

        
        character = ""

        char1button = Button(defaultButtonImage: "button",
                             activeButtonImage: "buttonflat",
                             label: "ch1",
                             toggle: true)
        char1button.position = CGPoint(x: -popupNode.frame.size.width/4, y: 0)
        char1button.zPosition = 3
        char2button = Button(defaultButtonImage: "button",
                             activeButtonImage: "buttonflat",
                             label: "ch2",
                             toggle: true)
        char2button.position = CGPoint(x: 0, y: 0)
        char2button.zPosition = 3
        char3button = Button(defaultButtonImage: "button",
                             activeButtonImage: "buttonflat",
                             label: "ch3",
                             toggle: true)
        char3button.position = CGPoint(x: popupNode.frame.size.width/4, y: 0)
        char3button.zPosition = 3
        
        loseReturnButton = Button(defaultButtonImage: "menu",
                                      activeButtonImage: "menuflat",
                                      toggle: false)
        loseReturnButton.position = CGPoint(x: 0, y: 40)
        loseReturnButton.zPosition = 3
        
        winReturnButton = Button(defaultButtonImage: "menu",
                                     activeButtonImage: "menuflat",
                                     toggle: false)
        winReturnButton.position = CGPoint(x: 0, y: 40)
        winReturnButton.zPosition = 3
        
        startButton = Button(defaultButtonImage: "start",
                                 activeButtonImage: "startflat",
                                 toggle: false)
        startButton.position = CGPoint(x: 0,
                                       y: -80)
        startButton.zPosition = 3
        
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
        }
        
        if type == "charsel"{
            label.text = "character select"
            self.addChild(char1button)
            self.addChild(char2button)
            self.addChild(char3button)
            self.addChild(startButton)
        }
        
        isUserInteractionEnabled = true
}
    
    func visible() {
        popupNode.isHidden = false
        popupNode.isUserInteractionEnabled = true
        label.isHidden = false
        itemName.isHidden = false
        worldNode.isPaused = true
        
        for child in self.children {
            child.isHidden = false
        }
    }
    func invisible() {
        popupNode.isHidden = true
        popupNode.isUserInteractionEnabled = false
        label.isHidden = true
        itemName.isHidden = true
        worldNode.isPaused = false
        
        for child in self.children {
            child.isHidden = true
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
