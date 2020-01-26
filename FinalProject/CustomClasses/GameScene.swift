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

//nodes
var camera = SKCameraNode()
var manager = CMMotionManager()
var player = SKSpriteNode()
var testMenu =  Menu(/*position: "right",*/
                     screenHeight: 375,
                     screenWidth: 667)

//orientation
var preferredTilt: Double?
var destX: CGFloat = 0.0
var destY: CGFloat = 0.0

//game state values
var started = false
public var playerHealth: Int = 10
var playerAlive = true
var playerYDirection = "up"
var playerXDirection = "still"
var menuOut = true

//movement and animation
let path = UIBezierPath()
let away = SKAction.setTexture(SKTexture(imageNamed: "playerback"))
let towards = SKAction.setTexture(SKTexture(imageNamed: "player"))


//this is the superclass to all game levels----------------------------------------------------------------------------------
//it contains fundamental mechanics and anything that needs to persist across levels----------------------------------------

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    func startGame(){
        //started variable triggers when start button is pressed, sets tilt
        started = true
        print(testMenu.position)
        
        //TODO: vibration response
        //AudioServicesPlaySystemSound(1520)
        //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    
    //button on the in-game menu, currently quits to the main menu--------------------------------------------------------
    
    func testButton(){
        print("test menu button pressed")
        //TODO: fix scene switch crash
        //let menuScene = SKScene(fileNamed: "MenuScene")
        //let transition: SKTransition = SKTransition.fade(withDuration: 1)
        //self.view?.presentScene(menuScene!, transition: transition)
    }
    
    
    //executes when the scene is first loaded------------------------------------------------------------------------------
    
    override func didMove(to view: SKView) {
        //let zoomOut = SKAction.scale(by: 2, duration: 1)
        //camera!.run(zoomOut)
        
        //menu setup
        testMenu = Menu(/*position: "right",*/
                        screenHeight: frame.size.height,
                        screenWidth: frame.size.width)
        testMenu.position = CGPoint(x: ((frame.size.width / 3) * 2), y: 0)
        camera!.addChild(testMenu)
        testMenu.zPosition = 1
        let testMenuButton = Button(defaultButtonImage: "button",
                                    activeButtonImage: "button_active",
                                    buttonAction: testButton)
        testMenuButton.position = CGPoint(x: 0,
                                          y: 0)
        testMenu.addChild(testMenuButton)
        
        //prep for swipe detection
        let leftRecognizer = UISwipeGestureRecognizer(target: self,
                                                      action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        self.view!.addGestureRecognizer(leftRecognizer)
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self,
                                                       action: #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view!.addGestureRecognizer(rightRecognizer)
        
        //physics contact delegate
        physicsWorld.contactDelegate = self
        
        //start gameplay within the level button
        let startButton = Button(defaultButtonImage: "button",
                                 activeButtonImage: "button_active",
                                 buttonAction: startGame)
        startButton.position = CGPoint(x: 0,
                                       y: (frame.size.height / 4))
        addChild(startButton)

        
        //player-----------------------------------------------------------------------------------------------------------
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 0,
                                  y: 0)
        player.name = "player"
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width,
                                                               height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        
        player.physicsBody?.isDynamic = true
        player.physicsBody?.mass = 0.8
        player.physicsBody?.restitution = 1
        player.physicsBody?.contactTestBitMask = 0x00000001
        
        addChild(player)
        
        
        //enemy---------------------------------------------------------------------------------------------------------
        
        let enemy = Enemy(image: "enemy", position: CGPoint(x: 0,
                                                            y: (frame.size.height * (3/8))))
        addChild(enemy)
        
        if (started == true) {
            enemy.movement()
        }
        
        
        //accelerometer data--------------------------------------------------------------------------------------------
        
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
                    //tilt moves, X
                    if (data.acceleration.y > 0.08 ||
                        data.acceleration.y < -0.08) {
                        
                        destX = CGFloat((data.acceleration.y) * 400)
                        //RIGHT
                        if (data.acceleration.y > 0.1){
                            playerXDirection = "right"
                        }
                        //LEFT
                        if (data.acceleration.y < -0.1){
                            playerXDirection = "left"
                        }
                    }
                        
                    //tilt doesn't move, X
                    else {
                        destX = CGFloat(0)
                        playerXDirection = "still"
                    }
                    
                    //tilt moves, Y
                    if ((-data.acceleration.x + preferredTilt!) > 0.08 ||
                        (-data.acceleration.x + preferredTilt!) < -0.08) {
                        
                        //UP
                        if ((-data.acceleration.x + preferredTilt!) > 0.1) {
                            destY = CGFloat((-data.acceleration.x + preferredTilt!) * 400)
                            playerYDirection = "up"
                        }
                        //DOWN
                        if ((-data.acceleration.x + preferredTilt!) < -0.1) {
                            destY = CGFloat((-data.acceleration.x + preferredTilt!) * 450)
                            playerYDirection = "down"
                        }
                    }
                        
                    //tilt doesn't move, Y
                    else {
                        destY = CGFloat(0)
                        playerYDirection = "still"
                    }
                }
                    
                //tilt cannot move player before start button is pressed
                else if started == false {
                    destX = CGFloat(0)
                    destY = CGFloat(0)
                }
            }
        }
    }
    
    
    //triggers when a swipe is detected------------------------------------------------------------------------------------
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        //menu in and out (origin of menu object is at 0,0 not at the origin of the rectangle)
        let enterAction = SKAction.moveTo(x: (frame.size.width / 3),
                                          duration: 0.5)
        let leaveAction = SKAction.moveTo(x: ((frame.size.width / 3) * 2),
                                          duration: 0.5)

        if sender.direction == .left {
                print("left swipe")
                testMenu.run(enterAction)
                menuOut = true
        }
        if sender.direction == .right{
                print("right swipe")
                testMenu.run(leaveAction)
                menuOut = false
        }
    }
    
    
    //collision detection------------------------------------------------------------------------------------------------
    
    func didBegin(_ contact: SKPhysicsContact){
        func describeCollision(contactA: SKPhysicsBody,
                               contactB: SKPhysicsBody) {
            let aName = contactA.node?.name
            let bName = contactB.node?.name
            print("COLLISION: \n  bodyA is \(aName!)\n  bodyB is \(bName!)")
        }
        //prints the names of items involved in a collision
        if (contact.bodyA.node != nil) &&
            (contact.bodyB.node != nil) {
            describeCollision(contactA: contact.bodyA,
                              contactB: contact.bodyB)
            //player collision with wall
            if (contact.bodyB.node?.name == "player") &&
                (contact.bodyA.node?.name == "wall") {
                print("player collided with wall")
                }
            //player touches an enemy (can be initiated by either body)
            if ((contact.bodyB.node?.name == "player") &&
                (contact.bodyA.node?.name == "enemy")) ||
                ((contact.bodyB.node?.name == "enemy") &&
                (contact.bodyA.node?.name == "player")) {
                playerHealth -= 1
                print("player touched enemy")
                //death condition (may need to be moved later)
                if playerHealth <= 0 {
                    playerAlive = false
                    print("player died")
                }
            }
        }
    }
    
   
    //called every frame when not paused-----------------------------------------------------------------------------------
    
    override func didSimulatePhysics() {
        //camera follows player sprite
        camera!.position.x = player.position.x
        camera!.position.y = player.position.y
        
        //texture changes for the direction the player character is facing
        //TODO: add "still" positions
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
    
    
    //called every frame--------------------------------------------------------------------------------------------------
    
    override func update(_ currentTime: TimeInterval) {
        //player movement based on tilt
        player.physicsBody!.velocity = CGVector(dx: destX,
                                                dy: destY)
    }
}
