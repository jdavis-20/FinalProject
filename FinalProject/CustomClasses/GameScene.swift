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
var itemPopup = Popup(image: "popup", type: "item", worldNode: worldNode)
var optionsPopup = Popup(image: "popup", type: "options", worldNode: worldNode)
var charSelPopup = Popup(image: "popup", type: "charsel", worldNode: worldNode)
var winPopup = Popup(image: "popup", type: "win", worldNode: worldNode)
var losePopup = Popup(image: "popup", type: "lose", worldNode: worldNode)

// orientation
var preferredTilt: Double?
var destX: CGFloat = 0.0
var destY: CGFloat = 0.0

// game state values
var started = false

var character = ""
public var playerHealth: Int = 10
public var playerItems: Int = 0
var healthLabel = SKLabelNode(text: String(10))
var itemLabel = SKLabelNode(text: String(0))

var playerAlive = true
var playerWon = false
var playerYDirection = "up"
var playerXDirection = "still"
var enemyInit = false

var menuOut = true
var itemPopupOut = false
var optionsPopupOut = true
var charSelOut = true
var losePopupOut = false
var winPopupOut = false
var abilityActive = false

// movement and animation
let path = UIBezierPath()
let away = SKAction.setTexture(SKTexture(imageNamed: "BlueFront"))
let towards = SKAction.setTexture(SKTexture(imageNamed: "RedFront"))


//  this is the superclass to all game levels----------------------------------------------------------------------------------
// it contains fundamental mechanics and nodes that need to persist across levels----------------------------------------

class GameScene: SKScene, SKPhysicsContactDelegate {

