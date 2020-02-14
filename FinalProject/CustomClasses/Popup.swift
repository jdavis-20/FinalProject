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
    
    init(image: String, type: String, worldNode: SKNode) {
        
        popupNode = SKSpriteNode(imageNamed: "popup")
        popupNode.isHidden = true
        label.isHidden = true
        popupNode.zPosition = 2
        label.zPosition = 3
        popupNode.position = CGPoint(x: 0, y: 0)
        
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
        case "options":
            label.text = "options"
        default:
            print("no valid popup type provided")
        }
}
    
    func visible() {
        popupNode.isHidden = false
        label.isHidden = false
    }
    
    func invisible() {
        popupNode.isHidden = true
        label.isHidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
