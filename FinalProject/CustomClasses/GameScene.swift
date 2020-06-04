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
var itemPopup = Popup(type: "item")
var optionsPopup = Popup(type: "options")
var charSelPopup = Popup(type: "charsel")
var winPopup = Popup(type: "win")
var losePopup = Popup(type: "lose")

var charSelOut = true, slideMenuOut = true
var optionsPopupOut = false, itemPopupOut = false
var losePopupOut = false, winPopupOut = false

// orientation
var playerTilt: Double?
var xVelocity: CGFloat = 0.0
var yVelocity: CGFloat = 0.0

// game state values
var levelName = ""
var startPressed = false
var enemyInit = false
var abilityActive = false
var playerWon = false
var playerAlive = true
var healthSubtracted = false
var vibrateOn = true
var upAnimating = false, downAnimating = false
var leftAnimating = false, rightAnimating = false

var charChoice = ""
var playerYDirection = "up"
var playerXDirection = "still"

var playerHealth: Int = 10
var playerItems: Int = 0
var totalItems = 0
var abilityTimerSeconds = 10
var abilityUses = 3
var orientationMultiplier: Double = 1
var orientationLeft = true

var sfxVol: Float = 1
var sfxMuted = false
var setSfxVol: SKAction?
var musicVol: Float = 1
var musicMuted = false
var setMusicVol: SKAction?
let song = SKAudioNode(fileNamed: "menuloop.wav")
let mute = SKAction.changeVolume(to: 0, duration: 0)
let fadeIn = SKAction.changeVolume(to: 1, duration: 2)

// HUD labels
var healthNode = SKSpriteNode()
//var healthLabel = SKLabelNode(text: String(10))
var itemLabel = SKLabelNode(text: String(0))
var abilityTimerLabel = SKLabelNode(text: String(10))

var abilityTimer = Timer()

// movement and animation
let transition = SKTransition.fade(withDuration: 1)
let moveInFrame = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0)
let moveOutOfFrame = SKAction.move(to: CGPoint(x: 4000, y: 7000), duration: 0)
let appDelegate = UIApplication.shared.delegate as! AppDelegate // currently being used for restricting rotation

