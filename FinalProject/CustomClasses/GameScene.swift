//
//  GameScene.swift
//  FinalProject
//
//  Created by Julian Davis on 10/12/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox
import UIKit

// nodes
var worldNode = SKNode()
var camera = SKCameraNode()
var manager = CMMotionManager()
var player = SKSpriteNode()

// menus and popups
var inGameMenu =  Menu(screenHeight: 375,
                       screenWidth: 667)
var itemPopup = Popup(image: "pop", type: "item", worldNode: worldNode)
var optionsPopup = Popup(image: "pop", type: "options", worldNode: worldNode)
var charSelPopup = Popup(image: "pop", type: "charsel", worldNode: worldNode)
var winPopup = Popup(image: "pop", type: "win", worldNode: worldNode)
var losePopup = Popup(image: "pop", type: "lose", worldNode: worldNode)

var menuOut = true
var itemPopupOut = false
var optionsPopupOut = true
var charSelOut = true
var losePopupOut = false
var winPopupOut = false

// orientation
var preferredTilt: Double?
var destX: CGFloat = 0.0
var destY: CGFloat = 0.0

// game state values
var started = false

var character = ""
var playerHealth: Int = 10
var playerItems: Int = 0
var itemCount = 0
var healthLabel = SKLabelNode(text: String(10))
var itemLabel = SKLabelNode(text: String(0))

var playerAlive = true
var playerWon = false
var playerYDirection = "up"
var playerXDirection = "still"
var enemyInit = false
var abilityActive = false

var sfxVol: Float = 1
var musicVol: Float = 1
var vibOn = true

// movement and animation
let away = SKAction.setTexture(SKTexture(imageNamed: "BlueFront"))
let towards = SKAction.setTexture(SKTexture(imageNamed: "RedFront"))


//  this is the superclass to all game levels----------------------------------------------------------------------------------
// it contains fundamental mechanics and nodes that need to persist across levels----------------------------------------

class GameScene: SKScene, SKPhysicsContactDelegate {

    func startGame(){
        character = charSelPopup.character
        print("CHARACTER: \(character)")
        if character != "" {
            // started variable sets tilt and other attributes, signals gameplay start
            started = true
            player.isHidden = false
            charSelPopup.invisible()
            play(inGameMenu)
            
            // print(inGameMenu.position)
        }
    }
    
    func pause(_ node: SKNode? = nil){
        worldNode.isPaused = true
        node?.isPaused = true
        physicsWorld.speed = 0
    }
    func play(_ node: SKNode? = nil) {
        worldNode.isPaused = false
        node?.isPaused = false
        physicsWorld.speed = 1
    }
    
