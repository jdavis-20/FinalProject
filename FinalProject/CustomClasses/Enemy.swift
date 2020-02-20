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
//    let path = UIBezierPath()
    
//    func movement() {
//        let followPath:SKAction = SKAction.follow(path.cgPath,
//                                                  asOffset: true,
//                                                  orientToPath: false,
//                                                  speed: 200)
//        self.run(followPath)
//    }
    
    init(image: String, player: SKSpriteNode, scene: SKScene) {
        enemyNode = SKSpriteNode(imageNamed: image)
        
//        path.move(to: CGPoint(x: -50, y: 0))
//        path.addLine(to: CGPoint(x: 50, y: 0))
//        path.addLine(to: CGPoint(x: -50, y: 0))
        
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
    
    func pathfinding() {
        var enemyRayPlayer = scene?.physicsWorld.body(alongRayStart: enemy!.position, end: player.position)
        
        var enemyRayUp = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                    end: CGPoint(x: enemy!.position.x,
                                                                 y: enemy!.position.y + 50))
        
        var enemyRayDown = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                       end: CGPoint(x: enemy!.position.x,
                                                                    y: enemy!.position.y - 50))
        
        var enemyRayLeft = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                       end: CGPoint(x: enemy!.position.x - 50,
                                                                    y: enemy!.position.y))
        
        var enemyRayRight = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                        end: CGPoint(x: enemy!.position.x + 50,
                                                                     y: enemy!.position.y))
        
        // enemy detects if player is in sight using raycasting
        // if it is then enemy follows player 
        if enemyRayPlayer?.node == player {
            print("raycast successful")
            if (enemy!.position.x - player.position.x) > 5 {
                print("enemy go left")
                enemy!.physicsBody?.velocity.dx = CGFloat(-100)
            }
            if (player.position.x - enemy!.position.x) > 5 {
                enemy!.physicsBody?.velocity.dx = CGFloat(100)
                print("enemy go right")
            }
            if ((enemy!.position.x - player.position.x) < 5) && ((player.position.x - enemy!.position.x) < 5) {
                enemy!.physicsBody?.velocity.dx = CGFloat(0)
            }
            
            if (enemy!.position.y - player.position.y) > 5 {
                enemy!.physicsBody?.velocity.dy = CGFloat(-100)
                print("enemy go down")
            }
            if (player.position.y - enemy!.position.y) > 5 {
                enemy!.physicsBody?.velocity.dy = CGFloat(100)
                print("enemy go up")
            }
            if ((enemy!.position.y - player.position.y) < 5) && ((player.position.y - enemy!.position.y) < 5) {
                enemy!.physicsBody?.velocity.dy = CGFloat(0)
            }
        }
        else {
            enemy!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
