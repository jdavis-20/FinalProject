//
//  Enemy.swift
//  FinalProject
//
//  Created by Julian Davis on 11/7/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    let range: CGFloat = 110
    var timer = Timer()
    let delay = 0.8
    var number2 = Int(arc4random_uniform(2))
    var number3 = Int(arc4random_uniform(3))
    var number4 = Int(arc4random_uniform(4))
    var direction = "none"
    var idleSpeed = 100
    let rebound = 150
    var state = "none"
    // state options are
    //      open - no walls,
    //      wall - 1 wall,
    //      corridor - 2 walls parallel,
    //      corner - 2 walls perpendicular,
    //      box - 3 walls
    //      follow - following player
    
    func enemyInit() {
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width,
                                                             height: self.frame.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = 0x00000001
        self.physicsBody?.restitution = 1
        }
    
    func pathfinding(playerNode: SKSpriteNode, currentScene: SKScene) {
        
        let absXDiff = abs(playerNode.position.x-self.position.x)
        let absYDiff = abs(playerNode.position.y-self.position.y)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.number2 = Int(arc4random_uniform(2))
            self.number3 = Int(arc4random_uniform(3))
            self.number4 = Int(arc4random_uniform(4))
//            print("ENEMY: var changed: \(self.number2), \(self.number3), \(self.number4)")
        }
        
        func left() {
            self.physicsBody?.velocity = CGVector(dx: -idleSpeed, dy: 0)
            direction = "left"
        }
        func right() {
            self.physicsBody?.velocity = CGVector(dx: idleSpeed, dy: 0)
            direction = "right"
        }
        func up() {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: idleSpeed)
            direction = "up"
        }
        func down() {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: -idleSpeed)
            direction = "down"
        }
        func contDir() {
            print("ENEMY: continue \(direction)")
            if direction == "down" {
                down()
            }
            if direction == "up" {
                up()
            }
            if direction == "left" {
                left()
            }
            if direction == "right" {
                right()
            }
        }
        
        let enemyRayPlayer = currentScene.physicsWorld.body(alongRayStart: self.position, end: playerNode.position)
        
        let enemyRayUp = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                        end: CGPoint(x: self.position.x,
                                                                     y: self.position.y + range))
        
        let enemyRayDown = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                          end: CGPoint(x: self.position.x,
                                                                       y: self.position.y - range))
        
        let enemyRayLeft = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                          end: CGPoint(x: self.position.x - range,
                                                                       y: self.position.y))
        
        let enemyRayRight = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                           end: CGPoint(x: self.position.x + range,
                                                                        y: self.position.y))
        
        let nodeAbove = enemyRayUp?.node
        let nodeBelow = enemyRayDown?.node
        let nodeLeft = enemyRayLeft?.node
        let nodeRight = enemyRayRight?.node
        
