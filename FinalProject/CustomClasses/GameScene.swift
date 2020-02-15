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
let enemy = Enemy(image: "enemy", position: CGPoint(x: 0, y: 0))
var inGameMenu =  Menu(screenHeight: 375,
                       screenWidth: 667)
var itemPopup = Popup(image: "popup", type: "item", worldNode: worldNode)
var optionsPopup = Popup(image: "popup", type: "options", worldNode: worldNode)

// orientation
var preferredTilt: Double?
var destX: CGFloat = 0.0
var destY: CGFloat = 0.0

// game state values
var started = false
public var playerHealth: Int = 10
var playerAlive = true
var playerYDirection = "up"
var playerXDirection = "still"
var menuOut = true
var itemPopupOut = false
var optionsMenuOut = true

// movement and animation
let path = UIBezierPath()
let away = SKAction.setTexture(SKTexture(imageNamed: "BlueFront"))
let towards = SKAction.setTexture(SKTexture(imageNamed: "RedFront"))


//  this is the superclass to all game levels----------------------------------------------------------------------------------
// it contains fundamental mechanics and anything that needs to persist across levels----------------------------------------

class GameScene: SKScene, SKPhysicsContactDelegate {

    func startGame(){
        // started variable triggers when start button is pressed, sets tilt
        started = true
        // print(inGameMenu.position)
        
        // TODO: vibration response
        // AudioServicesPlaySystemSound(1520)
        // AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    
    //button on the in-game menu, currently quits to the main menu--------------------------------------------------------
    
    func returnToMenu(){
        print("main menu button pressed")
        let menuScene = SKScene(fileNamed: "MenuScene")
        let transition: SKTransition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(menuScene!, transition: transition)
        worldNode.removeAllChildren()
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    func options(){
        print("options button pressed")
        physicsWorld.speed = 0
        optionsPopup.visible()
        inGameMenu.isPaused = true
        optionsMenuOut = true
    }
    
    //executes when the scene is first loaded------------------------------------------------------------------------------
    
    override func didMove(to view: SKView) {
        // This was to see where the menu was in the overall view, leaving for potential future use
        // let zoomOut = SKAction.scale(by: 2, duration: 1)
        // camera!.run(zoomOut)
        
        // only nodes that are children of worldNode will be paused
        addChild(worldNode)
        
        //menu setup
        inGameMenu = Menu(screenHeight: frame.size.height,
                          screenWidth: frame.size.width)
        inGameMenu.position = CGPoint(x: ((frame.size.width / 3) * 2), y: 0)
        camera!.addChild(inGameMenu)
        inGameMenu.zPosition = 1
        // button returning to main menu
        let returnButton = Button(defaultButtonImage: "button",
                                    activeButtonImage: "button_active",
                                    buttonAction: returnToMenu)
        returnButton.position = CGPoint(x: 0,
                                        y: 0)
        inGameMenu.addChild(returnButton)
        // button to accesss options
        let optionButton = Button(defaultButtonImage: "button",
                                  activeButtonImage: "button_active",
                                  buttonAction: options)
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
        
        // start gameplay within the level button
        let startButton = Button(defaultButtonImage: "button",
                                 activeButtonImage: "button_active",
                                 buttonAction: startGame)
        startButton.position = CGPoint(x: 0,
                                       y: (frame.size.height / 4))
        addChild(startButton)

        // runs through all nodes in the scene, finds those with a specific name and sets the physics for them as walls
        scene?.enumerateChildNodes(withName: "MazeWall") {
            (node, stop) in
            let mazeNode = node as? MazeWall
            mazeNode?.setWallPhysics()
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
        

        worldNode.addChild(enemy)
        
//        if (started == true) {
//            enemy.movement()
//        }
        
        
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
                    print("Preferred tilt angle is \(Int(preferredTilt! * 90))°")
                    //0° is flat, 90° is vertical
                }
                
                if started == true {
                    // tilt moves, X
                    if (data.acceleration.y > 0.06 ||
                        data.acceleration.y < -0.06) {
                        
                        destX = CGFloat((data.acceleration.y) * 500) // left and right speed
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
                            destY = CGFloat((-data.acceleration.x + preferredTilt!) * 500) // up speed
                            playerYDirection = "up"
                        }
                        // DOWN
                        if ((-data.acceleration.x + preferredTilt!) < -0.06) {
                            destY = CGFloat((-data.acceleration.x + preferredTilt!) * 650) // down speed
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
        if (inGameMenu.isPaused == false) {
            if sender.direction == .left {
                    print("left swipe")
                    inGameMenu.run(enterAction)
                    worldNode.isPaused = true
                    physicsWorld.speed = 0
                    menuOut = true
            }
            if sender.direction == .right{
                    print("right swipe")
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
            
            print("COLLISION: \n  bodyA is \(contactA.node?.name! ?? "unidentified")\n  bodyB is \(contactB.node?.name! ?? "unidentified")")
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
                (aName == "wall") {
//                print("player collided with wall")
                }
            
            // player touches an enemy (can be initiated by either body)
            if ((bName == "player") && (aName == "enemy")) ||
                ((bName == "enemy") && (aName == "player")) {
                playerHealth -= 1
                print("player touched enemy")
                //death condition (may need to be moved later)
                if playerHealth <= 0 {
                    playerAlive = false
                    print("player died")
                }
            }
            // item collision (currently can be initiated by either body, because items may move)
            if ((bName == "player") && (aNode! is Item)) {
                print("item collision")
                aNode!.removeFromParent()
                
                itemPopupOut = true
                itemPopup.itemName.text = aName
                itemPopup.visible()
//                worldNode.isPaused = true
                physicsWorld.speed = 0
            }
            if ((aName == "player") && (bNode! is Item)) {
                print("item collision")
                bNode!.removeFromParent()
                
                itemPopupOut = true
                itemPopup.itemName.text = bName
                itemPopup.visible()
//                worldNode.isPaused = true
                physicsWorld.speed = 0
            }
            
            // TODO: trying enemy movement stuff
            if (aName == "wall" && bName == "enemy") {
                bNode?.zRotation = .pi
            }
            if (aName == "enemy" && bName == "wall") {
                aNode?.zRotation = .pi
            }
        }
    }
   
    // called on the end of a touch-------------------------------------------------------------------------------------------
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {


        for touch in touches {
            let location = touch.location(in: self)
        
            if !(optionsPopup.popupNode.contains(location)) {
                if optionsMenuOut == true {
                    optionsMenuOut = false
                    optionsPopup.invisible()
                    inGameMenu.isPaused = false
                }
            }
            if !(itemPopup.popupNode.contains(location)) {
                if itemPopupOut == true {
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
        
        // player movement based on tilt
        player.physicsBody!.velocity = CGVector(dx: destX,
                                                dy: destY)
        // TODO: enemy moves in rotation direciton?
        enemy.position = CGPoint(x: enemy.position.x + cos(enemy.zRotation) * 10,
                                 y: enemy.position.y + sin(enemy.zRotation) * 10)
    }
}
