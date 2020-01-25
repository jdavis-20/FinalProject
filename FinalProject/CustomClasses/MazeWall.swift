//
//  MazeWall.swift
//  FinalProject
//
//  Created by Julian Davis on 1/24/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import UIKit

import SpriteKit

class MazeWall: SKSpriteNode {
    func setWallPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width,
                                                                 height: self.size.height))
        self.name = "wall" //change to individual names later?
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 1
        self.physicsBody?.categoryBitMask = 0x00000001
        print("init maze wall")
    }
    

}
