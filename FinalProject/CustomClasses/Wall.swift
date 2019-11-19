//
//  Wall.swift
//  FinalProject
//
//  Created by Julian Davis on 10/12/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

//import UIKit
import SpriteKit

class Wall: SKNode {
    
    let wallRect: SKShapeNode
    
    init(height: Double, width: Double, color: SKColor, position: CGPoint) {
        wallRect = SKShapeNode(rectOf: CGSize(width: width, height: height))
        wallRect.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        wallRect.name = "wall" //change to individual names later?
        
        wallRect.fillColor = color
        wallRect.strokeColor = color
        
        wallRect.physicsBody?.isDynamic = false
        wallRect.physicsBody?.restitution = 1
        wallRect.physicsBody?.categoryBitMask = 0x00000001
        
        wallRect.position = position
        
        super.init()
        
        self.addChild(wallRect)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
