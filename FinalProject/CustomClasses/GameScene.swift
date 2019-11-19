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

var camera = SKCameraNode()
var manager = CMMotionManager()
var player = SKSpriteNode()

var preferredTilt: Double?
var destX: CGFloat = 0.0
var destY: CGFloat = 0.0
var started = false

let path = UIBezierPath()

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    func startGame(){
        //started variable triggers when start button is pressed, sets tilt
        started = true
        
        //AudioServicesPlaySystemSound(1520)
        //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    override func didMove(to view: SKView) {
        //physics contact delegate
        physicsWorld.contactDelegate = self
        
        //start gameplay within the level button
        let startButton = Button(defaultButtonImage: "button", activeButtonImage: "button_active", buttonAction: startGame)
        startButton.position = CGPoint(x: (frame.size.width / 2), y: (frame.size.height / 4))
        addChild(startButton)
        
        //test menu stationary in camera view (not working)
        let testMenu =
            Menu(color: .blue,
                 position: "top",
                 screenHeight: frame.size.height,
                 screenWidth: frame.size.width)
        camera!.addChild(testMenu)
        
        //player
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: (frame.size.width / 2), y: (frame.size.height / 2))
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
        
        //enemy using custom class
        let enemy = Enemy(image: "button", position: CGPoint(x: (frame.size.width / 3), y: (frame.size.height / 3)))
        addChild(enemy)
        enemy.movement()
        
        //accelerometer data
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
                
                //range where tilt moves the player, X
                if started == true {
                    if (data.acceleration.y > 0.1 || data.acceleration.y < -0.1) {
                        destX = CGFloat((data.acceleration.y) * 350)
                    }
                    //tilt below the threshold, no movement X
                    else {
                        destX = CGFloat(0)
                    }
                    //tilt moves, Y
                    if ((-data.acceleration.x + preferredTilt!) > 0.1 || (-data.acceleration.x + preferredTilt!) < -0.1) {
                        destY = CGFloat((-data.acceleration.x + preferredTilt!) * 350)
                    }
                    //tilt doesn't move, Y
                    else {
                        destY = CGFloat(0)
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
    
    //collision detection
    func didBegin(_ contact: SKPhysicsContact){
        func describeCollision(contactA: SKPhysicsBody, contactB: SKPhysicsBody) {
            let aName = contactA.node?.name!
            let bName = contactB.node?.name!
            print("bodyA is \(aName)\n bodyB is \(bName)")
        }
        
        if (contact.bodyA.node != nil) && (contact.bodyB.node != nil) {
            describeCollision(contactA: contact.bodyA, contactB: contact.bodyB)
        if (contact.bodyB.node?.name == "player") && (contact.bodyA.node?.name == "wall") {
            print("player collided with wall")
            }
        }
    }
    
    override func didSimulatePhysics() {
        //camera follows player sprite
        camera!.position.x = player.position.x
        camera!.position.y = player.position.y
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //player movement is executed each frame
        player.physicsBody!.velocity = CGVector(dx: destX, dy: destY)
    }
}