//        let rightline = SKShapeNode()
//        let rightPath = CGMutablePath()
//        rightPath.move(to: CGPoint(x:-100, y:0))
//        rightPath.addLine(to: CGPoint(x: 100,
//                                       y: 0))
//        rightline.path = rightPath
//        rightline.strokeColor = SKColor.red
//        addChild(rightline)
//
//        let upline = SKShapeNode()
//        let upPath = CGMutablePath()
//        upPath.move(to: CGPoint(x:0, y:-100))
//        upPath.addLine(to: CGPoint(x: 0,
//                                       y: 100))
//        upline.path = upPath
//        upline.strokeColor = SKColor.red
//        addChild(upline)

        
        
        //TODO: implement distance limit on sighting? if so, can do with -if playerposition-enemyposition > distance-
        
        // enemy detects if player is in sight using raycasting
        // if it is then enemy follows player 
        if enemyRayPlayer?.node == playerNode {
            print("ENEMY: raycast detected player")
            state = "follow"
            
            // this section causes enemy movemnt to be only straight or diagonal
            // if the difference in x is greater than the difference in y, move along x axis only
            if (absXDiff - absYDiff) > 3 {
                self.physicsBody?.velocity.dy = CGFloat(0)
                if (self.position.x - playerNode.position.x) > 3 {
                    print("ENEMY: follow left")
                    self.physicsBody?.velocity.dx = CGFloat(-80)
                }
                if (playerNode.position.x - self.position.x) > 3 {
                    self.physicsBody?.velocity.dx = CGFloat(80)
                    print("ENEMY: follow right")
                }
                if ((self.position.x - playerNode.position.x) < 3) && ((playerNode.position.x - self.position.x) < 3) {
                    self.physicsBody?.velocity.dx = CGFloat(0)
                }
            }
            // if the difference in y is greater than the difference in x, move along y axis only
            if (absYDiff - absXDiff) > 3 {
                self.physicsBody?.velocity.dx = CGFloat(0)
                if (self.position.y - playerNode.position.y) > 3 {
                    self.physicsBody?.velocity.dy = CGFloat(-80)
                    print("ENEMY: follow down")
                }
                if (playerNode.position.y - self.position.y) > 3 {
                    self.physicsBody?.velocity.dy = CGFloat(80)
                    print("ENEMY: follow up")
                }
                if ((self.position.y - playerNode.position.y) < 3) && ((playerNode.position.y - self.position.y) < 3) {
                    self.physicsBody?.velocity.dy = CGFloat(0)
                }
            }
            // if the difference in x and y positions is close, move along both axes
            if abs(absYDiff - absXDiff) < 3 {
                if (self.position.x - playerNode.position.x) > 3 {
                    print("ENEMY: follow left")
                    self.physicsBody?.velocity.dx = CGFloat(-80)
                }
                if (playerNode.position.x - self.position.x) > 3 {
                    self.physicsBody?.velocity.dx = CGFloat(80)
                    print("ENEMY: follow right")
                }
                if ((self.position.x - playerNode.position.x) < 3) && ((playerNode.position.x - self.position.x) < 3) {
                    self.physicsBody?.velocity.dx = CGFloat(0)
                }
                if (self.position.y - playerNode.position.y) > 3 {
                    self.physicsBody?.velocity.dy = CGFloat(-80)
                    print("ENEMY: follow down")
                }
                if (playerNode.position.y - self.position.y) > 3 {
                    self.physicsBody?.velocity.dy = CGFloat(80)
                    print("ENEMY: follow up")
                }
                if ((self.position.y - playerNode.position.y) < 3) && ((playerNode.position.y - self.position.y) < 3) {
                    self.physicsBody?.velocity.dy = CGFloat(0)
                }
            }
        }
            
        // TODO: behavior patterns for when player is out of sight will go here
        else {
//            if nodeAbove is MazeWall {
//                //print("ENEMY: wall above")
//            }
//            if nodeBelow is MazeWall {
//                //print("ENEMY: wall below")
//            }
//            if nodeLeft is MazeWall {
//                //print("ENEMY: wall left")
//            }
//            if nodeRight is MazeWall {
//                //print("ENEMY: wall right")
//            }
            
            // TODO: make sure this is working properly
            // bounce back and switch directions if colliding with another enemy
            if (nodeAbove is Enemy) {
                    print("ENEMY: X4 turned around")
                    self.run(SKAction.applyImpulse(CGVector(dx: 0, dy: -rebound), duration: 0.2))
                    down()
            }
            if (nodeBelow is Enemy) {
                    print("ENEMY: X3 turned around")
                    self.run(SKAction.applyImpulse(CGVector(dx: 0, dy: rebound), duration: 0.2))
                    up()
            }
            if (nodeLeft is Enemy) {
                    print("ENEMY: X2 turned around")
                    self.run(SKAction.applyImpulse(CGVector(dx: rebound, dy: 0), duration: 0.2))
                    right()
            }
            if (nodeRight is Enemy) {
                    print("ENEMY: X1 turned around")
                    self.run(SKAction.applyImpulse(CGVector(dx: -rebound, dy: 0), duration: 0.2))
                    left()
            }
            
            // if going towards wall, pick random from other 3
            // else continue
            // A3, WALL ABOVE------------------------------------------------------------------------------------------------
            if (nodeAbove is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if self.direction == "left" {
                            // down or left
                            if self.number2 == 0 {
                                print("ENEMY: A3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: A3 random left")
                                left()
                            }
                        }
                        if self.direction == "up" {
                            // right or left
                            if self.number2 == 0 {
                                print("ENEMY: A3 random right")
                                right()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: A3 random left")
                                left()
                            }
                        }
                        if self.direction == "right" {
                            // down or right
                            if self.number2 == 0 {
                                print("ENEMY: A3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: A3 random right")
                                right()
                            }
                        }
                        if self.direction == "down" {
                            contDir()
                        }
                    }
                }
                if state != "corridor" {
                    if (direction == "up" || direction == "none") {
                        if number3 == 0 {
                            print("ENEMY: A3 random right")
                            right()
                            state = "wall"
                        }
                        if number3 == 1 {
                            print("ENEMY: A3 random left")
                            left()
                            state = "wall"
                        }
                        if number3 == 2 {
                            print("ENEMY: A3 random down")
                            down()
                            state = "wall"
                        }
                    }
                    if (direction == "right" || direction == "down" || direction == "left") {
                        contDir()
                        state = "wall"
                    }
                }
            }
            // B3, WALL BELOW-------------------------------------------------------------------------------------------------
            if (nodeBelow is MazeWall) && !(nodeAbove is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if self.direction == "down" {
                            // left or right
                            if self.number2 == 0 {
                                print("ENEMY: B3 random right")
                                right()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: B3 random left")
                                left()
                            }
                        }
                        if self.direction == "left" {
                            // down or left
                            if self.number2 == 0 {
                                print("ENEMY: B3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: B3 random left")
                                left()
                            }
                        }
                        if self.direction == "right" {
                            //down or right
                            if self.number2 == 0 {
                                print("ENEMY: B3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: B3 random right")
                                right()
                            }
                        }
                        if self.direction == "up" {
                            contDir()
                        }
                    }
                }
               
                if state != "corridor" {
                    if (direction == "down" || direction == "none") {
                        if number3 == 0 {
                            print("ENEMY: B3 random right")
                            right()
                            state = "wall"
                        }
                        if number3 == 1 {
                            print("ENEMY: B3 random left")
                            left()
                            state = "wall"
                        }
                        if number3 == 2 {
                            print("ENEMY: B3 random up")
                            up()
                            state = "wall"
                        }
                    }
                    if (direction == "up" || direction == "right" || direction == "left") {
                        contDir()
                        state = "wall"
                    }
                }
            }
            // C3, WALL LEFT------------------------------------------------------------------------------------------------
            if (nodeLeft is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeAbove is MazeWall) {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if self.direction == "left" {
                            // up or down
                            if self.number2 == 0 {
                                print("ENEMY: C3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: C3 random up")
                                up()
                            }

                        }
                        if self.direction == "up" {
                            // right or up
                            if self.number2 == 0 {
                                print("ENEMY: C3 random up")
                                up()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: C3 random right")
                                right()
                            }

                        }
                        if self.direction == "down" {
                            // right or down
                            if self.number2 == 0 {
                                print("ENEMY: C3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: C3 random right")
                                right()
                            }
                        }
                        if self.direction == "right" {
                            contDir()
                        }
                    }
                }
                
                if state != "corridor" {
                    if (direction == "left" || direction == "none") {
                        if number3 == 0 {
                            print("ENEMY: C3 random right")
                            right()
                            state = "wall"
                        }
                        if number3 == 1 {
                            print("ENEMY: C3 random down")
                            down()
                            state = "wall"
                        }
                        if number3 == 2 {
                            print("ENEMY: C3 random up")
                            up()
                            state = "wall"
                        }
                    }
                    if (direction == "up" || direction == "down" || direction == "right") {
                        contDir()
                        state = "wall"
                    }
                }
            }
            // D3, WALL RIGHT-------------------------------------------------------------------------------------------------
            if (nodeRight is MazeWall) && !(nodeBelow is MazeWall) && !(nodeAbove is MazeWall) && !(nodeLeft is MazeWall) {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if self.direction == "right" {
                            // up or down
                            if self.number2 == 0 {
                                print("ENEMY: D3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: D3 random up")
                                up()
                            }
                        }
                        if self.direction == "up" {
                            // up or left
                            if self.number2 == 0 {
                                print("ENEMY: D3 random up")
                                up()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: D3 random left")
                                left()
                            }
                        }
                        if self.direction == "down" {
                            // down or left
                            if self.number2 == 0 {
                                print("ENEMY: D3 random down")
                                down()
                            }
                            if self.number2 == 1 {
                                print("ENEMY: D3 random left")
                                left()
                            }
                        }
                        if self.direction == "left" {
                            contDir()
                        }
                    }
                }
               
                if state != "corridor" {
                    if (direction == "right"  || direction == "none") {
                        if number3 == 0 {
                            print("ENEMY: D3 random left")
                            left()
                            state = "wall"
                        }
                        if number3 == 1 {
                            print("ENEMY: D3 random down")
                            down()
                            state = "wall"
                        }
                        if number3 == 2 {
                            print("ENEMY: D3 random up")
                            up()
                            state = "wall"
                        }
                    }
                    if (direction == "up" || direction == "down" || direction == "left") {
                        contDir()
                        state = "wall"
                    }
                }
            }
            
            // if above&below go left/right----------------------------------------------------------------------------------
            if (nodeAbove is MazeWall) && (nodeBelow is MazeWall) {
                // BOXED IN
                // if wall left go right
                if (nodeLeft is MazeWall) {
                    print("ENEMY: undisputed right")
                    right()
                    state = "box"
                }
                // if wall right go left
                if (nodeRight is MazeWall) {
                    print("ENEMY: undisputed left")
                    left()
                    state = "box"
                }
                if !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
                    // HORIZONTAL CORRIDOR
                    if (direction == "up" || direction == "down" || direction == "none") {
                        // if open pick random
                        // A2
                        if number2 == 0 {
                            print("ENEMY: A2 random right")
                            right()
                            state = "corridor"
                        }
                        if number2 == 1 {
                            print("ENEMY: A2 random left")
                            left()
                            state = "corridor"
                        }
                    }
                    // A1
                    if (direction == "left" || direction == "right") {
                        contDir()
                        state = "corridor"
                    }
                }
            }
            
            // if left&right go up/down---------------------------------------------------------------------------------------
            if (nodeLeft is MazeWall) && (nodeRight is MazeWall) {
                // BOXED IN
                // if wall up go down
                if (nodeAbove is MazeWall) {
                    down()
                    print("ENEMY: undisputed down")
                    state = "box"
                }
                // if wall down go up
                if (nodeBelow is MazeWall) {
                    print("ENEMY: undisputed up")
                    up()
                    state = "box"
                }
                if !(nodeAbove is MazeWall) && !(nodeBelow is MazeWall) {
                    // VERTICAL CORRIDOR
                    if (direction == "left" || direction == "right" || direction == "none") {
                        //if open pick random
                        // B2
                        if number2 == 0 {
                            print("ENEMY: B2 random down")
                            down()
                            state = "corridor"
                        }
                        if number2 == 1 {
                            print("ENEMY: B2 random up")
                            up()
                            state = "corridor"
                        }
                    }
                    // B1
                    if (direction == "up" || direction == "down") {
                        contDir()
                        state = "corridor"
                    }
                }
            }
            // if up&right go down/left------------------------------------------------------------------------------------
            // CORNER
            if (nodeAbove is MazeWall) && (nodeRight is MazeWall) {
                    // C2
                    if (direction == "up" || direction == "right" || direction == "none") {
                        if direction == "up" {
                            print("ENEMY: C2 alternate left")
                            left()
                            state = "corner"
                        }
                        if direction == "right" {
                            print("ENEMY: C2 alternate down")
                            down()
                            state = "corner"
                        }
                        if direction == "none" {
                            if number2 == 0 {
                                print("ENEMY: C2 random left")
                                left()
                                state = "corner"
                            }
                            if number2 == 1 {
                                print("ENEMY: C2 random down")
                                down()
                                state = "corner"
                            }
                        }
                    }
                    // C1
                    if (direction == "left" || direction == "down") {
                        contDir()
                        state = "corner"
                    }
                }
            // if up&left go down/right-------------------------------------------------------------------------------------
            // CORNER
            if (nodeAbove is MazeWall) && (nodeLeft is MazeWall) {
                // D2
                if (direction == "up" || direction == "left" || direction == "none") {
                    if direction == "up" {
                        print("ENEMY: D2 alternate right")
                        right()
                        state = "corner"
                    }
                    if direction == "left" {
                        print("ENEMY: D2 alternate down")
                        down()
                        state = "corner"
                    }
                    if direction == "none" {
                        if number2 == 0 {
                            print("ENEMY: D2 random right")
                            right()
                            state = "corner"
                        }
                        if number2 == 1 {
                            print("ENEMY: D2 random down")
                            down()
                            state = "corner"
                        }
                    }
                }
                // D1
                if (direction == "down" || direction == "right" ){
                    contDir()
                    state = "corner"
                }
            }
            // if down&left go up/right-----------------------------------------------------------------------------------
            // CORNER
            if (nodeBelow is MazeWall) && (nodeLeft is MazeWall) {
                // E2
                if (direction == "down" || direction == "left" || direction == "none") {
                    if direction == "down" {
                        print("ENEMY: E2 alternate right")
                        right()
                        state = "corner"
                    }
                    if direction == "left" {
                        print("ENEMY: E2 alternate up")
                        up()
                        state = "corner"
                    }
                    if direction == "none" {
                        if number2 == 0 {
                            print("ENEMY: E2 random right")
                            right()
                            state = "corner"
                        }
                        if number2 == 1 {
                            print("ENEMY: E2 random up")
                            up()
                            state = "corner"
                        }
                    }
                }
                // E1
                if (direction == "up" || direction == "right") {
                    contDir()
                    state = "corner"
                }
            }
            // if down&right go up/left-------------------------------------------------------------------------------------
            // CORNER
            if (nodeBelow is MazeWall) && (nodeRight is MazeWall) {
                // F2
                if (direction == "down" || direction == "right" || direction == "none") {
                    if direction == "down" {
                        print("ENEMY: F2 alternate left")
                        left()
                        state = "corner"
                    }
                    if direction == "right" {
                        print("ENEMY: F2 alternate up")
                        up()
                        state = "corner"
                    }
                    if direction == "none" {
                        if number2 == 0 {
                            print("ENEMY: F2 random left")
                            left()
                            state = "corner"
                        }
                        if number2 == 1 {
                            print("ENEMY: F2 random up")
                            up()
                            state = "corner"
                        }
                    }
                }
                // F1
                if (direction == "up" || direction == "left") {
                    contDir()
                    state = "corner"
                }
            }
            
            // if walls in 0 directions pick random-------------------------------------------------------------------------
            // A0, OPEN
            if !(nodeAbove is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
                if direction == "none" {
                    if number4 == 0 {
                        print("ENEMY: A0 random down")
                        down()
                        state = "open"
                    }
                    if number4 == 1 {
                        print("ENEMY: A0 random up")
                        up()
                        state = "open"
                    }
                    if number4 == 2 {
                        print("ENEMY: A0 random right")
                        right()
                        state = "open"
                    }
                    if number4 == 3 {
                        print("ENEMY: A0 random left")
                        left()
                        state = "open"
                    }
                }
                if (direction == "up" || direction == "down" || direction == "left" || direction == "right") {
                    contDir()
                    state = "open"
                }
            }
        }
    }
}