let purpleAnimator = PlayerAnimator(frontAtlas: "front", backAtlas: "back", leftAtlas: "left", rightAtlas: "right", key: "purple")
let blueAnimator = PlayerAnimator(frontAtlas: "front", backAtlas: "back", leftAtlas: "left", rightAtlas: "right", key: "blue")
let redAnimator = PlayerAnimator(frontAtlas: "front", backAtlas: "back", leftAtlas: "left", rightAtlas: "right", key: "red")
let healthTextureAtlas = SKTextureAtlas(named: "health")


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
        
        if charChoice == "Med" {
            addChild(purpleAnimator)
            initPlayer()
        }
        if charChoice == "Bot" {
            addChild(blueAnimator)
            initPlayer()
        }
        if charChoice == "Arch" {
            addChild(redAnimator)
            initPlayer()
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
    func resume(_ node: SKNode? = nil){
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
            if sfxMuted == false {
                SKAction.changeVolume(to: sfxVol, duration: 0)
            }
            if sfxMuted == true {
                SKAction.changeVolume(to: 0, duration: 0)
            }
            self.run(sound)
        }
        if vibrate == true && vibrateOn == true {
            //            AudioServicesPlaySystemSound(1519)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    // sets the timer as needed and updates the HUD label for it
    @objc func updateTimer(){
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
    
    // buttons that take the player to other scenes
    func returnToMenu(){
        print("MENU: main menu button pressed")
        let menuScene = SKScene(fileNamed: "MenuScene")
        self.view?.presentScene(menuScene!, transition: transition)
    }
    
    //TODO: fix level reset
    func resetLevel(){
        print("LOSE: reset button pressed")
        removeAll(exitLevel: false)
        let levelScene = SKScene(fileNamed: self.name!)
        self.view?.presentScene(levelScene!, transition: transition)
        
    }
    
    func nextLevel(){
        print("WIN: level select button pressed")
        removeAll(exitLevel: true)
        switch levelName {
        case "Level1Scene":
            self.view?.presentScene(SKScene(fileNamed: "Level2Scene")!, transition: transition)
        case "Level2Scene":
            self.view?.presentScene(SKScene(fileNamed: "Level3Scene")!, transition: transition)
        case "Level3Scene":
            self.view?.presentScene(SKScene(fileNamed: "Level4Scene")!, transition: transition)
        case "Level4Scene":
            self.view?.presentScene(SKScene(fileNamed: "LevelSelectScene")!, transition: transition)
        default:
            self.view?.presentScene(SKScene(fileNamed: "LevelSelectScene")!, transition: transition)
        }
        
        
        
    }
    
    // options button in the in-game menu
    func options(){
        print("MENU: options button pressed")
        optionsPopup.run(moveInFrame)
        optionsPopup.visible()
        optionsPopupOut = true
        pause(slideMenu)
    }
    
    func closeItemPopup() {
        print("TOUCH: item popup closed")
        itemPopupOut = false
        itemPopup.invisible()
        resume(slideMenu)
        itemPopup.run(moveOutOfFrame)
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
    
    func initPlayer() {
        if worldNode.childNode(withName: "player") == nil {
            // player-------------------------------------------------------------------------------------------------------
            player = SKSpriteNode(texture: purpleAnimator.frontFrames[0])
            player.setScale(0.5)
            player.position = CGPoint(x: 0, y: 0)
            player.name = "player"
            
            player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width - 10,
                                                                   height: player.size.height))
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.allowsRotation = false
            player.physicsBody?.isDynamic = true
            
            //      player.physicsBody?.mass = 0.8
            player.physicsBody?.restitution = 0
            player.physicsBody?.contactTestBitMask = 0x00000001
            
            // player hidden until start is pressed for cleaner appearance
                        player.isHidden = true
            
            worldNode.addChild(player)
            
            // addChild(purpleAnimator)
        }
    }
    
    func setDefaults() {
        // values that need to be reset at the start of a level
        charChoice = ""
        charSelPopup.character = ""
        abilityTimerSeconds = 10
        abilityTimerLabel.text = String(abilityTimerSeconds)
        abilityActive = false
        playerTilt = nil
        startPressed = false
        upAnimating = false; downAnimating = false
        leftAnimating = false; rightAnimating = false
        abilityUses = 3
        playerHealth = 10
        playerItems = 0
        totalItems = 0
        playerWon = false
        winPopupOut = false; losePopupOut = false
    }
    
    func runGameScene() {
        setDefaults()
        
        print("STARTED?: \(startPressed)")
        print("CHARCHOSEN?: \(charChoice)")
        levelName = self.name!
        
        addChild(worldNode)
        worldNode.name = "worldNode"
        
        song.autoplayLooped = true
        song.run(mute)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addChild(song)
            song.run(fadeIn)
        }
        
        // lock rotation within levels and get orientation for tilt
        // orientationMultiplier directly impacts velocity, orientationLeft passes direction to animations etc
        if UIApplication.shared.statusBarOrientation == .landscapeLeft {
            appDelegate.restrictRotation = .landscapeLeft
            orientationMultiplier = 1
            orientationLeft = true
        }
        if UIApplication.shared.statusBarOrientation == .landscapeRight {
            appDelegate.restrictRotation = .landscapeRight
            orientationMultiplier = -1
            orientationLeft = false
        }
        
        // scaling the view
        camera!.setScale(3) // higher num to zoom out
        let zoomOut = SKAction.scale(by: 0.7 , duration: 1.2) // lower num to zoom in
        camera!.run(zoomOut)
        
        // only nodes that are children of worldNode will be paused
        // allows menus to work after they are opened
        
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
            let itemAnim = Animator(animNode: itemNode!, atlas: "item", animSpeed: 1.5)
            self.addChild(itemAnim)
            totalItems += 1
            let itemName = itemNode?.userData?["name"]
            if  itemName != nil {
                print("Item with identifier \(itemName!) initialized")
            }
        }
        scene?.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            let enemy = node as? Enemy
            enemy?.enemyInit()
        }
        
        // popups/menus--------------------------------------------------------------------------------------------------
        // moves popups into initial positions
        charSelPopup.run(moveInFrame)
        for popup in [optionsPopup, itemPopup, winPopup, losePopup] {
            popup.run(moveOutOfFrame)
            popup.invisible()
        }
        for popup in [itemPopup, optionsPopup, winPopup, losePopup, charSelPopup] {
            popup.zPosition = slideMenu.zPosition + 2
            for child in popup.children {
                if child.name != "popupNodeButton" {
                    child.zPosition = popup.zPosition + 1
                }
                if child.name == "popupNodeButton" {
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
        itemPopup.popupNodeButton.action = closeItemPopup
        camera!.addChild(itemPopup)
        // options popup setup
        optionsPopup.tiltResetButton.action = resetTilt
        optionsPopup.invisible()
        camera!.addChild(optionsPopup)
        
        optionsPopup.vibrateButton.action = vibOff
        optionsPopup.vibrateButton.altAction = vibOn
        
        // add health and item counters to HUD
        for label in [//healthLabel,
                        itemLabel, abilityTimerLabel] {
            label.fontName = "Conductive"
            label.verticalAlignmentMode = .center
        }
        
        healthNode = SKSpriteNode(texture: healthTextureAtlas.textureNamed("10H"))
        healthNode.position = CGPoint(x: -frame.size.width/2 + 40 , y: 0)
        healthNode.zPosition = 5
        healthNode.setScale(0.3)
        camera!.addChild(healthNode)
//        healthLabel.position = CGPoint(x: -frame.size.width/2 + 25 , y: frame.size.height/2 - 20)
//        healthLabel.zPosition = 5
//        camera!.addChild(healthLabel)
        itemLabel.position = CGPoint(x: -frame.size.width/2 + 85 , y: frame.size.height/2 - 20)
        itemLabel.zPosition = 5
        camera!.addChild(itemLabel)
        abilityTimerLabel.position = CGPoint(x: 0, y: frame.size.height/2 - 20)
        abilityTimerLabel.fontSize = 26
        abilityTimerLabel.fontColor = .red
        
        // actions available after win/lose
        losePopup.loseReturnButton.action = returnToMenu
        losePopup.retryButton.action = resetLevel
        winPopup.winReturnButton.action = returnToMenu
        winPopup.levSelButton.action = nextLevel
        
        // ACCELEROMETER------------------------------------------------------------------------------------------------
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
                    let dataXAdjusted = -data.acceleration.x + playerTilt! //* orientationMultiplier
                    
                    //                  flat = 0, forward is +, back is -
                    //                  tilt foward goes up to 1 fully vertical, past it goes back from 1
                    //                  tilt back goes up to -1 fully vertical, past it goes back from -1
                    
                    // tilt moves, X
                    if (data.acceleration.y > 0.06 ||
                        data.acceleration.y < -0.06) {
                        
                        // RIGHT (in landscape right)
                        if (data.acceleration.y > 0.06) && (data.acceleration.y < 0.4) {
                            xVelocity = CGFloat(data.acceleration.y * 900 * orientationMultiplier) // right speed
                            if orientationLeft == true {
                                playerXDirection = "right"
                            }
                            else {
                                playerXDirection = "left"
                            }
                        }
                        if (data.acceleration.y > 0.4){
                            //                            print("right cap hit")
                            xVelocity = CGFloat(0.4 * 900 * orientationMultiplier) // max right speed
                            if orientationLeft == true {
                                playerXDirection = "right"
                            }
                            else {
                                playerXDirection = "left"
                            }
                        }
                        // LEFT (in landscape right)
                        if (data.acceleration.y < -0.06) && (data.acceleration.y > -0.4) {
                            xVelocity = CGFloat(data.acceleration.y * 900 * orientationMultiplier) // left speed
                            if orientationLeft == true {
                                playerXDirection = "left"
                            }
                            else {
                                playerXDirection = "right"
                            }                        }
                        if (data.acceleration.y < -0.4){
                            //                            print("left cap hit")
                            xVelocity = CGFloat(-0.4 * 900 * orientationMultiplier) // max left speed
                            if orientationLeft == true {
                                playerXDirection = "left"
                            }
                            else {
                                playerXDirection = "right"
                            }
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
                        
                        // UP (in landscape right)
                        if (dataXAdjusted > 0.06) && (dataXAdjusted < 0.4) {
                            yVelocity = CGFloat(dataXAdjusted * 900 * orientationMultiplier) // up speed
                            if orientationLeft == true {
                                playerYDirection = "up"
                            }
                            else {
                                playerYDirection = "down"
                                yVelocity *= 1.25 // is faster because tilting down moves the screen out of the player's view
                            }
                        }
                        if (dataXAdjusted > 0.4) {
                            // print("forward cap hit")
                            yVelocity = CGFloat(0.4 * 900 * orientationMultiplier) // max up speed
                            if orientationLeft == true {
                                playerYDirection = "up"
                            }
                            else {
                                playerYDirection = "down"
                                yVelocity *= 1.25
                            }
                        }
                        // DOWN (in landscape right)
                        if (dataXAdjusted < -0.06) && (dataXAdjusted > -0.4) {
                            yVelocity = CGFloat(dataXAdjusted * 900 * orientationMultiplier) // down speed
                            if orientationLeft == true {
                                playerYDirection = "down"
                                yVelocity *= 1.25
                            }
                            else {
                                playerYDirection = "up"
                            }
                        }
                        if (dataXAdjusted < -0.4) {
                            // print("backward cap hit")
                            yVelocity = CGFloat(-0.4 * 900 * orientationMultiplier) // max down speed
                            if orientationLeft == true {
                                playerYDirection = "down"
                                yVelocity *= 1.25
                            }
                            else {
                                playerYDirection = "up"
                            }
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
    
    //executes when the scene is first loaded------------------------------------------------------------------------------
    override func didMove(to view: SKView) {
        runGameScene()
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
        print("touch detected")
        
        for touch in touches {
            let location = touch.location(in: self)
            
            // touch outside of item popup to close (change to anywhere?)
            if itemPopupOut == true && !(itemPopup.popupNodeButton.contains(location)) {
                closeItemPopup()
            }
            
            // touch outside of options popup to close
            if optionsPopupOut == true && !(optionsPopup.popupNodeButton.contains(location)) {
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
        // currently unused function for testing collision detection
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
            
//            describeCollision(contactA: contact.bodyA, contactB: contact.bodyB)
            
            var reboundImpulse = 50
            let reboundLeft = SKAction.applyImpulse(CGVector(dx: -reboundImpulse, dy: 0), duration: 0.1)
            let reboundRight = SKAction.applyImpulse(CGVector(dx: reboundImpulse, dy: 0), duration: 0.1)
            let reboundUp = SKAction.applyImpulse(CGVector(dx: 0, dy: reboundImpulse), duration: 0.1)
            let reboundDown = SKAction.applyImpulse(CGVector(dx: 0, dy: -reboundImpulse), duration: 0.1)
            
            // or if enemy is with distance of wall
            
            // enemy-wall
            // enemy bounces off of wall to avoid getting stuck
            if (aNode is Enemy) && (bNode is MazeWall) {
//                reboundImpulse = 50
                if (aNode!.position.x < bNode!.position.x) {
                    aNode!.run(reboundLeft)
                    print("ENEMY: wall rebound left")
                }
                if (aNode!.position.x > bNode!.position.x) {
                    aNode!.run(reboundRight)
                    print("ENEMY: wall rebound right")
                }
                if (aNode!.position.y < bNode!.position.y) {
                    aNode!.run(reboundDown)
                    print("ENEMY: wall rebound down")
                }
                if (aNode!.position.y > bNode!.position.y) {
                    aNode!.run(reboundUp)
                    print("ENEMY: wall rebound up")
                }
            }
            if (aNode is MazeWall) && (bNode is Enemy) {
//                reboundImpulse = 50
                if (aNode!.position.x < bNode!.position.x) {
                    bNode!.run(reboundRight)
                    print("ENEMY: wall rebound left")
                }
                if (aNode!.position.x > bNode!.position.x) {
                    bNode!.run(reboundLeft)
                    print("ENEMY: wall rebound right")
                }
                if (aNode!.position.y < bNode!.position.y) {
                    bNode!.run(reboundUp)
                    print("ENEMY: wall rebound down")
                }
                if (aNode!.position.y > bNode!.position.y) {
                    bNode!.run(reboundDown)
                    print("ENEMY: wall rebound up")
                }
            }
            
            // player-enemy
            if ((bName == "player") && (aNode is Enemy)) ||
                ((aName == "player") && (bNode is Enemy)) {
//                reboundImpulse = 300
                sfx()
                if healthSubtracted == false {
                    healthSubtracted = true
                    playerHealth -= 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        healthSubtracted = false
                    }
                    
                }
                // AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
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
                    let itemName = aNode!.userData?["name"]
                    if  itemName != nil {
                        itemPopup.itemName.text = "You found \(itemName!)"
                    }
                    aNode!.removeFromParent()
                }
                if bNode! is Item {
                    let itemName = bNode!.userData?["name"]
                    if  itemName != nil {
                        itemPopup.itemName.text = "You found \(itemName!)"
                    }
                    bNode!.removeFromParent()
                }
                print("COLLSION: player got item, item count is \(playerItems) out of \(totalItems)")
                
                playerItems += 1
                itemPopupOut = true
                itemPopup.run(moveInFrame)
                itemPopup.visible()
                pause(slideMenu)
                
                // ---WIN CONDITION---
                if playerItems >= totalItems {
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
//        print("X: \(playerXDirection), Y: \(playerYDirection)")
        
        // if x movement is greater than y, use U/D animations
        if abs(xVelocity) > abs(yVelocity) {
            // left and right animations
            player.action(forKey: "anim")?.speed = CGFloat((abs(xVelocity) / 250))
            if playerXDirection == "left"{
//                print("animate left")
                if leftAnimating == false {
                    leftAnimating = true
                    rightAnimating = false; upAnimating = false; downAnimating = false
                    purpleAnimator.animatePlayerLeft()
                }
            }
            if playerXDirection == "right"{
//                print("animate right")
                if rightAnimating == false {
                    rightAnimating = true
                    leftAnimating = false; upAnimating = false; downAnimating = false
                    purpleAnimator.animatePlayerRight()
                }
            }
        }
        // if y movement is greater than x, use L/R animations
        if abs(yVelocity) > abs(xVelocity){
            // up and down animations
            player.action(forKey: "anim")?.speed = CGFloat((abs(yVelocity) / 250))
            if playerYDirection == "up"{
//                print("animate up")
                if upAnimating == false {
                    upAnimating = true
                    rightAnimating = false; leftAnimating = false; downAnimating = false
                    purpleAnimator.animatePlayerBack()
                }
            }
            if playerYDirection == "down"{
//                print("animate down")
                if downAnimating == false {
                    downAnimating = true
                    rightAnimating = false; upAnimating = false; leftAnimating = false
                    purpleAnimator.animatePlayerFront()
                }
            }
        }
        
        
        if playerYDirection == "still" && playerXDirection == "still" {
            player.action(forKey: "anim")?.speed = 0
        }
    }
    
    // called every frame--------------------------------------------------------------------------------------------------
    override func update(_ currentTime: TimeInterval) {
        initPlayer()
        
        // update volume
        sfxVol = Float(optionsPopup.sfxVol.volValue)/10
        sfxMuted = optionsPopup.sfxVol.muted
        //        TODO: implement sound effects and find a way to identify them (name, type, key?) to adjust volume
        if sfxMuted == false {
            setSfxVol = SKAction.changeVolume(to: sfxVol, duration: 0)
            //            soundeffect.run(setSfxVol!)
        }
        else {
            //            soundeffect.run(mute)
        }
        musicVol = Float(optionsPopup.musicVol.volValue)/10
        musicMuted = optionsPopup.musicVol.muted
        if musicMuted == false {
            setMusicVol = SKAction.changeVolume(to: musicVol, duration: 0)
            song.run(setMusicVol!)
        }
        else {
            song.run(mute)
        }
        
        // update HUD
//        healthLabel.text = String(playerHealth)
        if playerHealth >= 0 {
            healthNode.texture = healthTextureAtlas.textureNamed("\(String(playerHealth))H")
        }
        itemLabel.text = "\(String(playerItems))/\(String(totalItems))"
        
        // update player velocity based on tilt
        player.physicsBody!.velocity = CGVector(dx: xVelocity,
                                                dy: yVelocity)
        
        // continuously run pathfinding on all enemies and attract on all items
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
                        // pause item animation
                        if worldNode.isPaused == true {
                            childItem.action(forKey: "item")?.speed = 0
                        }
                        else {
                            childItem.action(forKey: "item")?.speed = 1
                        }
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
    
    func removeAll(exitLevel: Bool) {
        abilityTimer.invalidate()
                switch exitLevel {
                case false:
                    camera!.removeAllChildren()
                    worldNode.removeAllChildren()
                    for child in self.children {
                        if (child != camera) && !(child is MazeWall) && !(child is Enemy) && !(child is Item) {
                            child.removeAllActions()
                            child.removeFromParent()
                        }
                    }
                case true:
                    for parent in [camera!, worldNode, self] {
                        for child in parent.children {
                            child.removeAllActions()
                            if child != camera {
                                child.removeFromParent()
                            }
                        }
                    }
                }
        self.removeAllActions()
    }
    
    override func willMove(from view: SKView) {
        appDelegate.restrictRotation = .landscape
        
        // remove everything from the scene
        // failing to do so causes duplicates/crashes
        removeAll(exitLevel: true)
    }
}
