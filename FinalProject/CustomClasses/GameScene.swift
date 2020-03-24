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
var itemPopup = Popup(type: "item", worldNode: worldNode)
var optionsPopup = Popup(type: "options", worldNode: worldNode)
var charSelPopup = Popup(type: "charsel", worldNode: worldNode)
var winPopup = Popup(type: "win", worldNode: worldNode)
var losePopup = Popup(type: "lose", worldNode: worldNode)

var charSelOut = true, slideMenuOut = true
var optionsPopupOut = false, itemPopupOut = false
var losePopupOut = false, winPopupOut = false

// orientation
var playerTilt: Double?
var xVelocity: CGFloat = 0.0
var yVelocity: CGFloat = 0.0

// game state values
var startPressed = false
var enemyInit = false
var abilityActive = false
var playerWon = false
var playerAlive = true
var vibrateOn = true

var charChoice = ""
var playerYDirection = "up"
var playerXDirection = "still"

var playerHealth: Int = 10
var playerItems: Int = 0
var totalItems = 0
var abilityTimerSeconds = 10
var abilityUses = 3
var orientationMulitplier: Double = 1

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
let appDelegate = UIApplication.shared.delegate as! AppDelegate

// TODO: needs to change based on character choice- script or set additional variables?
let awaySprite = SKAction.setTexture(SKTexture(imageNamed: "BlueFront"))
let towardsSprite = SKAction.setTexture(SKTexture(imageNamed: "RedFront"))
//let leftSprite = SKAction.setTexture(SKTexture(imageNamed: ""))
//let rightSprite = SKAction.setTexture(SKTexture(imageNamed: ""))
//let idleSprite = SKAction.setTexture(SKTexture(imageNamed: ""))


// GameScene is the superclass to all game levels-----------------------------------------------------------------------------
// it contains the fundamental mechanics and nodes that need to persist across levels--------------------------------------
class GameScene: SKScene, SKPhysicsContactDelegate {

    // starts game if a character has been chosen
    func startGame(){
        charChoice = charSelPopup.character
        print("CHARACTER: \(charChoice)")
        if charChoice != "" {
            // this bool signals the start of gameplay to tilt, menu, and item/enemy class actions
            startPressed = true
            player.isHidden = false
            charSelPopup.invisible()
            charSelPopup.run(moveOutOfFrame)
            resume(slideMenu)
        }
        // TODO: set sprites for characters
        if charChoice == "Med" {
//
//            awaySprite =
//            towardsSprite =
//            leftSprite =
//            rightSprite =
//            idleSprite =
        }
        if charChoice == "Bot" {
            
        }
        if charChoice == "Arch" {
            
        }
    }
    
