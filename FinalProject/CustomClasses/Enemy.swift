//
//  Enemy.swift
//  FinalProject
//
//  Created by Julian Davis on 11/7/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {

    var randomOutOf2 = Int(arc4random_uniform(2))
    var randomOutOf3 = Int(arc4random_uniform(3))
    var randomOutOf4 = Int(arc4random_uniform(4))
    var enemySpeed = 100
    
    let normalSpeed = 110
    let slowSpeed = 60
    let fastSpeed = 140
    let rayRange: CGFloat = 110
    let turnDelay = 0.8
    let reboundImpulse = 150
    let followDirPadding: CGFloat = 10
    
    var followPlayer = false
    var currentDirection = "none"
    var wallsState = "none"
    // state options are
    //      open
    //      wall |
    //      corridor | |
    //      corner |_
    //      box |_|
    
    func enemyInit() {
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width,
                                                             height: self.frame.size.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.contactTestBitMask = 0x00000001
        self.physicsBody?.restitution = 1
        
        // visualization of enemy raycasting for pathfinding
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
            self.randomOutOf2 = Int(arc4random_uniform(2))
            self.randomOutOf3 = Int(arc4random_uniform(3))
            self.randomOutOf4 = Int(arc4random_uniform(4))
         // print("ENEMY: var changed \(self.randomOutOf2), \(self.randomOutOf3), \(self.randomOutOf4)")
        }
        
        func left() {
            self.physicsBody?.velocity = CGVector(dx: -enemySpeed, dy: 0)
            currentDirection = "left"
        }
        func right() {
            self.physicsBody?.velocity = CGVector(dx: enemySpeed, dy: 0)
            currentDirection = "right"
        }
        func up() {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: enemySpeed)
            currentDirection = "up"
        }
        func down() {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: -enemySpeed)
            currentDirection = "down"
        }
        
        func contDir() {
//            print("ENEMY: continue \(currentDirection)")
            if currentDirection == "down" {
                down()
            }
            if currentDirection == "up" {
                up()
            }
            if currentDirection == "left" {
                left()
            }
            if currentDirection == "right" {
                right()
            }
        }
        
        func followDir() {
            // slow follow cause of sedate
            if (character == "Med" && ability == true) {
                enemySpeed = slowSpeed
            }
            // normal follow speed
            else {
                enemySpeed = fastSpeed
            }
            
            if (self.position.x - playerNode.position.x) > followDirPadding {
//                print("ENEMY: follow left")
                self.physicsBody?.velocity.dx = CGFloat(-enemySpeed)
            }
            if (playerNode.position.x - self.position.x) > followDirPadding {
                self.physicsBody?.velocity.dx = CGFloat(enemySpeed)
//                print("ENEMY: follow right")
            }
            if ((self.position.x - playerNode.position.x) < followDirPadding) &&
                ((playerNode.position.x - self.position.x) < followDirPadding) {
                self.physicsBody?.velocity.dx = CGFloat(0)
            }
            if (self.position.y - playerNode.position.y) > followDirPadding {
                self.physicsBody?.velocity.dy = CGFloat(-enemySpeed)
//                print("ENEMY: follow down")
            }
            if (playerNode.position.y - self.position.y) > followDirPadding {
                self.physicsBody?.velocity.dy = CGFloat(enemySpeed)
//                print("ENEMY: follow up")
            }
            if ((self.position.y - playerNode.position.y) < followDirPadding) &&
                ((playerNode.position.y - self.position.y) < followDirPadding) {
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
                                                                     y: self.position.y + rayRange))
        let enemyRayDown = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                          end: CGPoint(x: self.position.x,
                                                                       y: self.position.y - rayRange))
        let enemyRayLeft = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                          end: CGPoint(x: self.position.x - rayRange,
                                                                       y: self.position.y))
        let enemyRayRight = currentScene.physicsWorld.body(alongRayStart: self.position,
                                                           end: CGPoint(x: self.position.x + rayRange,
                                                                        y: self.position.y))
        let nodeAbove = enemyRayUp?.node
        let nodeBelow = enemyRayDown?.node
        let nodeLeft = enemyRayLeft?.node
        let nodeRight = enemyRayRight?.node
        
        // enemy detects if player is in sight using raycasting
        // if it is then enemy follows player
        // follow doesn't work when using camo ability
        if enemyRayPlayer?.node == playerNode {
            if character == "Bot" && ability == true {
                followPlayer = false
                enemySpeed = normalSpeed
            }
            else {
                followPlayer = true
                
            }
        }
        else {
            followPlayer = false
            enemySpeed = normalSpeed
        }

        // TODO: make sure this is working properly
        // bounce back and switch directions if colliding with another enemy
        if (nodeAbove is Enemy) {
            print("ENEMY: X4 turned around")
            self.run(SKAction.applyImpulse(CGVector(dx: 0, dy: -reboundImpulse), duration: 0.2))
            down()
        }
        if (nodeBelow is Enemy) {
            print("ENEMY: X3 turned around")
            self.run(SKAction.applyImpulse(CGVector(dx: 0, dy: reboundImpulse), duration: 0.2))
            up()
        }
        if (nodeLeft is Enemy) {
            print("ENEMY: X2 turned around")
            self.run(SKAction.applyImpulse(CGVector(dx: reboundImpulse, dy: 0), duration: 0.2))
            right()
        }
        if (nodeRight is Enemy) {
            print("ENEMY: X1 turned around")
            self.run(SKAction.applyImpulse(CGVector(dx: -reboundImpulse, dy: 0), duration: 0.2))
            left()
        }
        
