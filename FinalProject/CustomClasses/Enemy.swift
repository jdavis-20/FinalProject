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
    let number2 = Int(arc4random_uniform(2))
    let number3 = Int(arc4random_uniform(3))
    let number4 = Int(arc4random_uniform(4))


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
    
    func left() {
        enemy!.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
    }
    func right() {
        enemy!.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
    }
    func up() {
        enemy!.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
    }
    func down() {
        enemy!.physicsBody?.velocity = CGVector(dx: 0, dy: -100)
    }
    
    func pathfinding() {
        var enemyRayPlayer = scene?.physicsWorld.body(alongRayStart: enemy!.position, end: player.position)
        
        var enemyRayUp = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                    end: CGPoint(x: enemy!.position.x,
                                                                 y: enemy!.position.y + 80))
        
        var enemyRayDown = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                       end: CGPoint(x: enemy!.position.x,
                                                                    y: enemy!.position.y - 80))
        
        var enemyRayLeft = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                       end: CGPoint(x: enemy!.position.x - 80,
                                                                    y: enemy!.position.y))
        
        var enemyRayRight = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                        end: CGPoint(x: enemy!.position.x + 80,
                                                                     y: enemy!.position.y))
        
//        let rightline = SKShapeNode()
//        let rightPath = CGMutablePath()
//        rightPath.move(to: CGPoint(x:0, y:0))
//        rightPath.addLine(to: CGPoint(x: 100,
//                                       y: 0))
//        rightline.path = rightPath
//        rightline.strokeColor = SKColor.red
//        addChild(rightline)
//
//        let leftline = SKShapeNode()
//        let leftPath = CGMutablePath()
//        leftPath.move(to: CGPoint(x:0, y:0))
//        leftPath.addLine(to: CGPoint(x: -100,
//                                       y: 0))
//        leftline.path = leftPath
//        leftline.strokeColor = SKColor.red
//        addChild(leftline)
//
//        let upline = SKShapeNode()
//        let upPath = CGMutablePath()
//        upPath.move(to: CGPoint(x:0, y:0))
//        upPath.addLine(to: CGPoint(x: 0,
//                                       y: 100))
//        upline.path = upPath
//        upline.strokeColor = SKColor.red
//        addChild(upline)
//
//        let downline = SKShapeNode()
//        let downPath = CGMutablePath()
//        downPath.move(to: CGPoint(x:0, y:0))
//        downPath.addLine(to: CGPoint(x: 0,
//                                       y: -100))
//        downline.path = downPath
//        downline.strokeColor = SKColor.red
//        addChild(downline)
        
        // enemy detects if player is in sight using raycasting
        // if it is then enemy follows player 
        if enemyRayPlayer?.node == player {
            print("ENEMY: raycast detected player")
            if (enemy!.position.x - player.position.x) > 5 {
                print("ENEMY: go left")
                enemy!.physicsBody?.velocity.dx = CGFloat(-100)
            }
            if (player.position.x - enemy!.position.x) > 5 {
                enemy!.physicsBody?.velocity.dx = CGFloat(100)
                print("ENEMY: go right")
            }
            if ((enemy!.position.x - player.position.x) < 5) && ((player.position.x - enemy!.position.x) < 5) {
                enemy!.physicsBody?.velocity.dx = CGFloat(0)
            }
            
            if (enemy!.position.y - player.position.y) > 5 {
                enemy!.physicsBody?.velocity.dy = CGFloat(-100)
                print("ENEMY: go down")
            }
            if (player.position.y - enemy!.position.y) > 5 {
                enemy!.physicsBody?.velocity.dy = CGFloat(100)
                print("ENEMY: go up")
            }
            if ((enemy!.position.y - player.position.y) < 5) && ((player.position.y - enemy!.position.y) < 5) {
                enemy!.physicsBody?.velocity.dy = CGFloat(0)
            }
        }
            // TODO: behavior patterns for when player is out of sight will go here
        else {
//            enemy!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            // if wall is within 100 units in this direction
//            if enemyRayUp?.node?.name == "MazeWall" {
//                print("ENEMY: wall above")
//            }
//            if enemyRayDown?.node?.name == "MazeWall" {
//                print("ENEMY: wall below")
//            }
//            if enemyRayLeft?.node?.name == "MazeWall" {
//                print("ENEMY: wall left")
//            }
//            if enemyRayRight?.node?.name == "MazeWall" {
//                print("ENEMY: wall right")
//            }
            
            
            // if walls in 0 directions pick random
            if (enemyRayUp?.node?.name != "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if number4 == 0 {
                    print("ENEMY: 4 random down")
                    down()
                }
                if number4 == 1 {
                    print("ENEMY: 4 random up")
                    up()
                }
                if number4 == 2 {
                    print("ENEMY: 4 random right")
                    right()
                }
                if number4 == 3 {
                    print("ENEMY: 4 random left")
                    left()
                }
            }
            
            // if wall in 1 direction pick random from other 3
            if (enemyRayUp?.node?.name == "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if number3 == 0 {
                    print("ENEMY: 3 random right")
                    right()
                }
                if number3 == 1 {
                    print("ENEMY: 3 random left")
                    left()
                }
                if number3 == 2 {
                    print("ENEMY: 3 random down")
                    down()
                }
            }
            if (enemyRayDown?.node?.name == "MazeWall") && (enemyRayUp?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if number3 == 0 {
                    print("ENEMY: 3 random right")
                    right()
                }
                if number3 == 1 {
                    print("ENEMY: 3 random left")
                    left()
                }
                if number3 == 2 {
                    print("ENEMY: 3 random up")
                    up()
                }
            }
            if (enemyRayLeft?.node?.name == "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayUp?.node?.name != "MazeWall") {
                if number3 == 0 {
                    print("ENEMY: 3 random right")
                    right()
                }
                if number3 == 1 {
                    print("ENEMY: 3 random down")
                    down()
                }
                if number3 == 2 {
                    print("ENEMY: 3 random up")
                    up()
                }
            }
            if (enemyRayRight?.node?.name == "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayUp?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if number3 == 0 {
                    print("ENEMY: 3 random left")
                    left()
                }
                if number3 == 1 {
                    print("ENEMY: 3 random down")
                    down()
                }
                if number3 == 2 {
                    print("ENEMY: 3 random up")
                    up()
                }
            }
            
            // if above&below go left/right
            if (enemyRayUp?.node?.name == "MazeWall") && (enemyRayDown?.node?.name == "MazeWall") {
                // if wall left go right
                if (enemyRayLeft?.node?.name == "MazeWall") {
                    print("ENEMY: undisputed right")
                    right()
                }
                // if wall right go left
                if (enemyRayRight?.node?.name == "MazeWall") {
                    print("ENEMY: undisputed left")
                    left()
                }
                //if neither pick random
                if (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                    if number2 == 0 {
                        print("ENEMY: 2 random right")
                        right()
                    }
                    if number2 == 1 {
                        print("ENEMY: 2 random left")
                        left()
                    }
                }
            }
            
            // if left&right go up/down
            if (enemyRayLeft?.node?.name == "MazeWall") && (enemyRayRight?.node?.name == "MazeWall") {
                // if wall up go down
                if (enemyRayUp?.node?.name == "MazeWall") {
                    down()
                    print("ENEMY: undisputed down")
                }
                // if wall down go up
                if (enemyRayDown?.node?.name == "MazeWall") {
                    print("ENEMY: undisputed up")
                    up()
                }
                //if neither pick random
                if (enemyRayUp?.node?.name != "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") {
                    if number2 == 0 {
                        print("ENEMY: 2 random down")
                        down()
                    }
                    if number2 == 1 {
                        print("ENEMY: 2 random up")
                        up()
                    }
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
