//
//  player.swift
//  FinalProject
//
//  Created by Julian Davis on 10/13/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {
    
    // this doesn't work and isn't currently being implemented
    
    init(texturename: String){
        let texture = SKTexture(imageNamed: texturename)
        super.init(texture: texture, color: .clear, size: texture.size())
        //print("\(frame.size.width), \(frame.size.height)")
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 0.8 //impacts feel of the motion
        self.physicsBody?.allowsRotation = false
        
        addChild(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