//        this was an attempt to fix enemies getting stuck- contains method for random out of dirOptions array
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
            if followPlayer == false {
                if wallsState == "corridor" {
                    wallsState = "wall"
//                    print("ENEMY: delay")
                    if followPlayer == false {
                        DispatchQueue.main.asyncAfter(deadline: .now() + turnDelay) {
                            if self.currentDirection == "left" {
                                // down or left
                                if self.randomOutOf2 == 0 {
//                                    print("ENEMY: A3 random down")
                                    down()
                                }
                                if self.randomOutOf2 == 1 {
//                                    print("ENEMY: A3 random left")
                                    left()
                                }
                            }
                            if self.currentDirection == "up" {
                                // right or left
                                if self.randomOutOf2 == 0 {
//                                    print("ENEMY: A3 random right")
                                    right()
                                }
                                if self.randomOutOf2 == 1 {
//                                    print("ENEMY: A3 random left")
                                    left()
                                }
                            }
                            if self.currentDirection == "right" {
                                // down or right
                                if self.randomOutOf2 == 0 {
//                                    print("ENEMY: A3 random down")
                                    down()
                                }
                                if self.randomOutOf2 == 1 {
//                                    print("ENEMY: A3 random right")
                                    right()
                                }
                            }
                            if self.currentDirection == "down" {
                                contDir()
                            }
                        }
                    }
                }
                if wallsState != "corridor" {
                    if (currentDirection == "up" || currentDirection == "none") {
                        if randomOutOf3 == 0 {
//                            print("ENEMY: A3 random right")
                            right()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 1 {
//                            print("ENEMY: A3 random left")
                            left()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 2 {
//                            print("ENEMY: A3 random down")
                            down()
                            wallsState = "wall"
                        }
                    }
                    if (currentDirection == "right" || currentDirection == "down" || currentDirection == "left") {
                        contDir()
                        wallsState = "wall"
                    }
                }
            }
            if followPlayer == true {
                // and character camo not active
                followDir()
            }
        }
        // B3, WALL BELOW-------------------------------------------------------------------------------------------------
        if (nodeBelow is MazeWall) && !(nodeAbove is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
            dirOptions = ["left", "right", "up"]
            if followPlayer == false {
                if wallsState == "corridor" {
                    wallsState = "wall"
//                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + turnDelay) {
                        if self.currentDirection == "down" {
                            // left or right
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: B3 random right")
                                right()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: B3 random left")
                                left()
                            }
                        }
                        if self.currentDirection == "left" {
                            // down or left
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: B3 random down")
                                down()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: B3 random left")
                                left()
                            }
                        }
                        if self.currentDirection == "right" {
                            //down or right
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: B3 random down")
                                down()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: B3 random right")
                                right()
                            }
                        }
                        if self.currentDirection == "up" {
                            contDir()
                        }
                    }
                }
                if wallsState != "corridor" {
                    if (currentDirection == "down" || currentDirection == "none") {
                        if randomOutOf3 == 0 {
//                            print("ENEMY: B3 random right")
                            right()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 1 {
//                            print("ENEMY: B3 random left")
                            left()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 2 {
//                            print("ENEMY: B3 random up")
                            up()
                            wallsState = "wall"
                        }
                    }
                    if (currentDirection == "up" || currentDirection == "right" || currentDirection == "left") {
                        contDir()
                        wallsState = "wall"
                    }
                }
            }
            if followPlayer == true {
                followDir()
            }
        }
        // C3, WALL LEFT------------------------------------------------------------------------------------------------
        if (nodeLeft is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeAbove is MazeWall) {
            dirOptions = ["up", "right", "down"]
            if followPlayer == false {
                if wallsState == "corridor" {
                    wallsState = "wall"
//                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + turnDelay) {
                        if self.currentDirection == "left" {
                            // up or down
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: C3 random down")
                                down()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: C3 random up")
                                up()
                            }
                            
                        }
                        if self.currentDirection == "up" {
                            // right or up
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: C3 random up")
                                up()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: C3 random right")
                                right()
                            }
                            
                        }
                        if self.currentDirection == "down" {
                            // right or down
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: C3 random down")
                                down()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: C3 random right")
                                right()
                            }
                        }
                        if self.currentDirection == "right" {
                            contDir()
                        }
                    }
                }
                
                if wallsState != "corridor" {
                    if (currentDirection == "left" || currentDirection == "none") {
                        if randomOutOf3 == 0 {
//                            print("ENEMY: C3 random right")
                            right()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 1 {
//                            print("ENEMY: C3 random down")
                            down()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 2 {
//                            print("ENEMY: C3 random up")
                            up()
                            wallsState = "wall"
                        }
                    }
                    if (currentDirection == "up" || currentDirection == "down" || currentDirection == "right") {
                        contDir()
                        wallsState = "wall"
                    }
                }
            }
            if followPlayer == true {
                followDir()
            }
        }
        // D3, WALL RIGHT-------------------------------------------------------------------------------------------------
        if (nodeRight is MazeWall) && !(nodeBelow is MazeWall) && !(nodeAbove is MazeWall) && !(nodeLeft is MazeWall) {
            dirOptions = ["left", "up", "down"]
            if followPlayer == false {
                if wallsState == "corridor" {
                    wallsState = "wall"
//                    print("ENEMY: delay")
                    DispatchQueue.main.asyncAfter(deadline: .now() + turnDelay) {
                        if self.currentDirection == "right" {
                            // up or down
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: D3 random down")
                                down()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: D3 random up")
                                up()
                            }
                        }
                        if self.currentDirection == "up" {
                            // up or left
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: D3 random up")
                                up()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: D3 random left")
                                left()
                            }
                        }
                        if self.currentDirection == "down" {
                            // down or left
                            if self.randomOutOf2 == 0 {
//                                print("ENEMY: D3 random down")
                                down()
                            }
                            if self.randomOutOf2 == 1 {
//                                print("ENEMY: D3 random left")
                                left()
                            }
                        }
                        if self.currentDirection == "left" {
                            contDir()
                        }
                    }
                }
                
                if wallsState != "corridor" {
                    if (currentDirection == "right"  || currentDirection == "none") {
                        if randomOutOf3 == 0 {
//                            print("ENEMY: D3 random left")
                            left()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 1 {
//                            print("ENEMY: D3 random down")
                            down()
                            wallsState = "wall"
                        }
                        if randomOutOf3 == 2 {
//                            print("ENEMY: D3 random up")
                            up()
                            wallsState = "wall"
                        }
                    }
                    if (currentDirection == "up" || currentDirection == "down" || currentDirection == "left") {
                        contDir()
                        wallsState = "wall"
                    }
                }
            }
            if followPlayer == true {
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
                wallsState = "box"
            }
            // if wall right go left
            if (nodeRight is MazeWall) {
//                print("ENEMY: undisputed left")
                left()
                wallsState = "box"
            }
            if !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
                dirOptions = ["up", "down"]
                    if followPlayer == false {
                    // HORIZONTAL CORRIDOR
                    if (currentDirection == "up" || currentDirection == "down" || currentDirection == "none") {
                        // if open pick random
                        // A2
                        if randomOutOf2 == 0 {
//                            print("ENEMY: A2 random right")
                            right()
                            wallsState = "corridor"
                        }
                        if randomOutOf2 == 1 {
//                            print("ENEMY: A2 random left")
                            left()
                            wallsState = "corridor"
                        }
                    }
                    // A1
                    if (currentDirection == "left" || currentDirection == "right") {
                        contDir()
                        wallsState = "corridor"
                    }
                }
                if followPlayer == true {
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
                wallsState = "box"
            }
            // if wall down go up
            if (nodeBelow is MazeWall) {
//                print("ENEMY: undisputed up")
                up()
                wallsState = "box"
            }
            if !(nodeAbove is MazeWall) && !(nodeBelow is MazeWall) {
                dirOptions = ["left", "right"]
                    if followPlayer == false {
                    // VERTICAL CORRIDOR
                    if (currentDirection == "left" || currentDirection == "right" || currentDirection == "none") {
                        //if open pick random
                        // B2
                        if randomOutOf2 == 0 {
//                            print("ENEMY: B2 random down")
                            down()
                            wallsState = "corridor"
                        }
                        if randomOutOf2 == 1 {
//                            print("ENEMY: B2 random up")
                            up()
                            wallsState = "corridor"
                        }
                    }
                    // B1
                    if (currentDirection == "up" || currentDirection == "down") {
                        contDir()
                        wallsState = "corridor"
                    }
                }
                if followPlayer == true {
                    followDir()
                }
            }
        }
        // if up&right go down/left------------------------------------------------------------------------------------
        // CORNER
        if (nodeAbove is MazeWall) && (nodeRight is MazeWall) {
            dirOptions = ["left", "down"]
            if followPlayer == false {
                // C2
                if (currentDirection == "up" || currentDirection == "right" || currentDirection == "none") {
                    if currentDirection == "up" {
//                        print("ENEMY: C2 alternate left")
                        left()
                        wallsState = "corner"
                    }
                    if currentDirection == "right" {
//                        print("ENEMY: C2 alternate down")
                        down()
                        wallsState = "corner"
                    }
                    if currentDirection == "none" {
                        if randomOutOf2 == 0 {
//                            print("ENEMY: C2 random left")
                            left()
                            wallsState = "corner"
                        }
                        if randomOutOf2 == 1 {
//                            print("ENEMY: C2 random down")
                            down()
                            wallsState = "corner"
                        }
                    }
                }
                // C1
                if (currentDirection == "left" || currentDirection == "down") {
                    contDir()
                    wallsState = "corner"
                }
            }
            if followPlayer == true {
                followDir()
            }
        }
        // if up&left go down/right-------------------------------------------------------------------------------------
        // CORNER
        if (nodeAbove is MazeWall) && (nodeLeft is MazeWall) {
            dirOptions = ["right", "down"]
            if followPlayer == false {
                // D2
                if (currentDirection == "up" || currentDirection == "left" || currentDirection == "none") {
                    if currentDirection == "up" {
//                        print("ENEMY: D2 alternate right")
                        right()
                        wallsState = "corner"
                    }
                    if currentDirection == "left" {
//                        print("ENEMY: D2 alternate down")
                        down()
                        wallsState = "corner"
                    }
                    if currentDirection == "none" {
                        if randomOutOf2 == 0 {
//                            print("ENEMY: D2 random right")
                            right()
                            wallsState = "corner"
                        }
                        if randomOutOf2 == 1 {
//                            print("ENEMY: D2 random down")
                            down()
                            wallsState = "corner"
                        }
                    }
                }
                // D1
                if (currentDirection == "down" || currentDirection == "right" ){
                    contDir()
                    wallsState = "corner"
                }
            }
            if followPlayer == true {
                followDir()
            }
        }
        // if down&left go up/right-----------------------------------------------------------------------------------
        // CORNER
        if (nodeBelow is MazeWall) && (nodeLeft is MazeWall) {
            dirOptions = ["up", "right"]
            if followPlayer == false {
                // E2
                if (currentDirection == "down" || currentDirection == "left" || currentDirection == "none") {
                    if currentDirection == "down" {
//                        print("ENEMY: E2 alternate right")
                        right()
                        wallsState = "corner"
                    }
                    if currentDirection == "left" {
//                        print("ENEMY: E2 alternate up")
                        up()
                        wallsState = "corner"
                    }
                    if currentDirection == "none" {
                        if randomOutOf2 == 0 {
//                            print("ENEMY: E2 random right")
                            right()
                            wallsState = "corner"
                        }
                        if randomOutOf2 == 1 {
//                            print("ENEMY: E2 random up")
                            up()
                            wallsState = "corner"
                        }
                    }
                }
                // E1
                if (currentDirection == "up" || currentDirection == "right") {
                    contDir()
                    wallsState = "corner"
                }
            }
            if followPlayer == true {
                followDir()
            }
        }
        // if down&right go up/left-------------------------------------------------------------------------------------
        // CORNER
        if (nodeBelow is MazeWall) && (nodeRight is MazeWall) {
            dirOptions = ["left", "up"]
            // F2
            if followPlayer == false {
                if (currentDirection == "down" || currentDirection == "right" || currentDirection == "none") {
                    if currentDirection == "down" {
//                        print("ENEMY: F2 alternate left")
                        left()
                        wallsState = "corner"
                    }
                    if currentDirection == "right" {
//                        print("ENEMY: F2 alternate up")
                        up()
                        wallsState = "corner"
                    }
                    if currentDirection == "none" {
                        if randomOutOf2 == 0 {
//                            print("ENEMY: F2 random left")
                            left()
                            wallsState = "corner"
                        }
                        if randomOutOf2 == 1 {
//                            print("ENEMY: F2 random up")
                            up()
                            wallsState = "corner"
                        }
                    }
                }
                // F1
                if (currentDirection == "up" || currentDirection == "left") {
                    contDir()
                    wallsState = "corner"
                }
            }
            if followPlayer == true {
                followDir()
            }
        }
        
        // if walls in 0 directions pick random-------------------------------------------------------------------------
        // A0, OPEN
        if !(nodeAbove is MazeWall) && !(nodeBelow is MazeWall) && !(nodeRight is MazeWall) && !(nodeLeft is MazeWall) {
            dirOptions = ["left", "right", "down", "up"]
            if followPlayer == false {
                if currentDirection == "none" {
                    if randomOutOf4 == 0 {
//                        print("ENEMY: A0 random down")
                        down()
                        wallsState = "open"
                    }
                    if randomOutOf4 == 1 {
//                        print("ENEMY: A0 random up")
                        up()
                        wallsState = "open"
                    }
                    if randomOutOf4 == 2 {
//                        print("ENEMY: A0 random right")
                        right()
                        wallsState = "open"
                    }
                    if randomOutOf4 == 3 {
//                        print("ENEMY: A0 random left")
                        left()
                        wallsState = "open"
                    }
                }
                if (currentDirection == "up" || currentDirection == "down" || currentDirection == "left" || currentDirection == "right") {
                    contDir()
                    wallsState = "open"
                }
            }
            if followPlayer == true {
                followDir()
            }
        }
    }
}

