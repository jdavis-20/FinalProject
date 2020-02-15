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
            
        default:
            print("no valid popup type provided")
        }
}
    
    func visible() {
        popupNode.isHidden = false
        label.isHidden = false
        itemName.isHidden = false
        
        worldNode.isPaused = true
    }
    
    func invisible() {
        popupNode.isHidden = true
        label.isHidden = true
        itemName.isHidden = true

        worldNode.isPaused = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
