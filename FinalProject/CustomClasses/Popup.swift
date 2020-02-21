//
//  Popup.swift
//  FinalProject
//
//  Created by Julian Davis on 2/11/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import SpriteKit

class Popup: SKNode {
    
    let popupNode: SKSpriteNode
    var label = SKLabelNode()
    var itemName = SKLabelNode()
    var character: String
    var char1button: Button
    var char2button: Button
    var char3button: Button

    func char1() {
        character = "char1"
        print("POPUP: selected character 1")
    }
    func char2() {
        character = "char2"
        print("POPUP: selected character 2")
    }
    func char3() {
        character = "char3"
        print("POPUP: selected character 3")
    }
    
    init(image: String, type: String, worldNode: SKNode) {
        
        popupNode = SKSpriteNode(imageNamed: "popup")
        popupNode.isHidden = true
        label.isHidden = true
        popupNode.zPosition = 2
        label.zPosition = 3
        label.position = CGPoint(x: 0, y: popupNode.frame.size.height/3)
        itemName.zPosition = 3
        popupNode.position = CGPoint(x: 0, y: 0)
        popupNode.alpha = 0.8
        
        character = ""

        char1button = Button(defaultButtonImage: "button",
                             activeButtonImage: "button_active",
                             label: "Char1")
        char1button.position = CGPoint(x: -popupNode.frame.size.width/3, y: 0)
        char1button.zPosition = 3
        char2button = Button(defaultButtonImage: "button",
                             activeButtonImage: "button_active",
                             label: "Char2")
        char2button.position = CGPoint(x: 0, y: 0)
        char2button.zPosition = 3
        char3button = Button(defaultButtonImage: "button",
                             activeButtonImage: "button_active",
                             label: "Char3")
        char3button.position = CGPoint(x: popupNode.frame.size.width/3, y: 0)
        char3button.zPosition = 3
        
        super.init()

        char1button.action = char1
        char2button.action = char2
        char3button.action = char3
        
        self.addChild(popupNode)
        self.addChild(label)
        
        if type == "win" {
            label.text = "win"
        }
            
        if type == "lose"{
            label.text = "lose"
        }
            
        if type == "item"{
            label.text = "got item"
            self.addChild(itemName)
        }
            
        if type == "options"{
            label.text = "options"
        }
        
        if type == "charsel"{
            label.text = "character select"
            self.addChild(char1button)
            self.addChild(char2button)
            self.addChild(char3button)
        }
        
        isUserInteractionEnabled = true
}
    
    func visible() {
        popupNode.isHidden = false
        label.isHidden = false
        itemName.isHidden = false
        worldNode.isPaused = true
        
        for child in self.children {
            child.isHidden = false
        }
    }
    
    func invisible() {
        popupNode.isHidden = true
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