    func sfx(_ file: String, vibrate: Bool) {
        let sound = SKAction.playSoundFileNamed(file, waitForCompletion: false)
        SKAction.changeVolume(to: sfxVol, duration: 0)
        self.run(sound)
        // TODO: vibration response
        if vibrate == true && vibOn == true {
            AudioServicesPlaySystemSound(1519)
//          AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    //buttons on the in-game menu-------------------------------------------------------
    
    func returnToMenu(){
        print("MENU: main menu button pressed")
        let menuScene = SKScene(fileNamed: "MenuScene")
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(menuScene!, transition: transition)

        charSelPopup.childNode(withName: "startButton")?.removeFromParent()
        
        worldNode.removeAllChildren()
        camera!.removeAllChildren()
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    func options(){
        print("MENU: options button pressed")
        optionsPopup.visible()
        optionsPopupOut = true
        pause(inGameMenu)
    }
    
    //executes when the scene is first loaded------------------------------------------------------------------------------
    
    override func didMove(to view: SKView) {
        // scaling the view
        camera!.setScale(1.5)
        let zoomOut = SKAction.scale(by: 1.5, duration: 1.2)
        camera!.run(zoomOut)
        
        // values that need to be reset at the start of the level
        playerHealth = 10
        playerItems = 0
        itemCount = 0
        preferredTilt = nil
        started = false
        charSelPopup.character = ""
        optionsPopup.invisible()
        
        // only nodes that are children of worldNode will be paused
        // allows menus to work after they are opened
        addChild(worldNode)
        
        // creates character select popup at the start of the level
        camera!.addChild(charSelPopup)
        charSelPopup.visible()
        charSelOut = true
        pause(inGameMenu)
        
        for button in [charSelPopup.char1button, charSelPopup.char2button, charSelPopup.char3button] {
        button.activeButton.isHidden = true
        button.defaultButton.isHidden = false
        }
        
        // set tilt and start moving
        let startButton = Button(defaultButtonImage: "start",
                                 activeButtonImage: "startflat",
                                 toggle: false)
        startButton.action = startGame
        startButton.name = "startButton"
        startButton.position = CGPoint(x: 0,
                                       y: -80)
        startButton.zPosition = 3
        charSelPopup.addChild(startButton)
        
        // add health and item counters to HUD
        healthLabel.position = CGPoint(x: -frame.size.width/2.2 , y: frame.size.height/2.5)
        camera!.addChild(healthLabel)
        
        itemLabel.position = CGPoint(x: -frame.size.width/2.6 , y: frame.size.height/2.5)
        camera!.addChild(itemLabel)
        
        // button to return to menu after win/lose
        let loseReturnButton = Button(defaultButtonImage: "menu",
                                      activeButtonImage: "menuflat",
                                      toggle: false)
        loseReturnButton.action = returnToMenu
        loseReturnButton.position = CGPoint(x: 0, y: 40)
        loseReturnButton.zPosition = 3
        
        let winReturnButton = Button(defaultButtonImage: "menu",
                                      activeButtonImage: "menuflat",
                                      toggle: false)
        winReturnButton.action = returnToMenu
        winReturnButton.position = CGPoint(x: 0, y: 40)
        winReturnButton.zPosition = 3

        winPopup.addChild(winReturnButton)
        losePopup.addChild(loseReturnButton)
        
        // menu setup
        inGameMenu = Menu(screenHeight: frame.size.height,
                          screenWidth: frame.size.width)
        inGameMenu.position = CGPoint(x: ((frame.size.width / 3) * 2),
                                      y: 0)
        camera!.addChild(inGameMenu)
        inGameMenu.zPosition = 1
        
        // button returning to main menu
        let returnButton = Button(defaultButtonImage: "menu",
                                    activeButtonImage: "menuflat",
                                    toggle: false)
        returnButton.action = returnToMenu
        returnButton.position = CGPoint(x: 0,
                                        y: -40)
        inGameMenu.addChild(returnButton)
        
        // button to accesss options
        let optionsButton = Button(defaultButtonImage: "options",
                                  activeButtonImage: "optionsflat",
                                  toggle: false)
        optionsButton.action = options
        optionsButton.position = CGPoint(x: 0,
                                        y: 40)
        inGameMenu.addChild(optionsButton)
        
        // prep for swipe detection
        let leftRecognizer = UISwipeGestureRecognizer(target: self,
                                                      action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        self.view!.addGestureRecognizer(leftRecognizer)
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self,
                                                       action: #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view!.addGestureRecognizer(rightRecognizer)
        
        // physics contact delegate
        physicsWorld.contactDelegate = self
        
        // iterates through sks nodes and runs the neccesary functions based on class
        scene?.enumerateChildNodes(withName: "MazeWall") {
            (node, stop) in
            let mazeNode = node as? MazeWall
            mazeNode?.setWallPhysics()
        }
        scene?.enumerateChildNodes(withName: "item") {
            (node, stop) in
            let itemNode = node as? Item
            itemNode?.itemInit()
            itemCount += 1
        }
        scene?.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            let enemy = node as? Enemy
            enemy?.enemyInit()
        }
        
        // player-----------------------------------------------------------------------------------------------------------
        
        player = SKSpriteNode(imageNamed: "RedFront")
        player.position = CGPoint(x: 0,
                                  y: 0)
        player.name = "player"
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width,
                                                               height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.mass = 0.8
        player.physicsBody?.restitution = 0
        player.physicsBody?.contactTestBitMask = 0x00000001
        
        player.isHidden = true
        
        worldNode.addChild(player)
        
        // popups------------------------------------------------------------------------------------------------------------
        
        camera!.addChild(itemPopup)
        camera!.addChild(optionsPopup)
        
        // accelerometer data--------------------------------------------------------------------------------------------
        
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.01
            manager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                //records tilt along x axis once, when start button is pressed
                if (preferredTilt == nil) && (started == true) {
                    
                    preferredTilt = data.acceleration.x
                    print("INIT: Preferred tilt angle is \(Int(preferredTilt! * 90))°")
                    //0° is flat, 90° is vertical
                }
                
                if started == true {
                    let dataXAdjusted = -data.acceleration.x + preferredTilt!
//                    flat = 0, forward is +, back is -
//                    when you tilt foward it goes up to 1 when vertical, then past it it goes down from 1 (still pos)
//                    when you tilt back it goes up to -1 when vertical, then past it it goes down from -1 (still neg)
                    
                    // tilt moves, X
                    if (data.acceleration.y > 0.06 ||
                        data.acceleration.y < -0.06) {
                        
                        // RIGHT
                        if (data.acceleration.y > 0.06) && (data.acceleration.y < 0.4) {
                            destX = CGFloat((data.acceleration.y) * 800) // right speed
                            playerXDirection = "right"
                        }
                        if (data.acceleration.y > 0.4){
                            print("right cap hit")
                            destX = CGFloat(0.4 * 800) // max right speed
                            playerXDirection = "right"
                        }
                        // LEFT
                        if (data.acceleration.y < -0.06) && (data.acceleration.y > -0.4) {
                            destX = CGFloat((data.acceleration.y) * 800) // left speed
                            playerXDirection = "left"
                        }
                        if (data.acceleration.y < -0.4){
                            print("left cap hit")
                            destX = CGFloat(-0.4 * 800) // max left speed
                            playerXDirection = "left"
                        }
                    }
                        
                    // tilt doesn't move, X
                    else {
                        destX = CGFloat(0)
                        playerXDirection = "still"
                    }
                    
                    // tilt moves, Y
                    if (dataXAdjusted > 0.06) ||
                        (dataXAdjusted < -0.06) {
        
                        // UP
                        if (dataXAdjusted > 0.06) && (dataXAdjusted < 0.4) {
                            destY = CGFloat(dataXAdjusted * 800) // up speed
                            playerYDirection = "up"
                        }
                        if (dataXAdjusted > 0.4) {
                            print("forward cap hit")
                            destY = CGFloat(0.4 * 800) // max up speed
                            playerYDirection = "up"
                        }
                        // DOWN
                        if (dataXAdjusted < -0.06) && (dataXAdjusted > -0.4) {
                            destY = CGFloat(dataXAdjusted * 1000) // down speed
                            //(this is faster because tilting down moves the screen out of the player's view
                            playerYDirection = "down"
                        }
                        if (dataXAdjusted < -0.4) {
                            print("backward cap hit")
                            destY = CGFloat(-0.4 * 1000) // max down speed
                            playerYDirection = "down"
                        }
                        
                    }
                        
                    // tilt doesn't move, Y
                    else {
                        destY = CGFloat(0)
                        playerYDirection = "still"
                    }
                }
                    
                // tilt cannot move player before start button is pressed
                else if started == false {
                    destX = CGFloat(0)
                    destY = CGFloat(0)
                }
            }
        }
    }
    
    // triggers when a swipe is detected------------------------------------------------------------------------------------
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        //menu in and out (origin of menu object is at 0,0 not at the origin of the rectangle)
        let enterAction = SKAction.moveTo(x: (frame.size.width / 3),
                                          duration: 0.5)
        let leaveAction = SKAction.moveTo(x: ((frame.size.width / 3) * 2),
                                          duration: 0.5)
        if (inGameMenu.isPaused == false) && (started == true) {
            if sender.direction == .left {
                print("MENU: left swipe")
                    inGameMenu.run(enterAction)
                    menuOut = true
                    pause()
            }
            if sender.direction == .right{
                print("MENU: right swipe")
                    inGameMenu.run(leaveAction)
                    menuOut = false
                    play()
            }
        }
    }
    
    
    // collision detection------------------------------------------------------------------------------------------------
    
