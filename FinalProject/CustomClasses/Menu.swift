//
//  Menu.swift
//  FinalProject
//
//  Created by Julian Davis on 10/28/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import SpriteKit

class Menu: SKShapeNode {
    
    var menuRect: SKShapeNode
    let enterPath = UIBezierPath()
    let leavePath = UIBezierPath()
    let menuFill = SKColor(red: 0.62, green: 0.84, blue: 0.84, alpha: 0.6)
    let menuLine = SKColor(red: 0.56, green: 0.75, blue: 0.75, alpha: 0.9)
    
    init(screenHeight: CGFloat,
         screenWidth: CGFloat) {
        menuRect = SKShapeNode(rectOf: CGSize(width: 0,
                                              height: 0))
        menuRect.name = "menu"
        menuRect = SKShapeNode(rectOf: CGSize(width: (screenWidth / 3),
                                              height: screenHeight))
        
        menuRect.fillColor = menuFill
        menuRect.strokeColor = menuLine
        menuRect.lineWidth = 2
        
        super.init()
        
        self.addChild(menuRect)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
