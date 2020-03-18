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

// core nodes
var worldNode = SKNode()
var camera = SKCameraNode()
var motionManager = CMMotionManager()
var player = SKSpriteNode()

// menus and popups
var slideMenu =  Menu(screenHeight: 375,
                       screenWidth: 667)
var itemPopup = Popup(image: "pop", type: "item", worldNode: worldNode)
var optionsPopup = Popup(image: "pop", type: "options", worldNode: worldNode)
var charSelPopup = Popup(image: "pop", type: "charsel", worldNode: worldNode)
var winPopup = Popup(image: "pop", type: "win", worldNode: worldNode)
var losePopup = Popup(image: "pop", type: "lose", worldNode: worldNode)

var slideMenuOut = true
var itemPopupOut = false
var optionsPopupOut = true
var charSelOut = true
var losePopupOut = false
var winPopupOut = false

// orientation
var playerTilt: Double?
var xVelocity: CGFloat = 0.0
var yVelocity: CGFloat = 0.0

// game state values
var startPressed = false
var playerAlive = true
var playerWon = false
var enemyInit = false
var abilityActive = false
var vibrateOn = true

var charChoice = ""
var playerYDirection = "up"
var playerXDirection = "still"

var playerHealth: Int = 10
var playerItems: Int = 0
var totalItems = 0
var abilityTimerSeconds = 10
var abilityUses = 3

var sfxVol: Float = 1
var musicVol: Float = 1

// HUD labels
var healthLabel = SKLabelNode(text: String(10))
var itemLabel = SKLabelNode(text: String(0))
var abilityTimerLabel = SKLabelNode(text: String(10))

var abilityTimer = Timer()

// movement and animation
let moveInFrame = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0)
let moveOutOfFrame = SKAction.move(to: CGPoint(x: 4000, y: 7000), duration: 0)
let away = SKAction.setTexture(SKTexture(imageNamed: "BlueFront"))
let towards = SKAction.setTexture(SKTexture(imageNamed: "RedFront"))


// gamescene is the superclass to all game levels-----------------------------------------------------------------------------
// it contains the fundamental mechanics and nodes that need to persist across levels--------------------------------------

class GameScene: SKScene, SKPhysicsContactDelegate {

    func startGame(){
        charChoice = charSelPopup.character
        print("CHARACTER: \(charChoice)")
        if charChoice != "" {
            // this bool signals the start of gameplay to tilt, menu, and item/enemy class actions
            startPressed = true
            player.isHidden = false
            charSelPopup.invisible()
            charSelPopup.run(moveOutOfFrame)
            play(slideMenu)
        }
    }
    