    // pause and resume methods for when menus come out and leave
    func pause(_ node: SKNode? = nil){
        worldNode.isPaused = true
        node?.isPaused = true
        physicsWorld.speed = 0
        if abilityActive == true {
            abilityTimer.invalidate()
        }
    }
    func resume(_ node: SKNode? = nil) {
        worldNode.isPaused = false
        node?.isPaused = false
        physicsWorld.speed = 1
        if abilityActive == true {
            abilityTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    // method to play sounds & vibration
    func sfx(_ file: String? = nil, vibrate: Bool = true) {
        if file != nil {
            let sound = SKAction.playSoundFileNamed(file!, waitForCompletion: false)
            SKAction.changeVolume(to: sfxVol, duration: 0)
            self.run(sound)
        }
        if vibrate == true && vibrateOn == true {
//            AudioServicesPlaySystemSound(1519)
          AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    // sets the timer as needed and updates the HUD label for it
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
    
    // buttons that take the player to the main menu
    func returnToMenu(){
        print("MENU: main menu button pressed")
        let menuScene = SKScene(fileNamed: "MenuScene")
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(menuScene!, transition: transition)
    }
    
    // options button in the in-game menu
    func options(){
        print("MENU: options button pressed")
        optionsPopup.run(moveInFrame)
        optionsPopup.visible()
        optionsPopupOut = true
        pause(slideMenu)
    }
    
    func resetTilt() {
        playerTilt = motionManager.accelerometerData?.acceleration.x
        print("INIT: new tilt angle is \(Int(playerTilt! * 90))")
    }
    
    func vibOn() {
        optionsPopup.vibrateButton.buttonLabel.text = "Vibrate On"
        vibrateOn = true
    }
    func vibOff() {
        optionsPopup.vibrateButton.buttonLabel.text = "Vibrate Off"
        vibrateOn = false
    }
    
    //executes when the scene is first loaded------------------------------------------------------------------------------
    override func didMove(to view: SKView) {
        // lock rotation within levels
        if UIApplication.shared.statusBarOrientation == .landscapeLeft {
            appDelegate.restrictRotation = .landscapeLeft
        }
        if UIApplication.shared.statusBarOrientation == .landscapeRight {
            appDelegate.restrictRotation = .landscapeRight
        }
        
        // scaling the view
        camera!.setScale(3) // higher num to zoom out
        let zoomOut = SKAction.scale(by: 0.7 , duration: 1.2) // lower num to zoom in
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
        playerWon = false
        winPopupOut = false
        losePopupOut = false
        
        // only nodes that are children of worldNode will be paused
        // allows menus to work after they are opened
        addChild(worldNode)
        
        // prep for swipe detection
        let leftRecognizer = UISwipeGestureRecognizer(target: self,
                                                      action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        self.view!.addGestureRecognizer(leftRecognizer)
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self,
                                                       action: #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view!.addGestureRecognizer(rightRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapMade(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.view!.addGestureRecognizer(doubleTapRecognizer)
        
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
        
        // player hidden until start is pressed for cleaner appearance
        player.isHidden = true
        
        worldNode.addChild(player)
        
        // popups/menus------------------------------------------------------------------------------------------------------
        // moves popups into initial positions
        charSelPopup.run(moveInFrame)
        for popup in [optionsPopup, itemPopup, winPopup, losePopup] {
            popup.run(moveOutOfFrame)
            popup.invisible()
        }
        for popup in [itemPopup, optionsPopup, winPopup, losePopup, charSelPopup] {
            popup.zPosition = slideMenu.zPosition + 2
            for child in popup.children {
                if child.name != "popupNode" {
                    child.zPosition = popup.zPosition + 1
                }
                if child.name == "popupNode" {
                    child.zPosition = popup.zPosition
                }
            }
        }
        
        // slide menu setup
        slideMenu = Menu(screenHeight: frame.size.height,
                         screenWidth: frame.size.width)
        slideMenu.position = CGPoint(x: ((frame.size.width / 3) * 2),
                                     y: 0)
        camera!.addChild(slideMenu)
        slideMenu.zPosition = 1
        // button returning to main menu
        let returnButton = Button(label: "Menu")
        returnButton.action = returnToMenu
        returnButton.position = CGPoint(x: 0, y: -40)
        slideMenu.addChild(returnButton)
        
        // button to accesss options
        let optionsButton = Button(label: "Options")
        optionsButton.action = options
        optionsButton.position = CGPoint(x: 0, y: 40)
        slideMenu.addChild(optionsButton)
        
        // character select popup setup
        camera!.addChild(charSelPopup)
        // button sets tilt and start moving
        charSelPopup.startButton.action = startGame
        charSelPopup.visible()
        charSelOut = true
        pause(slideMenu)
        for button in [charSelPopup.char1button, charSelPopup.char2button, charSelPopup.char3button] {
            button.activeButton.isHidden = true
            button.defaultButton.isHidden = false
        }
        
        // item popup setup
        itemPopup.invisible()
        itemPopup.isUserInteractionEnabled = true
        camera!.addChild(itemPopup)
        // options popup setup
        optionsPopup.tiltResetButton.action = resetTilt
        optionsPopup.invisible()
        camera!.addChild(optionsPopup)
        
        optionsPopup.vibrateButton.action = vibOff
        optionsPopup.vibrateButton.altAction = vibOn
        
        // add health and item counters to HUD
        for label in [healthLabel, itemLabel, abilityTimerLabel] {
            label.fontName = "Conductive"
            label.verticalAlignmentMode = .center
        }
        healthLabel.position = CGPoint(x: -frame.size.width/2 + 25 , y: frame.size.height/2 - 20)
        camera!.addChild(healthLabel)
        itemLabel.position = CGPoint(x: -frame.size.width/2 + 85 , y: frame.size.height/2 - 20)
        camera!.addChild(itemLabel)
        abilityTimerLabel.position = CGPoint(x: 0, y: frame.size.height/2 - 20)
        abilityTimerLabel.fontSize = 26
        abilityTimerLabel.fontColor = .red
        
        // return to menu after win/lose
        losePopup.loseReturnButton.action = returnToMenu
        winPopup.winReturnButton.action = returnToMenu

        // ACCELEROMETER----------------------------------------------------------------------------------------------------
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
                    let dataXAdjusted = -data.acceleration.x + playerTilt! //* orientationMulitplier
                    
//                  flat = 0, forward is +, back is -
//                  tilt foward goes up to 1 fully vertical, past it goes back from 1
//                  tilt back goes up to -1 fully vertical, past it goes back from -1
                    
                    // tilt moves, X
                    if (data.acceleration.y > 0.06 ||
                        data.acceleration.y < -0.06) {
                        
                        // RIGHT
                        if (data.acceleration.y > 0.06) && (data.acceleration.y < 0.4) {
                            xVelocity = CGFloat(data.acceleration.y * 800 * orientationMulitplier) // right speed
                            playerXDirection = "right"
                        }
                        if (data.acceleration.y > 0.4){
//                            print("right cap hit")
                            xVelocity = CGFloat(0.4 * 800 * orientationMulitplier) // max right speed
                            playerXDirection = "right"
                        }
                        // LEFT
                        if (data.acceleration.y < -0.06) && (data.acceleration.y > -0.4) {
                            xVelocity = CGFloat(data.acceleration.y * 800 * orientationMulitplier) // left speed
                            playerXDirection = "left"
                        }
                        if (data.acceleration.y < -0.4){
//                            print("left cap hit")
                            xVelocity = CGFloat(-0.4 * 800 * orientationMulitplier) // max left speed
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
                            yVelocity = CGFloat(dataXAdjusted * 800 * orientationMulitplier) // up speed
                            playerYDirection = "up"
                        }
                        if (dataXAdjusted > 0.4) {
//                            print("forward cap hit")
                            yVelocity = CGFloat(0.4 * 800 * orientationMulitplier) // max up speed
                            playerYDirection = "up"
                        }
                        // DOWN
                        if (dataXAdjusted < -0.06) && (dataXAdjusted > -0.4) {
                            yVelocity = CGFloat(dataXAdjusted * 1000 * orientationMulitplier) // down speed
                            // is faster because tilting down moves the screen out of the player's view
                            playerYDirection = "down"
                        }
                        if (dataXAdjusted < -0.4) {
//                            print("backward cap hit")
                            yVelocity = CGFloat(-0.4 * 1000 * orientationMulitplier) // max down speed
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
    
    // SWIPE--------------------------------------------------------------------------------------------------------------
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
                    resume()
            }
        }
    }
    
    // DOUBLE TAP---------------------------------------------------------------------------------------------------------
    @IBAction func doubleTapMade(_ sender: UITapGestureRecognizer) {
        print("TOUCH: double tap")
        // conditions: not in a menu, gameplay begun, not already using ability, not out of uses
            if physicsWorld.speed == 1 && startPressed == true && abilityActive == false && abilityUses > 0 {
                abilityActive = true
                abilityUses -= 1
                abilityTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
                print("ABILITY: \(abilityUses) uses left")
                print("ABILITY: time started")
                camera!.addChild(abilityTimerLabel)
        }
    }
    
    // TOUCH--------------------------------------------------------------------------------------------------------------
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // touch outside of item popup to close (change to anywhere?)
            if itemPopupOut == true && !(itemPopup.popupNode.contains(location)) {
                print("TOUCH: item popup closed")
                itemPopupOut = false
                itemPopup.invisible()
                resume(slideMenu)
                itemPopup.run(moveOutOfFrame)
            }
            
            // touch outside of options popup to close
            if optionsPopupOut == true && !(optionsPopup.popupNode.contains(location)) {
                print("TOUCH: options popup closed")
                optionsPopupOut = false
                optionsPopup.invisible()
                slideMenu.isPaused = false
                optionsPopup.run(moveOutOfFrame)
            }
        }
    }
    
    // COLLISION----------------------------------------------------------------------------------------------------------
    func didBegin(_ contact: SKPhysicsContact){
        func describeCollision(contactA: SKPhysicsBody,
                               contactB: SKPhysicsBody) {
            print("COLLISION: \n  bodyA is \(contactA.node?.name! ?? "unidentified")\n  bodyB is \(contactB.node?.name! ?? "unidentified")")
            print(type(of: contactA.node!))
            print(type(of: contactB.node!))
        }

        if (contact.bodyA.node != nil) &&
            (contact.bodyB.node != nil) {
            
            let aNode = contact.bodyA.node, bNode = contact.bodyB.node
            let aName = aNode?.name, bName = bNode?.name

//            describeCollision(contactA: contact.bodyA,
//                              contactB: contact.bodyB)
            
            // player-enemy
            if ((bName == "player") && (aNode is Enemy)) ||
                ((aName == "player") && (bNode is Enemy)) {
                playerHealth -= 1
                // TODO: play sound & vibration
                 sfx()
//                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                print("COLLISION: player touched enemy, health = \(playerHealth)")
                
                // ---LOSE CONDITION---
                if playerHealth <= 0 {
                    print("COLLISION: player died")
                    playerAlive = false
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
                
                func enemyDelay() {
                    // delay after rebound to avoid enemy bouncing against player until health is gone
                    if aNode! is Enemy {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            aNode!.physicsBody?.isDynamic = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                aNode!.physicsBody?.isDynamic = true
                            }
                        }
                    }
                    if bNode! is Enemy {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            bNode!.physicsBody?.isDynamic = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                bNode!.physicsBody?.isDynamic = true
                            }
                        }
                    }
                }
                
                // enemy & player will rebound only vertical or horizontal,
                // whichever difference in position is greater
                if (abs(aNode!.position.x - bNode!.position.x) > abs(aNode!.position.y - bNode!.position.y)) {
                // x diff > y diff
                    if (aNode!.position.x < bNode!.position.x) {
                        aNode!.run(reboundLeft)
                        bNode!.run(reboundRight)
                        print("ENEMY: rebound left")
                        enemyDelay()
                    }
                    if (aNode!.position.x > bNode!.position.x) {
                        aNode!.run(reboundRight)
                        bNode!.run(reboundLeft)
                        print("ENEMY: rebound right")
                        enemyDelay()
                    }
                }
                if (abs(aNode!.position.y - bNode!.position.y) > abs(aNode!.position.x - bNode!.position.x)) {
                // y diff > x diff
                    if (aNode!.position.y < bNode!.position.y) {
                        aNode!.run(reboundDown)
                        bNode!.run(reboundUp)
                        print("ENEMY: rebound down")
                        enemyDelay()
                    }
                    if (aNode!.position.y > bNode!.position.y) {
                        aNode!.run(reboundUp)
                        bNode!.run(reboundDown)
                        print("ENEMY: rebound up")
                        enemyDelay()
                    }
                }
            }
            
            // player-item
            if ((bName == "player") && (aNode! is Item)) ||
                ((aName == "player") && (bNode! is Item)) {
                if aNode! is Item {
                    aNode!.removeFromParent()
                    itemPopup.itemName.text = aName
                }
                if bNode! is Item {
                    bNode!.removeFromParent()
                    itemPopup.itemName.text = bName
                }
                print("COLLSION: player got item, item count is \(playerItems) out of \(totalItems)")
                
                playerItems += 1
                itemPopupOut = true
                itemPopup.run(moveInFrame)
                itemPopup.visible()
                pause(slideMenu)
                
                // ---WIN CONDITION---
                if playerItems >= 5 {
                    playerWon = true
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
        if playerYDirection == "up"{
            //comment this one out when implementing up/down specific
            player.run(awaySprite)
            if playerXDirection == "left"{
                //player.run(awaySprite)
            }
            if playerXDirection == "right"{
                //player.run(awaySprite)
            }
        }
        if playerYDirection == "down"{
            //comment this one out when implementing left/right specific
            player.run(towardsSprite)
            if playerXDirection == "left"{
                //player.run(towardsSprite)
            }
            if playerXDirection == "right"{
                //player.run(towardsSprite)
            }
        }
        if playerYDirection == "still" && playerXDirection == "still" {
//            player.run(/*new action for still*/)
        }
    }
    
    // called every frame--------------------------------------------------------------------------------------------------
    override func update(_ currentTime: TimeInterval) {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
            orientationMulitplier = -1
        }
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            orientationMulitplier = 1
        }
        
        // update volume
        sfxVol = Float(optionsPopup.sfxVol.volValue/10)
        musicVol = Float(optionsPopup.musicVol.volValue/10)
        
        //update HUD text
        healthLabel.text = String(playerHealth)
        itemLabel.text = "\(String(playerItems))/\(String(totalItems))"
        
        // update player movement based on tilt
        player.physicsBody!.velocity = CGVector(dx: xVelocity,
                                                dy: yVelocity)

        // continuously run pathfinding and attract methods
        if startPressed == true {
            scene?.enumerateChildNodes(withName: "enemy") {
                (node, stop) in
                let enemy = node as? Enemy
                enemy?.pathfinding(playerNode: player,
                                   currentScene: self,
                                   character: charChoice,
                                   ability: abilityActive)
            }
            for child in scene!.children {
                if child is Item {
                    if let childItem = child as? Item {
                        childItem.attract(character: charChoice,
                                          ability: abilityActive,
                                          playerNode: player)
                    }
                }
            }
        }
        
        // player is semi-transparent when using camo
        if charChoice == "Bot" && abilityActive == true {
            player.alpha = 0.4
        }
        else {
            player.alpha = 1
        }
        
        // if player wins, trigger the win popup after the item popup is dismissed
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
    override func willMove(from view: SKView) {
        appDelegate.restrictRotation = .landscape
        abilityTimer.invalidate()
        
        for parent in [worldNode, camera!, self] {
            parent.removeAllChildren()
        }
        
        self.removeAllActions()
    }
}