    func didBegin(_ contact: SKPhysicsContact){
        
        func describeCollision(contactA: SKPhysicsBody,
                               contactB: SKPhysicsBody) {
            
            print("COLLISION: \n  bodyA is \(contactA.node?.name! ?? "unidentified")\n  bodyB is \(contactB.node?.name! ?? "unidentified")")
            print(type(of: contactA.node!))
            print(type(of: contactB.node!))
        }

        if (contact.bodyA.node != nil) &&
            (contact.bodyB.node != nil) {
            
            let aNode = contact.bodyA.node
            let bNode = contact.bodyB.node
            let aName = aNode?.name
            let bName = bNode?.name

//            describeCollision(contactA: contact.bodyA,
//                              contactB: contact.bodyB)
            
            // player collision with wall
            if (bName == "player") &&
                (aNode is MazeWall) {
//                print("player collided with wall")
                }
            
            // player touches an enemy (can be initiated by either body)
            if ((bName == "player") && (aNode is Enemy)) ||
                ((bNode is Enemy) && (aName == "player")) {
                playerHealth -= 1
                // TODO: play sound & vibration
                // sfx()
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                print("COLLISION: player touched enemy, health = \(playerHealth)")
                
                //lose condition (may need to be moved later)
                if playerHealth <= 0 {
                    playerAlive = false
                    print("COLLISION: player died")
                    
                    camera!.addChild(losePopup)
                    losePopup.visible()
                    pause(inGameMenu)
                }
                
                let rebound = 300
                let goLeft = SKAction.applyImpulse(CGVector(dx: -rebound, dy: 0), duration: 0.1)
                let goRight = SKAction.applyImpulse(CGVector(dx: rebound, dy: 0), duration: 0.1)
                let goUp = SKAction.applyImpulse(CGVector(dx: 0, dy: rebound), duration: 0.1)
                let goDown = SKAction.applyImpulse(CGVector(dx: 0, dy: -rebound), duration: 0.1)
                
                // enemy & player will only bounce off of each other vertical or horizontal,
                // based off of whether the difference in y position or x position is greater
                if (abs(aNode!.position.x - bNode!.position.x) > abs(aNode!.position.y - bNode!.position.y)) {
                // x diff > y diff
                    if (aNode!.position.x < bNode!.position.x) {
                        aNode!.run(goLeft)
                        bNode!.run(goRight)
                        print("ENEMY: rebound left")
                    }
                    if (aNode!.position.x > bNode!.position.x) {
                        aNode!.run(goRight)
                        bNode!.run(goLeft)
                        print("ENEMY: rebound right")
                    }
                }
                if (abs(aNode!.position.y - bNode!.position.y) > abs(aNode!.position.x - bNode!.position.x)) {
                // y diff > x diff
                    if (aNode!.position.y < bNode!.position.y) {
                        aNode!.run(goDown)
                        bNode!.run(goUp)
                        print("ENEMY: rebound down")
                    }
                    if (aNode!.position.y > bNode!.position.y) {
                        aNode!.run(goUp)
                        bNode!.run(goDown)
                        print("ENEMY: rebound up")
                    }
                }
            }
            // item collision (currently can be initiated by either body, because items may move)
            if ((bName == "player") && (aNode! is Item)) || ((aName == "player") && (bNode! is Item)) {
                if aNode! is Item {
                    aNode!.removeFromParent()
                }
                if bNode! is Item {
                    bNode!.removeFromParent()
                }
                print("COLLSION: item")
                
                playerItems += 1
                itemPopupOut = true
                itemPopup.itemName.text = bName
                itemPopup.visible()
                pause(inGameMenu)
                
                if playerItems >= 5 {
                    playerWon = true
                }
            }
        }
    }
   