    func pause(_ node: SKNode? = nil){
        worldNode.isPaused = true
        node?.isPaused = true
        physicsWorld.speed = 0
        if abilityActive == true {
            abilityTimer.invalidate()
        }
    }
    func play(_ node: SKNode? = nil) {
        worldNode.isPaused = false
        node?.isPaused = false
        physicsWorld.speed = 1
        if abilityActive == true {
            abilityTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    func sfx(_ file: String, vibrate: Bool = true) {
        let sound = SKAction.playSoundFileNamed(file, waitForCompletion: false)
        SKAction.changeVolume(to: sfxVol, duration: 0)
        self.run(sound)
        // TODO: vibration response
        if vibrate == true && vibrateOn == true {
            AudioServicesPlaySystemSound(1519)
//          AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    @objc func updateTimer() {
        abilityTimerSeconds -= 1
        abilityTimerLabel.text = String(abilityTimerSeconds)
        print("ABILITY: \(abilityTimerSeconds) seconds left")
        if abilityTimerSeconds < 1 {
            print("ABILITY: time is up")
            abilityActive = false
            abilityTimer.invalidate()
            abilityTimerLabel.removeFromParent()
            abilityTimerSeconds = 10
            abilityTimerLabel.text = String(abilityTimerSeconds)
        }
    }
    
    //buttons on the in-game menu-------------------------------------------------------
    
    func returnToMenu(){
        print("MENU: main menu button pressed")
        let menuScene = SKScene(fileNamed: "MenuScene")
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(menuScene!, transition: transition)

        abilityTimer.invalidate()
        
        worldNode.removeAllChildren()
        camera!.removeAllChildren()
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    func options(){
        print("MENU: options button pressed")
        optionsPopup.run(moveInFrame)
        optionsPopup.visible()
        optionsPopupOut = true
        pause(slideMenu)
    }
    
    //executes when the scene is first loaded------------------------------------------------------------------------------
    
    override func didMove(to view: SKView) {
        // scaling the view
        camera!.setScale(1.5)
        let zoomOut = SKAction.scale(by: 1.5, duration: 1.2)
        camera!.run(zoomOut)
        
        // values that need to be reset at the start of a new level
        charSelPopup.character = ""
        abilityTimerSeconds = 10
        abilityTimerLabel.text = String(abilityTimerSeconds)
        abilityActive = false
        playerTilt = nil
        startPressed = false
        abilityUses = 3
        playerHealth = 10
        playerItems = 0
        totalItems = 0
        
        charSelPopup.run(moveInFrame)
        optionsPopup.run(moveOutOfFrame)
        itemPopup.run(moveOutOfFrame)
        winPopup.run(moveOutOfFrame)
        losePopup.run(moveOutOfFrame)
        
        // only nodes that are children of worldNode will be paused
        // allows menus to work after they are opened
        addChild(worldNode)
        
        // creates character select popup at the start of the level
        camera!.addChild(charSelPopup)
        charSelPopup.visible()
        charSelOut = true
        pause(slideMenu)
        
        for button in [charSelPopup.char1button, charSelPopup.char2button, charSelPopup.char3button] {
        button.activeButton.isHidden = true
        button.defaultButton.isHidden = false
        }
        
        // add health and item counters to HUD
        healthLabel.position = CGPoint(x: -frame.size.width/2.2 , y: frame.size.height/2.5)
        camera!.addChild(healthLabel)
        
        itemLabel.position = CGPoint(x: -frame.size.width/2.6 , y: frame.size.height/2.5)
        camera!.addChild(itemLabel)
        
        abilityTimerLabel.position = CGPoint(x: 0, y: frame.size.height/2.3)
        abilityTimerLabel.fontSize = 26
        abilityTimerLabel.fontColor = .red
        abilityTimerLabel.fontName = "Arial-BoldMT"
        
        // button actions
        // return to menu after win/lose
        losePopup.loseReturnButton.action = returnToMenu
        winPopup.winReturnButton.action = returnToMenu
        // set tilt and start moving
        charSelPopup.startButton.action = startGame

        // menu setup
        slideMenu = Menu(screenHeight: frame.size.height,
                          screenWidth: frame.size.width)
        slideMenu.position = CGPoint(x: ((frame.size.width / 3) * 2),
                                      y: 0)
        camera!.addChild(slideMenu)
        slideMenu.zPosition = 1
        
        // button returning to main menu
        let returnButton = Button(defaultButtonImage: "menu",
                                    activeButtonImage: "menuflat",
                                    toggle: false)
        returnButton.action = returnToMenu
        returnButton.position = CGPoint(x: 0,
                                        y: -40)
        slideMenu.addChild(returnButton)
        
        // button to accesss options
        let optionsButton = Button(defaultButtonImage: "options",
                                  activeButtonImage: "optionsflat",
                                  toggle: false)
        optionsButton.action = options
        optionsButton.position = CGPoint(x: 0,
                                        y: 40)
        slideMenu.addChild(optionsButton)
        
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
            totalItems += 1
        }
        scene?.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            let enemy = node as? Enemy
            enemy?.enemyInit()
        }
        
        // player-----------------------------------------------------------------------------------------------------------
        
        player = SKSpriteNode(imageNamed: "RedFront")
        player.position = CGPoint(x: 0, y: 0)
        player.name = "player"
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width,
                                                               height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.isDynamic = true
        
        player.physicsBody?.mass = 0.8
        player.physicsBody?.restitution = 0
        player.physicsBody?.contactTestBitMask = 0x00000001
        
        // hidden until start is pressed for cleaner appearance
        player.isHidden = true
        
        worldNode.addChild(player)
        
        // popups------------------------------------------------------------------------------------------------------------
        
        itemPopup.invisible()
        camera!.addChild(itemPopup)
        optionsPopup.invisible()
        camera!.addChild(optionsPopup)
        
        // accelerometer data--------------------------------------------------------------------------------------------
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                //records tilt along x axis once, when start button is pressed
                if (playerTilt == nil) && (startPressed == true) {
                    
                    playerTilt = data.acceleration.x
                    print("INIT: Preferred tilt angle is \(Int(playerTilt! * 90))°")
                    //0° is flat, 90° is vertical
                }
                
                if (startPressed == true) {
                    let dataXAdjusted = -data.acceleration.x + playerTilt!
//                  flat = 0, forward is +, back is -
//                  tilt foward goes up to 1 fully vertical, past it goes back from 1
//                  tilt back goes up to -1 fully vertical, past it goes back from -1
                    
                    // tilt moves, X
                    if (data.acceleration.y > 0.06 ||
                        data.acceleration.y < -0.06) {
                        
                        // RIGHT
                        if (data.acceleration.y > 0.06) && (data.acceleration.y < 0.4) {
                            xVelocity = CGFloat((data.acceleration.y) * 800) // right speed
                            playerXDirection = "right"
                        }
                        if (data.acceleration.y > 0.4){
//                            print("right cap hit")
                            xVelocity = CGFloat(0.4 * 800) // max right speed
                            playerXDirection = "right"
                        }
                        // LEFT
                        if (data.acceleration.y < -0.06) && (data.acceleration.y > -0.4) {
                            xVelocity = CGFloat((data.acceleration.y) * 800) // left speed
                            playerXDirection = "left"
                        }
                        if (data.acceleration.y < -0.4){
//                            print("left cap hit")
                            xVelocity = CGFloat(-0.4 * 800) // max left speed
                            playerXDirection = "left"
                        }
                    }
                        
                    // tilt doesn't move, X
                    else {
                        xVelocity = CGFloat(0)
                        playerXDirection = "still"
                    }
                    
                    // tilt moves, Y
                    if (dataXAdjusted > 0.06) ||
                        (dataXAdjusted < -0.06) {
        
                        // UP
                        if (dataXAdjusted > 0.06) && (dataXAdjusted < 0.4) {
                            yVelocity = CGFloat(dataXAdjusted * 800) // up speed
                            playerYDirection = "up"
                        }
                        if (dataXAdjusted > 0.4) {
//                            print("forward cap hit")
                            yVelocity = CGFloat(0.4 * 800) // max up speed
                            playerYDirection = "up"
                        }
                        // DOWN
                        if (dataXAdjusted < -0.06) && (dataXAdjusted > -0.4) {
                            yVelocity = CGFloat(dataXAdjusted * 1000) // down speed
                            // is faster because tilting down moves the screen out of the player's view
                            playerYDirection = "down"
                        }
                        if (dataXAdjusted < -0.4) {
//                            print("backward cap hit")
                            yVelocity = CGFloat(-0.4 * 1000) // max down speed
                            playerYDirection = "down"
                        }
                        
                    }
                        
                    // tilt doesn't move, Y
                    else {
                        yVelocity = CGFloat(0)
                        playerYDirection = "still"
                    }
                }
                    
                // tilt cannot move player before start button is pressed
                else if startPressed == false {
                    xVelocity = CGFloat(0)
                    yVelocity = CGFloat(0)
                }
            }
        }
    }
    
