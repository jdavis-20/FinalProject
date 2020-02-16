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
        
        super.init()
        
        self.addChild(popupNode)
        self.addChild(label)
        
        switch type {
        case "win":
            label.text = "win"
            
        case "lose":
            label.text = "lose"
            
        case "item":
            label.text = "item"
            self.addChild(itemName)
            
        case "options":
            label.text = "options"
        
        case "charsel":
            label.text = "character select"
            
        default:
            print("no valid popup type provided")
        }
        
        isUserInteractionEnabled = true
}
    
    func visible() {
        popupNode.isHidden = false
        label.isHidden = false
        itemName.isHidden = false
        worldNode.isPaused = true
        
        self.childNode(withName: "button")?.isHidden = false
    }
    
    func invisible() {
        popupNode.isHidden = true
        label.isHidden = true
        itemName.isHidden = true
        worldNode.isPaused = false
        
        if let child = self.childNode(withName: "button") {
            child.removeFromParent()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
