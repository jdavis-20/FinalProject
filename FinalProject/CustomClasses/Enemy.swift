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
    var enemySpeed = 100
    let rebound = 150
    let followSwitch: CGFloat = 10
    var follow = false
    var state = "none"
    // state options are
    //      open - no walls,
    //      wall - 1 wall,
    //      corridor - 2 walls parallel,
    //      corner - 2 walls perpendicular,
    //      box - 3 walls
    
    func enemyInit() {
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width,
                                                             height: self.frame.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = 0x00000001
        self.physicsBody?.restitution = 1
        
//        let rightline = SKShapeNode()
//        let rightPath = CGMutablePath()
//        rightPath.move(to: CGPoint(x:-100, y:0))
//        rightPath.addLine(to: CGPoint(x: 100,
//                                      y: 0))
//        rightline.path = rightPath
//        rightline.strokeColor = SKColor.red
//        addChild(rightline)
//
//        let upline = SKShapeNode()
//        let upPath = CGMutablePath()
//        upPath.move(to: CGPoint(x:0, y:-100))
//        upPath.addLine(to: CGPoint(x: 0,
//                                   y: 100))
//        upline.path = upPath
//        upline.strokeColor = SKColor.red
//        addChild(upline)
    }
    
    func pathfinding(playerNode: SKSpriteNode, currentScene: SKScene, character: String, ability: Bool) {
        
        let absXDiff = abs(playerNode.position.x-self.position.x)
        let absYDiff = abs(playerNode.position.y-self.position.y)
        let xGreater = absXDiff > absYDiff
        let yGreater = absYDiff > absXDiff
        let playerRight = playerNode.position.x > self.position.x
        let playerLeft = playerNode.position.x < self.position.x
        let playerUp = playerNode.position.y > self.position.y
        let playerDown = playerNode.position.y < self.position.y
        var dirOptions: Array = ["up", "down", "left", "right"]
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.number2 = Int(arc4random_uniform(2))
            self.number3 = Int(arc4random_uniform(3))
            self.number4 = Int(arc4random_uniform(4))
         // print("ENEMY: var changed \(self.number2), \(self.number3), \(self.number4)")
        }
        
        func left() {
            self.physicsBody?.velocity = CGVector(dx: -enemySpeed, dy: 0)
            direction = "left"
        }
        func right() {
            self.physicsBody?.velocity = CGVector(dx: enemySpeed, dy: 0)
            direction = "right"
        }
        func up() {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: enemySpeed)
            direction = "up"
        }
        func down() {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: -enemySpeed)
            direction = "down"
        }
        
        func contDir() {
//            print("ENEMY: continue \(direction)")
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
        
        func followDir() {
            // slow follow cause of sedate
            if (character == "Med" && ability == true) {
                enemySpeed = 80
            }
            // normal follow speed
            else {
                enemySpeed = 120
            }
            
            if (self.position.x - playerNode.position.x) > followSwitch {
                print("ENEMY: follow left")
                self.physicsBody?.velocity.dx = CGFloat(-enemySpeed)
            }
            if (playerNode.position.x - self.position.x) > followSwitch {
                self.physicsBody?.velocity.dx = CGFloat(enemySpeed)
                print("ENEMY: follow right")
            }
            if ((self.position.x - playerNode.position.x) < followSwitch) &&
                ((playerNode.position.x - self.position.x) < followSwitch) {
                self.physicsBody?.velocity.dx = CGFloat(0)
            }
            if (self.position.y - playerNode.position.y) > followSwitch {
                self.physicsBody?.velocity.dy = CGFloat(-enemySpeed)
                print("ENEMY: follow down")
            }
            if (playerNode.position.y - self.position.y) > followSwitch {
                self.physicsBody?.velocity.dy = CGFloat(enemySpeed)
                print("ENEMY: follow up")
            }
            if ((self.position.y - playerNode.position.y) < followSwitch) &&
                ((playerNode.position.y - self.position.y) < followSwitch) {
                self.physicsBody?.velocity.dy = CGFloat(0)
            }
            

            // this method was meant to make follow similar to regular pathfinding but it didn't work
//            if (absXDiff - absYDiff) > 100 {
//                print("ENEMY: follow x")
//                if playerLeft == true && dirOptions.contains("left") {
//                    left()
//                }
//                if playerRight == true && dirOptions.contains("right") {
//                    right()
//                }
//                else {
//                    if playerUp == true && dirOptions.contains("up") {
//                        up()
//                    }
//                    if playerDown == true && dirOptions.contains("down") {
//                        down()
//                    }
//                    else {
//                        follow = false
//                    }
//                }
//            }
//            if (absYDiff - absXDiff) > 100 {
//                print("ENEMY: follow y")
//                if playerUp == true && dirOptions.contains("up") {
//                    up()
//                }
//                if playerDown == true && dirOptions.contains("down") {
//                    down()
//                }
//                else {
//                    if playerLeft == true && dirOptions.contains("left") {
//                        left()
//                    }
//                    if playerRight == true && dirOptions.contains("right") {
//                        right()
//                    }
//                    else {
//                        follow = false
//                    }
//                }
//            }
//            if (-100...100).contains(absXDiff - absYDiff) {
//
//            }
        }
        
        let enemyRayPlayer = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                            end: playerNode.position)
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
        
        //TODO: implement distance limit on sighting? if so, can do with -if playerposition-enemyposition > distance-
        
        // enemy detects if player is in sight using raycasting
        // if it is then enemy follows player 
        if enemyRayPlayer?.node == playerNode {
            // follow doesn't work when using camo ability
            if (ability == false && character == "Bot") || character != "Bot" {
                follow = true
            }
            
            // this section causes enemy movemnt to be only straight or diagonal
            
            // if the difference in x is greater than the difference in y, move along x axis only
            //            if (absXDiff > absYDiff) {
            //                self.physicsBody?.velocity.dy = CGFloat(0)
            //                if (self.position.x - playerNode.position.x) > followSwitch {
            //                    print("ENEMY: follow left")
            //                    self.physicsBody?.velocity.dx = CGFloat(-80)
            //                }
            //                if (playerNode.position.x - self.position.x) > followSwitch {
            //                    self.physicsBody?.velocity.dx = CGFloat(80)
            //                    print("ENEMY: follow right")
            //                }
            //                if (absXDiff < followSwitch) {
            //                    self.physicsBody?.velocity.dx = CGFloat(0)
            //                }
            //            }
            // if the difference in y is greater than the difference in x, move along y axis only
            //            if (absYDiff > absXDiff) {
            //                self.physicsBody?.velocity.dx = CGFloat(0)
            //                if (self.position.y - playerNode.position.y) > followSwitch {
            //                    self.physicsBody?.velocity.dy = CGFloat(-80)
            //                    print("ENEMY: follow down")
            //                }
            //                if (playerNode.position.y - self.position.y) > followSwitch {
            //                    self.physicsBody?.velocity.dy = CGFloat(80)
            //                    print("ENEMY: follow up")
            //                }
            //                if (absYDiff < followSwitch) {
            //                    self.physicsBody?.velocity.dy = CGFloat(0)
            //                }
            //            }
            // if the difference in x and y positions is close, move along both axes
            //        if abs(absYDiff - absXDiff) < followSwitch {
            //            if (self.position.x - playerNode.position.x) > followSwitch {
            //                print("ENEMY: follow left")
            //                self.physicsBody?.velocity.dx = CGFloat(-enemySpeed)
            //            }
            //            if (playerNode.position.x - self.position.x) > followSwitch {
            //                self.physicsBody?.velocity.dx = CGFloat(enemySpeed)
            //                print("ENEMY: follow right")
            //            }
            //            if ((self.position.x - playerNode.position.x) < followSwitch) &&
            //                ((playerNode.position.x - self.position.x) < followSwitch) {
            //                self.physicsBody?.velocity.dx = CGFloat(0)
            //            }
            //            if (self.position.y - playerNode.position.y) > followSwitch {
            //                self.physicsBody?.velocity.dy = CGFloat(-enemySpeed)
            //                print("ENEMY: follow down")
            //            }
            //            if (playerNode.position.y - self.position.y) > followSwitch {
            //                self.physicsBody?.velocity.dy = CGFloat(enemySpeed)
            //                print("ENEMY: follow up")
            //            }
            //            if ((self.position.y - playerNode.position.y) < followSwitch) &&
            //                ((playerNode.position.y - self.position.y) < followSwitch) {
            //                self.physicsBody?.velocity.dy = CGFloat(0)
            //            }
            //        }
        }
        else {
            follow = false
            enemySpeed = 100
        }

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
        