    // called on the end of a touch-------------------------------------------------------------------------------------------
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {


        for touch in touches {
            let location = touch.location(in: self)
            
            if optionsPopupOut == true {
                if !(optionsPopup.popupNode.contains(location)) {
                    optionsPopupOut = false
                    optionsPopup.invisible()
                    inGameMenu.isPaused = false
                }
            }
           
            if itemPopupOut == true {
                if !(itemPopup.popupNode.contains(location)) {
                    itemPopupOut = false;
                    itemPopup.invisible();
                    play(inGameMenu)
                }
            }
        }
    }
    
    // called every frame when not paused-----------------------------------------------------------------------------------
    
    override func didSimulatePhysics() {
        //camera follows player sprite
        camera?.position.x = player.position.x
        camera?.position.y = player.position.y
        
        // texture changes for the direction the player character is facing, will be used for animation
        // TODO: add "still" positions
        if playerYDirection == "up"{
            player.run(away)
            
            if playerXDirection == "left"{
                //player.run(away)
            }
            if playerXDirection == "right"{
                //player.run(away)
            }
        }
        if playerYDirection == "down"{
            player.run(towards)
            
            if playerXDirection == "left"{
                //player.run(towards)
            }
            if playerXDirection == "right"{
                //player.run(towards)
            }
        }
    }
    
    
    // called every frame--------------------------------------------------------------------------------------------------
    
    override func update(_ currentTime: TimeInterval) {
        
        healthLabel.text = String(playerHealth)
        itemLabel.text = "\(String(playerItems))/\(String(itemCount))"
        
        // player movement based on tilt
        player.physicsBody!.velocity = CGVector(dx: destX,
                                                dy: destY)

        if started == true {
            scene?.enumerateChildNodes(withName: "enemy") {
                (node, stop) in
                let enemy = node as? Enemy
                enemy?.pathfinding(playerNode: player,
                                   currentScene: self,
                                   character: character,
                                   ability: abilityActive)
            }
            scene?.enumerateChildNodes(withName: "item") {
                (node, stop) in
                let itemNode = node as? Item
                itemNode?.attract(character: character,
                                  ability: abilityActive,
                                  playerNode: player)
            }
        }
        
        if itemPopupOut == false && playerWon == true {
            if winPopupOut == false {
                winPopupOut = true
                camera!.addChild(winPopup)
                winPopup.visible()
                pause(inGameMenu)
            }
        }
    }
}
