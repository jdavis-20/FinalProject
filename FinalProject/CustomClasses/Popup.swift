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
    
    init(image: String, type: String, worldNode: SKNode) {
        
        popupNode = SKSpriteNode(imageNamed: image)
        popupNode.isHidden = true
        
        
        super.init()
    }
    
    func visible() {
        popupNode.isHidden = false
        worldNode.isPaused = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