//        if (self.physicsBody?.velocity.dx)! == 0 && (self.physicsBody?.velocity.dy)! < 10 {
//            print("BLOCK DETECTED")
//            let dirNum = Int(arc4random_uniform(UInt32(dirOptions.count)))
//            let randomDir = dirOptions[dirNum]
//            if randomDir == "up" {
//                up()
//            }
//            if randomDir == "down" {
//                down()
//            }
//            if randomDir == "left" {
//                left()
//            }
//            if randomDir == "right" {
//                right()
//            }
//        }
        
        // if going towards wall, pick random from other 3
        // else continue
        // A3, WALL ABOVE------------------------------------------------------------------------------------------------
        if (nodeAbove is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
            dirOptions = ["left", "right", "down"]
            if follow == false {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    if follow == false {
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            if self.direction == "left" {
                                // down or left
                                if self.number2 == 0 {
//                                    print("ENEMY: A3 random down")
                                    down()
                                }
                                if self.number2 == 1 {
//                                    print("ENEMY: A3 random left")
                                    left()
                                }
                            }
                            if self.direction == "up" {
                                // right or left
                                if self.number2 == 0 {
//                                    print("ENEMY: A3 random right")
                                    right()
                                }
                                if self.number2 == 1 {
//                                    print("ENEMY: A3 random left")
                                    left()
                                }
                            }
                            if self.direction == "right" {
                                // down or right
                                if self.number2 == 0 {
//                                    print("ENEMY: A3 random down")
                                    down()
                                }
                                if self.number2 == 1 {
//                                    print("ENEMY: A3 random right")
                                    right()
                                }
                            }
                            if self.direction == "down" {
                                contDir()
                            }
                        }
                    }
                }
                if state != "corridor" {
                    if (direction == "up" || direction == "none") {
                        if number3 == 0 {
//                            print("ENEMY: A3 random right")
                            right()
                            state = "wall"
                        }
                        if number3 == 1 {
//                            print("ENEMY: A3 random left")
                            left()
                            state = "wall"
                        }
                        if number3 == 2 {
//                            print("ENEMY: A3 random down")
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
            if follow == true {
                // and character camo not active
                followDir()
            }
        }
        // B3, WALL BELOW-------------------------------------------------------------------------------------------------
        if (nodeBelow is MazeWall) && !(nodeAbove is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
            dirOptions = ["left", "right", "up"]
            if follow == false {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if self.direction == "down" {
                            // left or right
                            if self.number2 == 0 {
//                                print("ENEMY: B3 random right")
                                right()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: B3 random left")
                                left()
                            }
                        }
                        if self.direction == "left" {
                            // down or left
                            if self.number2 == 0 {
//                                print("ENEMY: B3 random down")
                                down()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: B3 random left")
                                left()
                            }
                        }
                        if self.direction == "right" {
                            //down or right
                            if self.number2 == 0 {
//                                print("ENEMY: B3 random down")
                                down()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: B3 random right")
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
//                            print("ENEMY: B3 random right")
                            right()
                            state = "wall"
                        }
                        if number3 == 1 {
//                            print("ENEMY: B3 random left")
                            left()
                            state = "wall"
                        }
                        if number3 == 2 {
//                            print("ENEMY: B3 random up")
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
            if follow == true {
                followDir()
            }
        }
        // C3, WALL LEFT------------------------------------------------------------------------------------------------
        if (nodeLeft is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeAbove is MazeWall) {
            dirOptions = ["up", "right", "down"]
            if follow == false {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if self.direction == "left" {
                            // up or down
                            if self.number2 == 0 {
//                                print("ENEMY: C3 random down")
                                down()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: C3 random up")
                                up()
                            }
                            
                        }
                        if self.direction == "up" {
                            // right or up
                            if self.number2 == 0 {
//                                print("ENEMY: C3 random up")
                                up()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: C3 random right")
                                right()
                            }
                            
                        }
                        if self.direction == "down" {
                            // right or down
                            if self.number2 == 0 {
//                                print("ENEMY: C3 random down")
                                down()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: C3 random right")
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
//                            print("ENEMY: C3 random right")
                            right()
                            state = "wall"
                        }
                        if number3 == 1 {
//                            print("ENEMY: C3 random down")
                            down()
                            state = "wall"
                        }
                        if number3 == 2 {
//                            print("ENEMY: C3 random up")
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
            if follow == true {
                followDir()
            }
        }
        // D3, WALL RIGHT-------------------------------------------------------------------------------------------------
        if (nodeRight is MazeWall) && !(nodeBelow is MazeWall) && !(nodeAbove is MazeWall) && !(nodeLeft is MazeWall) {
            dirOptions = ["left", "up", "down"]
            if follow == false {
                if state == "corridor" {
                    state = "wall"
                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        if self.direction == "right" {
                            // up or down
                            if self.number2 == 0 {
//                                print("ENEMY: D3 random down")
                                down()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: D3 random up")
                                up()
                            }
                        }
                        if self.direction == "up" {
                            // up or left
                            if self.number2 == 0 {
//                                print("ENEMY: D3 random up")
                                up()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: D3 random left")
                                left()
                            }
                        }
                        if self.direction == "down" {
                            // down or left
                            if self.number2 == 0 {
//                                print("ENEMY: D3 random down")
                                down()
                            }
                            if self.number2 == 1 {
//                                print("ENEMY: D3 random left")
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
//                            print("ENEMY: D3 random left")
                            left()
                            state = "wall"
                        }
                        if number3 == 1 {
//                            print("ENEMY: D3 random down")
                            down()
                            state = "wall"
                        }
                        if number3 == 2 {
//                            print("ENEMY: D3 random up")
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
            if follow == true {
                followDir()
            }
        }
        
        // if above&below go left/right----------------------------------------------------------------------------------
        if (nodeAbove is MazeWall) && (nodeBelow is MazeWall) {
            // BOXED IN
            // if wall left go right
            if (nodeLeft is MazeWall) {
//                print("ENEMY: undisputed right")
                right()
                state = "box"
            }
            // if wall right go left
            if (nodeRight is MazeWall) {
//                print("ENEMY: undisputed left")
                left()
                state = "box"
            }
            if !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
                dirOptions = ["up", "down"]
                    if follow == false {
                    // HORIZONTAL CORRIDOR
                    if (direction == "up" || direction == "down" || direction == "none") {
                        // if open pick random
                        // A2
                        if number2 == 0 {
//                            print("ENEMY: A2 random right")
                            right()
                            state = "corridor"
                        }
                        if number2 == 1 {
//                            print("ENEMY: A2 random left")
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
                if follow == true {
                    followDir()
                }
            }
        }
        
        // if left&right go up/down---------------------------------------------------------------------------------------
        if (nodeLeft is MazeWall) && (nodeRight is MazeWall) {
            // BOXED IN
            // if wall up go down
            if (nodeAbove is MazeWall) {
                down()
//                print("ENEMY: undisputed down")
                state = "box"
            }
            // if wall down go up
            if (nodeBelow is MazeWall) {
//                print("ENEMY: undisputed up")
                up()
                state = "box"
            }
            if !(nodeAbove is MazeWall) && !(nodeBelow is MazeWall) {
                dirOptions = ["left", "right"]
                    if follow == false {
                    // VERTICAL CORRIDOR
                    if (direction == "left" || direction == "right" || direction == "none") {
                        //if open pick random
                        // B2
                        if number2 == 0 {
//                            print("ENEMY: B2 random down")
                            down()
                            state = "corridor"
                        }
                        if number2 == 1 {
//                            print("ENEMY: B2 random up")
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
                if follow == true {
                    followDir()
                }
            }
        }
        // if up&right go down/left------------------------------------------------------------------------------------
        // CORNER
        if (nodeAbove is MazeWall) && (nodeRight is MazeWall) {
            dirOptions = ["left", "down"]
            if follow == false {
                // C2
                if (direction == "up" || direction == "right" || direction == "none") {
                    if direction == "up" {
//                        print("ENEMY: C2 alternate left")
                        left()
                        state = "corner"
                    }
                    if direction == "right" {
//                        print("ENEMY: C2 alternate down")
                        down()
                        state = "corner"
                    }
                    if direction == "none" {
                        if number2 == 0 {
//                            print("ENEMY: C2 random left")
                            left()
                            state = "corner"
                        }
                        if number2 == 1 {
//                            print("ENEMY: C2 random down")
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
            if follow == true {
                followDir()
            }
        }
        // if up&left go down/right-------------------------------------------------------------------------------------
        // CORNER
        if (nodeAbove is MazeWall) && (nodeLeft is MazeWall) {
            dirOptions = ["right", "down"]
            if follow == false {
                // D2
                if (direction == "up" || direction == "left" || direction == "none") {
                    if direction == "up" {
//                        print("ENEMY: D2 alternate right")
                        right()
                        state = "corner"
                    }
                    if direction == "left" {
//                        print("ENEMY: D2 alternate down")
                        down()
                        state = "corner"
                    }
                    if direction == "none" {
                        if number2 == 0 {
//                            print("ENEMY: D2 random right")
                            right()
                            state = "corner"
                        }
                        if number2 == 1 {
//                            print("ENEMY: D2 random down")
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
            if follow == true {
                followDir()
            }
        }
        // if down&left go up/right-----------------------------------------------------------------------------------
        // CORNER
        if (nodeBelow is MazeWall) && (nodeLeft is MazeWall) {
            dirOptions = ["up", "right"]
            if follow == false {
                // E2
                if (direction == "down" || direction == "left" || direction == "none") {
                    if direction == "down" {
//                        print("ENEMY: E2 alternate right")
                        right()
                        state = "corner"
                    }
                    if direction == "left" {
//                        print("ENEMY: E2 alternate up")
                        up()
                        state = "corner"
                    }
                    if direction == "none" {
                        if number2 == 0 {
//                            print("ENEMY: E2 random right")
                            right()
                            state = "corner"
                        }
                        if number2 == 1 {
//                            print("ENEMY: E2 random up")
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
            if follow == true {
                followDir()
            }
        }
        // if down&right go up/left-------------------------------------------------------------------------------------
        // CORNER
        if (nodeBelow is MazeWall) && (nodeRight is MazeWall) {
            dirOptions = ["left", "up"]
            // F2
            if follow == false {
                if (direction == "down" || direction == "right" || direction == "none") {
                    if direction == "down" {
//                        print("ENEMY: F2 alternate left")
                        left()
                        state = "corner"
                    }
                    if direction == "right" {
//                        print("ENEMY: F2 alternate up")
                        up()
                        state = "corner"
                    }
                    if direction == "none" {
                        if number2 == 0 {
//                            print("ENEMY: F2 random left")
                            left()
                            state = "corner"
                        }
                        if number2 == 1 {
//                            print("ENEMY: F2 random up")
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
            if follow == true {
                followDir()
            }
        }
        
        // if walls in 0 directions pick random-------------------------------------------------------------------------
        // A0, OPEN
        if !(nodeAbove is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
            dirOptions = ["left", "right", "down", "up"]
            if follow == false {
                if direction == "none" {
                    if number4 == 0 {
//                        print("ENEMY: A0 random down")
                        down()
                        state = "open"
                    }
                    if number4 == 1 {
//                        print("ENEMY: A0 random up")
                        up()
                        state = "open"
                    }
                    if number4 == 2 {
//                        print("ENEMY: A0 random right")
                        right()
                        state = "open"
                    }
                    if number4 == 3 {
//                        print("ENEMY: A0 random left")
                        left()
                        state = "open"
                    }
                }
                if (direction == "up" || direction == "down" || direction == "left" || direction == "right") {
                    contDir()
                    state = "open"
                }
            }
            if follow == true {
                followDir()
            }
        }
    }
}

