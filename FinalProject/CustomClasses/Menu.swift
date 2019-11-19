//
//  Menu.swift
//  FinalProject
//
//  Created by Julian Davis on 10/28/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

//import UIKit
import SpriteKit

class Menu: SKShapeNode {
    
    var menuRect: SKShapeNode
    
    init(color: SKColor, position: String, screenHeight: CGFloat, screenWidth: CGFloat) {
        menuRect = SKShapeNode(rectOf: CGSize(width: 0, height: 0))
        
        switch position {
            
        case "top":
            menuRect = SKShapeNode(rectOf: CGSize(width: screenWidth, height: (screenHeight / 3)))
            menuRect.position = CGPoint(x: screenWidth / 2, y: screenHeight * (5/6))
            
        case "bottom":
            menuRect = SKShapeNode(rectOf: CGSize(width: screenWidth, height: (screenHeight / 3)))
            menuRect.position = CGPoint(x: screenWidth / 2, y: screenHeight / 6)
            
        case "left":
            menuRect = SKShapeNode(rectOf: CGSize(width: (screenWidth / 3), height: screenHeight))
            menuRect.position = CGPoint(x: screenWidth / 6, y: screenHeight / 2)
            
        case "right":
            menuRect = SKShapeNode(rectOf: CGSize(width: (screenWidth / 3), height: screenHeight))
            menuRect.position = CGPoint(x: screenWidth * (5/6), y: screenHeight / 2)
            
        default:
            print("error: no valid menu position provided")
        }
        
        menuRect.fillColor = color
        menuRect.strokeColor = color
        menuRect.fillColor.withAlphaComponent(0.5)
        menuRect.strokeColor.withAlphaComponent(0.5)
        
        super.init()
        self.addChild(menuRect)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
