//
//  VolumeControl.swift
//  FinalProject
//
//  Created by Julian Davis on 3/13/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

var plusButton: Button!
var minusButton: Button!
var volumeLabel = SKLabelNode()
var typeLabel = SKLabelNode()
var volValue: Float = 1

class VolumeControl: SKNode {
    
    func turnUp() {
        print("VOLUME UP")
        print(volValue)
        if volValue <= 0.9 {
            volValue += 0.1
        }
        volumeLabel.text = String(volValue)
    }
    func turnDown() {
        print("VOLUME DOWN")
        print(volValue)
        if volValue >= 0.1 {
            volValue -= 0.1
        }
        volumeLabel.text = String(volValue)
    }
    
    init(label: String) {
        plusButton = Button(defaultButtonImage: "item_temp", activeButtonImage: "item_temp", label: "+", toggle: false)
        minusButton = Button(defaultButtonImage: "item_temp", activeButtonImage: "item_temp", label: "-", toggle: false)
        volumeLabel = SKLabelNode(text: String(volValue))
        typeLabel = SKLabelNode(text: label)
        volumeLabel.position = CGPoint(x: 0, y: 0)
        typeLabel.position = CGPoint(x: 0, y: 30)
        plusButton.position = CGPoint(x: 40, y: 0)
        minusButton.position = CGPoint(x: -40, y: 0)

        super.init()
        
        plusButton.action = turnUp
        minusButton.action = turnDown
        
        self.addChild(plusButton)
        self.addChild(minusButton)
        self.addChild(volumeLabel)
        self.addChild(typeLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
