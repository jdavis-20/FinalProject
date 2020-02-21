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
    let range: CGFloat = 100
    var direction = "none"


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
        direction = "left"
    }
    func right() {
        enemy!.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
        direction = "right"
    }
    func up() {
        enemy!.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
        direction = "up"
    }
    func down() {
        enemy!.physicsBody?.velocity = CGVector(dx: 0, dy: -100)
        direction = "down"
    }
    
    func pathfinding() {
        var enemyRayPlayer = scene?.physicsWorld.body(alongRayStart: enemy!.position, end: player.position)
        
        var enemyRayUp = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                    end: CGPoint(x: enemy!.position.x,
                                                                 y: enemy!.position.y + range))
        
        var enemyRayDown = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                       end: CGPoint(x: enemy!.position.x,
                                                                    y: enemy!.position.y - range))
        
        var enemyRayLeft = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                       end: CGPoint(x: enemy!.position.x - range,
                                                                    y: enemy!.position.y))
        
        var enemyRayRight = scene?.physicsWorld.body(alongRayStart: enemy!.position,
                                                        end: CGPoint(x: enemy!.position.x + range,
                                                                     y: enemy!.position.y))
        
        let rightline = SKShapeNode()
        let rightPath = CGMutablePath()
        rightPath.move(to: CGPoint(x:0, y:0))
        rightPath.addLine(to: CGPoint(x: 100,
                                       y: 0))
        rightline.path = rightPath
        rightline.strokeColor = SKColor.red
        addChild(rightline)

        let leftline = SKShapeNode()
        let leftPath = CGMutablePath()
        leftPath.move(to: CGPoint(x:0, y:0))
        leftPath.addLine(to: CGPoint(x: -100,
                                       y: 0))
        leftline.path = leftPath
        leftline.strokeColor = SKColor.red
        addChild(leftline)

        let upline = SKShapeNode()
        let upPath = CGMutablePath()
        upPath.move(to: CGPoint(x:0, y:0))
        upPath.addLine(to: CGPoint(x: 0,
                                       y: 100))
        upline.path = upPath
        upline.strokeColor = SKColor.red
        addChild(upline)

        let downline = SKShapeNode()
        let downPath = CGMutablePath()
        downPath.move(to: CGPoint(x:0, y:0))
        downPath.addLine(to: CGPoint(x: 0,
                                       y: -100))
        downline.path = downPath
        downline.strokeColor = SKColor.red
        addChild(downline)
        
        // enemy detects if player is in sight using raycasting
        // if it is then enemy follows player 
        if enemyRayPlayer?.node == player {
            print("ENEMY: raycast detected player")
            if (enemy!.position.x - player.position.x) > 5 {
                print("ENEMY: follow left")
                enemy!.physicsBody?.velocity.dx = CGFloat(-100)
            }
            if (player.position.x - enemy!.position.x) > 5 {
                enemy!.physicsBody?.velocity.dx = CGFloat(100)
                print("ENEMY: follow right")
            }
            if ((enemy!.position.x - player.position.x) < 5) && ((player.position.x - enemy!.position.x) < 5) {
                enemy!.physicsBody?.velocity.dx = CGFloat(0)
            }
            
            if (enemy!.position.y - player.position.y) > 5 {
                enemy!.physicsBody?.velocity.dy = CGFloat(-100)
                print("ENEMY: follow down")
            }
            if (player.position.y - enemy!.position.y) > 5 {
                enemy!.physicsBody?.velocity.dy = CGFloat(100)
                print("ENEMY: follow up")
            }
            if ((enemy!.position.y - player.position.y) < 5) && ((player.position.y - enemy!.position.y) < 5) {
                enemy!.physicsBody?.velocity.dy = CGFloat(0)
            }
        }
            
        // TODO: behavior patterns for when player is out of sight will go here
        else {
            
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
            // A4
            if (enemyRayUp?.node?.name != "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if direction == "none" {
                    if number4 == 0 {
                        print("ENEMY: A4 random down")
                        down()
                    }
                    if number4 == 1 {
                        print("ENEMY: A4 random up")
                        up()
                    }
                    if number4 == 2 {
                        print("ENEMY: A4 random right")
                        right()
                    }
                    if number4 == 3 {
                        print("ENEMY: A4 random left")
                        left()
                    }
                }
                if direction == "up" {
                    print("ENEMY: A4 continue up")
                    up()
                }
                if direction == "down" {
                    print("ENEMY: A4 continue down")
                    down()
                }
                if direction == "left" {
                    print("ENEMY: A4 continue left")
                    left()
                }
                if direction == "right" {
                    print("ENEMY: A4 continue right")
                    right()
                }
            }
            
            // if wall in 1 direction pick random from other 3
            //A3
            if (enemyRayUp?.node?.name == "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if (direction == "up" || direction == "none") {
                    if number3 == 0 {
                        print("ENEMY: A3 random right")
                        right()
                    }
                    if number3 == 1 {
                        print("ENEMY: A3 random left")
                        left()
                    }
                    if number3 == 2 {
                        print("ENEMY: A3 random down")
                        down()
                    }
                }
            }
            // B3
            if (enemyRayDown?.node?.name == "MazeWall") && (enemyRayUp?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if (direction == "down" || direction == "none") {
                    if number3 == 0 {
                        print("ENEMY: B3 random right")
                        right()
                    }
                    if number3 == 1 {
                        print("ENEMY: B3 random left")
                        left()
                    }
                    if number3 == 2 {
                        print("ENEMY: B3 random up")
                        up()
                    }
                }
            }
            // C3
            if (enemyRayLeft?.node?.name == "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayRight?.node?.name != "MazeWall") && (enemyRayUp?.node?.name != "MazeWall") {
                if (direction == "left" || direction == "none") {
                    if number3 == 0 {
                        print("ENEMY: C3 random right")
                        right()
                    }
                    if number3 == 1 {
                        print("ENEMY: C3 random down")
                        down()
                    }
                    if number3 == 2 {
                        print("ENEMY: C3 random up")
                        up()
                    }
                }
            }
            // D3
            if (enemyRayRight?.node?.name == "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") &&
                (enemyRayUp?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                if (direction == "right"  || direction == "none") {
                    if number3 == 0 {
                        print("ENEMY: D3 random left")
                        left()
                    }
                    if number3 == 1 {
                        print("ENEMY: D3 random down")
                        down()
                    }
                    if number3 == 2 {
                        print("ENEMY: D3 random up")
                        up()
                    }
                }
            }
            
            // if above&below go left/right
            if (enemyRayUp?.node?.name == "MazeWall") && (enemyRayDown?.node?.name == "MazeWall") {
                if (direction == "up" || direction == "down" || direction == "none") {
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
                    // if neither pick random
                    // A2
                    if (enemyRayRight?.node?.name != "MazeWall") && (enemyRayLeft?.node?.name != "MazeWall") {
                        if number2 == 0 {
                            print("ENEMY: A2 random right")
                            right()
                        }
                        if number2 == 1 {
                            print("ENEMY: A2 random left")
                            left()
                        }
                    }
                }
            }
            
            // if left&right go up/down
            if (enemyRayLeft?.node?.name == "MazeWall") && (enemyRayRight?.node?.name == "MazeWall") {
                if (direction == "left" || direction == "right" || direction == "none") {
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
                    // B2
                    if (enemyRayUp?.node?.name != "MazeWall") && (enemyRayDown?.node?.name != "MazeWall") {
                        if number2 == 0 {
                            print("ENEMY: B2 random down")
                            down()
                        }
                        if number2 == 1 {
                            print("ENEMY: B2 random up")
                            up()
                        }
                    }
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
