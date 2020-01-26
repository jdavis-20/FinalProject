//
//  Enemy.swift
//  FinalProject
//
//  Created by Julian Davis on 11/7/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKNode {
    
    let enemyNode: SKSpriteNode
    let path = UIBezierPath()
    
    func movement() {
        let followPath:SKAction = SKAction.follow(path.cgPath,
                                                  asOffset: true,
                                                  orientToPath: false,
                                                  speed: 200)
        self.run(followPath)
    }
    
    init(image: String, position: CGPoint) {
        enemyNode = SKSpriteNode(imageNamed: image)
        enemyNode.name = "enemy"
        enemyNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyNode.size.width,
                                                                  height: enemyNode.size.height))
        enemyNode.physicsBody?.affectedByGravity = false
        enemyNode.physicsBody?.allowsRotation = false
        enemyNode.physicsBody?.isDynamic = false
        enemyNode.physicsBody?.contactTestBitMask = 0x00000001
        enemyNode.position = position
        
        path.move(to: CGPoint(x: -50, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: -50, y: 0))
        
        super.init()
        
        self.addChild(enemyNode)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
