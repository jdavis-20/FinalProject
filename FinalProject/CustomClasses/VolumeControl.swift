//
//  VolumeControl.swift
//  FinalProject
//
//  Created by Julian Davis on 3/13/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit

class VolumeControl: SKNode {
        
    let numBkd = SKSpriteNode(imageNamed: "buttonflat")
    let labelBkd = SKSpriteNode(imageNamed: "flatwide")
    var plusButton: Button!
    var minusButton: Button!
    var muteButton: Button!
    var volumeLabel = SKLabelNode()
    var typeLabel = SKLabelNode()
    var muted = false
    var volValue: Int = 10
    
    func turnUp() {
        print("VOLUME UP")
        if volValue < 10 {
            volValue += 1
            if let label = self.childNode(withName: "volumeLabel") as? SKLabelNode {
                label.text = String(volValue)
            }
        }
        print(volValue)
    }
    func turnDown() {
        print("VOLUME DOWN")
        if volValue > 0 {
            volValue -= 1
            if let label = self.childNode(withName: "volumeLabel") as? SKLabelNode {
                label.text = String(volValue)
            }
        }
        print(volValue)
    }
    func mute() {
        if muted == true {
            muted = false
            print("UNMUTE")
            muteButton.buttonLabel.text = "✓"
        }
        else if muted == false {
            muted = true
            print("MUTE")
            muteButton.buttonLabel.text = "✗"
        }
    }
    
    init(label: String) {
        volValue = 10
        plusButton = Button(defaultButtonImage: "volcircle", activeButtonImage: "volcircle",
                            label: "+",
                            textMove: false)
//        plusButton.setScale(0.8)
        minusButton = Button(defaultButtonImage: "volcircle", activeButtonImage: "volcircle",
                             label: "-",
                             textMove: false)
//        minusButton.setScale(0.8)
        muteButton = Button(defaultButtonImage: "volcircle", activeButtonImage: "volcircle",
                            label: "✓", toggle: true,
                            textMove: false)
        
        volumeLabel = SKLabelNode(text: String(volValue))
        volumeLabel.name = "volumeLabel"
        volumeLabel.verticalAlignmentMode = .center
        volumeLabel.fontName = "Conductive"
        typeLabel = SKLabelNode(text: label)
        typeLabel.horizontalAlignmentMode = .left
        typeLabel.verticalAlignmentMode = .center
        typeLabel.fontName = "Conductive"
        
        numBkd.position = CGPoint(x: 3, y: -3)
        labelBkd.position = CGPoint(x: 3, y: 27)
        
        volumeLabel.position = CGPoint(x: 0, y: 0)
        typeLabel.position = CGPoint(x: -50, y: 30)
        plusButton.position = CGPoint(x: 30, y: 0)
        minusButton.position = CGPoint(x: -30, y: 0)
        muteButton.position = CGPoint(x: 50, y: 30)

        super.init()
        
        for node in [numBkd, labelBkd] {
            node.zPosition = self.zPosition + 1
        }
        for node in [volumeLabel, typeLabel, plusButton, minusButton, muteButton] as [SKNode] {
            node.zPosition = self.zPosition + 2
        }
        
        plusButton.action = turnUp
        minusButton.action = turnDown
        muteButton.action = mute
        muteButton.altAction = mute
        
        for node in [plusButton, minusButton, muteButton,
                     volumeLabel, typeLabel,
                     numBkd, labelBkd] as [SKNode] {
            self.addChild(node)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
