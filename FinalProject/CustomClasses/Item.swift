//
//  Item.swift
//  FinalProject
//
//  Created by Julian Davis on 1/29/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

class Item: SKNode {
    
    let itemSprite: SKSpriteNode
    
    init(image: String, position: CGPoint) {
        itemSprite = SKSpriteNode(imageNamed: image)
        itemSprite.name = "item" // will have to make unique to items
        
        itemSprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: itemSprite.size.width,
                                                                   height: itemSprite.size.height))
        itemSprite.physicsBody?.affectedByGravity = false
        itemSprite.physicsBody?.allowsRotation = false
        itemSprite.physicsBody?.isDynamic = false
        itemSprite.physicsBody?.contactTestBitMask = 0x00000001
        itemSprite.position = position
        
        super.init()
        
        self.addChild(itemSprite)
    }
    
    // could instead add an itemInit method to be called from the sks, like the mazeWalls?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
