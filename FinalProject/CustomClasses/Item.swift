//
//  Item.swift
//  FinalProject
//
//  Created by Julian Davis on 1/29/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import SpriteKit

class Item: SKNode {
    
    let itemSprite: SKSpriteNode
    
    init(image: String, position: CGPoint) {
        itemSprite = SKSpriteNode(imageNamed: image)
        
        super.init()
        
        self.name = "item" // will have to make unique to items
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: itemSprite.size.width,
                                                                   height: itemSprite.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.contactTestBitMask = 0x00000001
        self.position = position
        
        
        self.addChild(itemSprite)
    }
    
    // could instead add an itemInit method to be called from the sks, like the mazeWalls?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
