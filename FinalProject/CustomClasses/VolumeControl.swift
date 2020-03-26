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
    
    // TODO: add mute button
    
    var plusButton: Button!
    var minusButton: Button!
    var muteButton: Button!
    var volumeLabel = SKLabelNode()
    var typeLabel = SKLabelNode()
    var muted = false
    var volValue: Int = 10
    
    func turnUp() {
        print("VOLUME UP")
        print(volValue)
        if volValue <= 9 {
            volValue += 1
            if let label = self.childNode(withName: "volumeLabel") as? SKLabelNode {
                label.text = String(volValue)
            }
        }
    }
    func turnDown() {
        print("VOLUME DOWN")
        print(volValue)
        if volValue >= 1 {
            volValue -= 1
            if let label = self.childNode(withName: "volumeLabel") as? SKLabelNode {
                label.text = String(volValue)
            }
        }
    }
    func mute() {
        if muted == true {
            muted = false
            print("UNMUTE")
        }
        else if muted == false {
            muted = true
            print("MUTE")
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
                            label: "M", toggle: true,
                            textMove: false)
        
        volumeLabel = SKLabelNode(text: String(volValue))
        volumeLabel.name = "volumeLabel"
        volumeLabel.verticalAlignmentMode = .center
        volumeLabel.fontName = "Conductive"
        typeLabel = SKLabelNode(text: label)
        typeLabel.verticalAlignmentMode = .center
        typeLabel.fontName = "Conductive"
        
        volumeLabel.position = CGPoint(x: 0, y: 0)
        typeLabel.position = CGPoint(x: 0, y: 30)
        plusButton.position = CGPoint(x: 40, y: 0)
        minusButton.position = CGPoint(x: -40, y: 0)
        muteButton.position = CGPoint(x: 70, y: 0)

        super.init()
        
        plusButton.action = turnUp
        minusButton.action = turnDown
        muteButton.action = mute
        muteButton.altAction = mute
        
        self.addChild(plusButton)
        self.addChild(muteButton)
        self.addChild(minusButton)
        self.addChild(volumeLabel)
        self.addChild(typeLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
