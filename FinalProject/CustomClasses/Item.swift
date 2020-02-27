//
//  Item.swift
//  FinalProject
//
//  Created by Julian Davis on 1/29/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import SpriteKit

class Item: SKSpriteNode {
    
    func itemInit() {
        self.name = "item" // will have to make unique to items
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width,
                                                            height: self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.contactTestBitMask = 0x00000001
    }
}