    func startGame(){
        // started variable sets tilt and other attributes, signals gameplay start
        started = true
        charSelPopup.invisible()
        physicsWorld.speed = 1
        inGameMenu.isPaused = false
        character = charSelPopup.character
        print("CHARACTER: \(character)")
        
        // print(inGameMenu.position)
        
        // TODO: vibration response
        // AudioServicesPlaySystemSound(1520)
        // AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    //button on the in-game menu-------------------------------------------------------
    
    func returnToMenu(){
        print("MENU: main menu button pressed")
        let menuScene = SKScene(fileNamed: "MenuScene")
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(menuScene!, transition: transition)

        worldNode.removeAllChildren()

        camera!.removeAllChildren()
        
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    func options(){
        print("MENU: options button pressed")
        physicsWorld.speed = 0
        optionsPopup.visible()
        inGameMenu.isPaused = true
        optionsPopupOut = true
    }
    
    //executes when the scene is first loaded------------------------------------------------------------------------------
    
    override func didMove(to view: SKView) {
        // scaling options to see more of view at once
        camera!.setScale(1.5)
        let zoomOut = SKAction.scale(by: 1.5, duration: 1.2)
        camera!.run(zoomOut)
        
        // any values that need to be reset at the start of the level
        playerHealth = 10
        playerItems = 0
        
        // only nodes that are children of worldNode will be paused
        // this is so menus still work after they are opened
        preferredTilt = nil
        addChild(worldNode)
        started = false
        
        // creates character select popup at the start of the level
        camera!.addChild(charSelPopup)
        charSelPopup.visible()
        charSelOut = true
        worldNode.isPaused = true
        inGameMenu.isPaused = true
        physicsWorld.speed = 0
        
        // set tilt and start moving
        let startButton = Button(defaultButtonImage: "button",
                                 activeButtonImage: "button_active",
                                 label: "start")
        startButton.action = startGame
        startButton.position = CGPoint(x: 0,
                                       y: -80)
        startButton.zPosition = 3
        charSelPopup.addChild(startButton)
        
        // add health and item counters to HUD
        healthLabel.position = CGPoint(x: -frame.size.width/2.2 , y: frame.size.height/2.5)
        camera!.addChild(healthLabel)
        
        itemLabel.position = CGPoint(x: -frame.size.width/2.5 , y: frame.size.height/2.5)
        camera!.addChild(itemLabel)
        
        // button to return to menu after win/lose
        let loseReturnButton = Button(defaultButtonImage: "button",
                                 activeButtonImage: "button_active",
                                 label: "return to menu")
        loseReturnButton.action = returnToMenu
        loseReturnButton.position = CGPoint(x: 0, y: 40)
        loseReturnButton.zPosition = 2
        let winReturnButton = Button(defaultButtonImage: "button",
                                      activeButtonImage: "button_active",
                                      label: "return to menu")
        winReturnButton.action = returnToMenu
        winReturnButton.position = CGPoint(x: 0, y: 40)
        winReturnButton.zPosition = 2

        winPopup.addChild(winReturnButton)
        losePopup.addChild(loseReturnButton)
        
        // menu setup
        inGameMenu = Menu(screenHeight: frame.size.height,
                          screenWidth: frame.size.width)
        inGameMenu.position = CGPoint(x: ((frame.size.width / 3) * 2), y: 0)
        camera!.addChild(inGameMenu)
        inGameMenu.zPosition = 1
        
        // button returning to main menu
        let returnButton = Button(defaultButtonImage: "button",
                                    activeButtonImage: "button_active",
                                    label: "main menu")
        returnButton.action = returnToMenu
        returnButton.position = CGPoint(x: 0,
                                        y: -40)
        inGameMenu.addChild(returnButton)
        
        // button to accesss options
        let optionButton = Button(defaultButtonImage: "button",
                                  activeButtonImage: "button_active",
                                  label: "options")
        optionButton.action = options
        optionButton.position = CGPoint(x: 0,
                                        y: 40)
        inGameMenu.addChild(optionButton)
        
        camera!.addChild(optionsPopup)
        
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
        
        // finds nodes with a specific name and sets the physics for them as walls
        scene?.enumerateChildNodes(withName: "MazeWall") {
            (node, stop) in
            let mazeNode = node as? MazeWall
            mazeNode?.setWallPhysics()
        }
        scene?.enumerateChildNodes(withName: "item") {
            (node, stop) in
            let itemNode = node as? Item
            itemNode?.itemInit()
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
        
        worldNode.addChild(player)
        
        // popup test----------------------------------------------------------------------------------------------------------
        
        itemPopup = Popup(image: "button", type: "item", worldNode: worldNode)
        
        camera!.addChild(itemPopup)
        
        // enemy---------------------------------------------------------------------------------------------------------
        
        scene?.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            let enemy = node as? Enemy
            enemy?.enemyInit()
        }
        
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
//                    flat = 0, forward is +, back is -
//                    when you tilt foward it goes up to 1 when vertical, then past it it goes down from 1 (still pos)
//                    when you tilt back it goes up to -1 when vertical, then past it it goes down from -1 (still neg)
                    
                    // tilt moves, X
                    if (data.acceleration.y > 0.06 ||
                        data.acceleration.y < -0.06) {
                        
                        destX = CGFloat((data.acceleration.y) * 600) // left and right speed
                        // RIGHT
                        if (data.acceleration.y > 0.06){
                            playerXDirection = "right"
                        }
                        // LEFT
                        if (data.acceleration.y < -0.06){
                            playerXDirection = "left"
                        }
                    }
                        
                    // tilt doesn't move, X
                    else {
                        destX = CGFloat(0)
                        playerXDirection = "still"
                    }
                    
                    // tilt moves, Y
                    if ((-data.acceleration.x + preferredTilt!) > 0.06 ||
                        (-data.acceleration.x + preferredTilt!) < -0.06) {
                        
                        // UP
                        if ((-data.acceleration.x + preferredTilt!) > 0.06) {
                            destY = CGFloat((-data.acceleration.x + preferredTilt!) * 600) // up speed
                            playerYDirection = "up"
                        }
                        // DOWN
                        if ((-data.acceleration.x + preferredTilt!) < -0.06) {
                            destY = CGFloat((-data.acceleration.x + preferredTilt!) * 800) // down speed
                            //(this is faster because tilting down moves the screen out of the player's view
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
                    worldNode.isPaused = true
                    physicsWorld.speed = 0
                    menuOut = true
            }
            if sender.direction == .right{
                print("MENU: right swipe")
                    inGameMenu.run(leaveAction)
                    worldNode.isPaused = false
                    physicsWorld.speed = 1
                    menuOut = false
            }
        }
    }
    
    
    // collision detection------------------------------------------------------------------------------------------------
    
    func didBegin(_ contact: SKPhysicsContact){
        
        func describeCollision(contactA: SKPhysicsBody,
                               contactB: SKPhysicsBody) {
            
//            print("COLLISION: \n  bodyA is \(contactA.node?.name! ?? "unidentified")\n  bodyB is \(contactB.node?.name! ?? "unidentified")")
//            print(type(of: contactA.node!))
//            print(type(of: contactB.node!))
        }
        // prints the names of bodies involved in a collision
        if (contact.bodyA.node != nil) &&
            (contact.bodyB.node != nil) {
            
            let aName = contact.bodyA.node?.name
            let bName = contact.bodyB.node?.name
            let aNode = contact.bodyA.node
            let bNode = contact.bodyB.node
            
            describeCollision(contactA: contact.bodyA,
                              contactB: contact.bodyB)
            
            // player collision with wall
            if (bName == "player") &&
                (aNode is MazeWall) {
//                print("player collided with wall")
                }
            
            // player touches an enemy (can be initiated by either body)
            if ((bName == "player") && (aNode is Enemy)) ||
                ((bNode is Enemy) && (aName == "player")) {
                playerHealth -= 1
                print("COLLISION: player touched enemy, health = \(playerHealth)")
                //death condition (may need to be moved later)
                if playerHealth <= 0 {
                    playerAlive = false
                    print("COLLISION: player died")
                    
                    camera!.addChild(losePopup)
                    losePopup.visible()
                    physicsWorld.speed = 0
                    inGameMenu.isPaused = true
                }
                
                let rebound = 300
                let goLeft = SKAction.applyImpulse(CGVector(dx: -rebound, dy: 0), duration: 0.1)
                let goRight = SKAction.applyImpulse(CGVector(dx: rebound, dy: 0), duration: 0.1)
                let goUp = SKAction.applyImpulse(CGVector(dx: 0, dy: rebound), duration: 0.1)
                let goDown = SKAction.applyImpulse(CGVector(dx: 0, dy: -rebound), duration: 0.1)
                
                // enemy & player will only bounce off of each other vertical or horizontal,
                // based off of whether the difference in y position or x position is greater
                if (abs(aNode!.position.x - bNode!.position.x) > abs(aNode!.position.y - bNode!.position.y)) {
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
            if ((bName == "player") && (aNode! is Item)) {
                print("COLLISION: item")
                aNode!.removeFromParent()
                
                playerItems += 1
                itemPopupOut = true
                itemPopup.itemName.text = aName
                itemPopup.visible()
                physicsWorld.speed = 0
                
                if playerItems >= 5 {
                    playerWon = true
                }
                
            }
            if ((aName == "player") && (bNode! is Item)) {
                print("COLLSION: item")
                bNode!.removeFromParent()
                
                playerItems += 1
                itemPopupOut = true
                itemPopup.itemName.text = bName
                itemPopup.visible()
                physicsWorld.speed = 0
                
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
                    physicsWorld.speed = 1
                }
            }
        }
    }
    
    // called every frame when not paused-----------------------------------------------------------------------------------
    
    override func didSimulatePhysics() {
        //camera follows player sprite
        camera?.position.x = player.position.x
        camera?.position.y = player.position.y
        
        // texture changes for the direction the player character is facing
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
        itemLabel.text = String(playerItems)
        
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
                physicsWorld.speed = 0
                inGameMenu.isPaused = true
            }
        }
    }
}
