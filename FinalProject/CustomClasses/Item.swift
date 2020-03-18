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
        self.name = "item" // might have to make unique to items
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width,
                                                            height: self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.contactTestBitMask = 0x00000001
        self.physicsBody?.categoryBitMask = 0x00000000 // set to 0 so there's no collision physics even as the collision is detected
    }
    func attract(character: String, ability: Bool, playerNode: SKSpriteNode) {
        if character == "Arch" && ability == true {
            if (abs(playerNode.position.x-self.position.x) < 150) &&
                (abs(playerNode.position.y-self.position.y) < 150) {
                print("ITEM: attract distance detected")
                self.run(SKAction.move(to: playerNode.position, duration: 0.2))
            }
        }
        // TODO: testing effect of attract from close distance for all characters
        else {
            if (abs(playerNode.position.x-self.position.x) < 70) &&
                (abs(playerNode.position.y-self.position.y) < 70) {
//                print("ITEM: close distance detected")
                self.run(SKAction.move(to: playerNode.position, duration: 0.2))
            }
        }
    }
}