    // triggers when a swipe is detected------------------------------------------------------------------------------------
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        //menu in and out (origin of menu object is at 0,0 not at the origin of the rectangle)
        let menuEnter = SKAction.moveTo(x: (frame.size.width / 3), duration: 0.5)
        let menuLeave = SKAction.moveTo(x: ((frame.size.width / 3) * 2), duration: 0.5)
        if (slideMenu.isPaused == false) && (startPressed == true) {
            if sender.direction == .left {
                print("MENU: left swipe")
                    slideMenu.run(menuEnter)
                    slideMenuOut = true
                    pause()
            }
            if sender.direction == .right{
                print("MENU: right swipe")
                    slideMenu.run(menuLeave)
                    slideMenuOut = false
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
            
            // PLAYER-ENEMY
            if ((bName == "player") && (aNode is Enemy)) ||
                ((aName == "player") && (bNode is Enemy)) {
                playerHealth -= 1
                // TODO: play sound & vibration
                // sfx("filename")
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                print("COLLISION: player touched enemy, health = \(playerHealth)")
                
                // lose condition
                if playerHealth <= 0 {
                    playerAlive = false
                    print("COLLISION: player died")
                    
                    camera!.addChild(losePopup)
                    losePopup.run(moveInFrame)
                    losePopup.visible()
                    pause(slideMenu)
                }
                
                let reboundImpulse = 300
                let reboundLeft = SKAction.applyImpulse(CGVector(dx: -reboundImpulse, dy: 0), duration: 0.1)
                let reboundRight = SKAction.applyImpulse(CGVector(dx: reboundImpulse, dy: 0), duration: 0.1)
                let reboundUp = SKAction.applyImpulse(CGVector(dx: 0, dy: reboundImpulse), duration: 0.1)
                let reboundDown = SKAction.applyImpulse(CGVector(dx: 0, dy: -reboundImpulse), duration: 0.1)
                
                // enemy & player will rebound only vertical or horizontal,
                // whichever difference in position is greater
                if (abs(aNode!.position.x - bNode!.position.x) > abs(aNode!.position.y - bNode!.position.y)) {
                // x diff > y diff
                    if (aNode!.position.x < bNode!.position.x) {
                        aNode!.run(reboundLeft)
                        bNode!.run(reboundRight)
                        print("ENEMY: rebound left")
                    }
                    if (aNode!.position.x > bNode!.position.x) {
                        aNode!.run(reboundRight)
                        bNode!.run(reboundLeft)
                        print("ENEMY: rebound right")
                    }
                }
                if (abs(aNode!.position.y - bNode!.position.y) > abs(aNode!.position.x - bNode!.position.x)) {
                // y diff > x diff
                    if (aNode!.position.y < bNode!.position.y) {
                        aNode!.run(reboundDown)
                        bNode!.run(reboundUp)
                        print("ENEMY: rebound down")
                    }
                    if (aNode!.position.y > bNode!.position.y) {
                        aNode!.run(reboundUp)
                        bNode!.run(reboundDown)
                        print("ENEMY: rebound up")
                    }
                }
            }
            
            // PLAYER-ITEM
            if ((bName == "player") && (aNode! is Item)) ||
                ((aName == "player") && (bNode! is Item)) {
                if aNode! is Item {
                    aNode!.removeFromParent()
                }
                if bNode! is Item {
                    bNode!.removeFromParent()
                }
                print("COLLSION: player got item, item count is \(totalItems)")
                
                playerItems += 1
                itemPopupOut = true
                itemPopup.itemName.text = bName
                itemPopup.run(moveInFrame)
                itemPopup.visible()
                pause(slideMenu)
                
                // win condition
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
            
            // touch outside of options popup to close
            if optionsPopupOut == true && !(optionsPopup.popupNode.contains(location)) {
                    print("TOUCH: options popup closed")
                    optionsPopupOut = false
                    optionsPopup.invisible()
                    slideMenu.isPaused = false
                    optionsPopup.run(moveOutOfFrame)
            }
        
            // touch outside of item popup to close
            if itemPopupOut == true && !(itemPopup.popupNode.contains(location)) {
                    print("TOUCH: item popup closed")
                    itemPopupOut = false;
                    itemPopup.invisible();
                    play(slideMenu)
                    itemPopup.run(moveOutOfFrame)
            }
            
            // TODO: move menu nodes offscreen while hidden so they don't block tap functionality (or figure out how to include them)
            // conditions: not in a menu, gameplay begun, not already using ability, not out of uses
            if worldNode.isPaused == false && startPressed == true && abilityActive == false && abilityUses > 0 {
                abilityActive = true
                abilityUses -= 1
                abilityTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
                print("ABILITY: \(abilityUses) uses left")
                print("ABILITY: time started")
                camera!.addChild(abilityTimerLabel)
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
        itemLabel.text = "\(String(playerItems))/\(String(totalItems))"
        
        // player movement based on tilt
        player.physicsBody!.velocity = CGVector(dx: xVelocity,
                                                dy: yVelocity)

        if startPressed == true {
            scene?.enumerateChildNodes(withName: "enemy") {
                (node, stop) in
                let enemy = node as? Enemy
                enemy?.pathfinding(playerNode: player,
                                   currentScene: self,
                                   character: charChoice,
                                   ability: abilityActive)
            }
            scene?.enumerateChildNodes(withName: "item") {
                (node, stop) in
                let itemNode = node as? Item
                itemNode?.attract(character: charChoice,
                                  ability: abilityActive,
                                  playerNode: player)
            }
        }
        
        if charChoice == "Bot" && abilityActive == true {
            player.alpha = 0.5
        }
        else {
            player.alpha = 1
        }
        
        if itemPopupOut == false && playerWon == true {
            if winPopupOut == false {
                winPopupOut = true
                camera!.addChild(winPopup)
                winPopup.run(moveInFrame)
                winPopup.visible()
                pause(slideMenu)
            }
        }
    }
}
