//
//  VolumeControl.swift
//  FinalProject
//
//  Created by Julian Davis on 3/13/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

var plusButton = SKSpriteNode()
var minusButton = SKSpriteNode()
var volumeLabel = SKLabelNode()
var value: Float = 1

class VolumeControl: SKNode {
    init(position: CGPoint) {
        plusButton = SKSpriteNode(imageNamed: "")
        minusButton = SKSpriteNode(imageNamed: "")
        volumeLabel = SKLabelNode(text: "")
        
        super.init()
        
        self.addChild(plusButton)
        self.addChild(minusButton)
        self.addChild(volumeLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
