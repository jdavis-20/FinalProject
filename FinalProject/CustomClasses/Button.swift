//
//  Button.swift
//  FinalProject
//
//  Created by Julian Davis on 10/9/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import SpriteKit

class Button: SKNode {
    let defaultButton: SKSpriteNode
    let activeButton: SKSpriteNode
    var buttonLabel = SKLabelNode()
    var action: (() -> ())?
    var altAction: (() -> ())?
    var isToggle: Bool
    
    //takes a default and active version of the button
    init(defaultButtonImage: String,
         activeButtonImage: String,
         label: String = "",
         toggle: Bool) {
        
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        activeButton.isHidden = true
        action = nil
        altAction = nil
        buttonLabel.text = label
        buttonLabel.fontName = "Conductive"
        buttonLabel.fontColor = .white
        buttonLabel.fontSize = 24
        buttonLabel.verticalAlignmentMode = .center
        buttonLabel.zPosition = 2
        isToggle = toggle
        
        super.init()
        
        isUserInteractionEnabled = true
        addChild(defaultButton)
        addChild(activeButton)
        addChild(buttonLabel)
        self.name = "button"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        if activeButton.isHidden == true && defaultButton.isHidden == false {
            activeButton.isHidden = false
            defaultButton.isHidden = true
        }
        else if activeButton.isHidden == false && defaultButton.isHidden == true {
            activeButton.isHidden = true
            defaultButton.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        if isToggle == false {
            activeButton.isHidden = false
            defaultButton.isHidden = true
        }
        if isToggle == true {
            toggle()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if isToggle == false {
                if defaultButton.contains(location) {
                    activeButton.isHidden = false
                    defaultButton.isHidden = true
                } else {
                    activeButton.isHidden = true
                    defaultButton.isHidden = false
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if defaultButton.contains(location) {
                if isToggle == true && activeButton.isHidden == true {
                    altAction?()
                }
                else {
                    action?()
                }
            }
            
            if isToggle == false {
                activeButton.isHidden = true
                defaultButton.isHidden = false
            }
        }
    }
}
