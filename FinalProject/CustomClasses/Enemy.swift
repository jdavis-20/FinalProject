//
//  Enemy.swift
//  FinalProject
//
//  Created by Julian Davis on 11/7/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

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
    
    init(image: String) {
        enemyNode = SKSpriteNode(imageNamed: image)
        
        path.move(to: CGPoint(x: -50, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 0))
        path.addLine(to: CGPoint(x: -50, y: 0))
        
        super.init()
        
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemyNode.size.width,
                                                             height: enemyNode.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = 0x00000001
        
        self.addChild(enemyNode)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
