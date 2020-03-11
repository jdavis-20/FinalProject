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
    
    init(screenHeight: CGFloat,
         screenWidth: CGFloat) {
        menuRect = SKShapeNode(rectOf: CGSize(width: 0,
                                              height: 0))
        menuRect.name = "menu"
        menuRect = SKShapeNode(rectOf: CGSize(width: (screenWidth / 3),
                                              height: screenHeight))

        /*switch position {
            
        case "top":
            menuRect = SKShapeNode(rectOf: CGSize(width: screenWidth,
                                                  height: (screenHeight / 3)))
            menuRect.position = CGPoint(x: 0,
                                        y: (screenHeight / 3))
            
        case "bottom":
            menuRect = SKShapeNode(rectOf: CGSize(width: screenWidth,
                                                  height: (screenHeight / 3)))
            menuRect.position = CGPoint(x: 0,
                                        y: (-screenHeight / 3))
            
        case "left":
            menuRect = SKShapeNode(rectOf: CGSize(width: (screenWidth / 3),
                                                  height: screenHeight))
            menuRect.position = CGPoint(x: (-screenWidth / 3),
                                        y: 0)
            
        case "right":
            menuRect = SKShapeNode(rectOf: CGSize(width: (screenWidth / 3),
                                                  height: screenHeight))
            menuRect.position = CGPoint(x: ((screenWidth / 3) * 1),
                                        y: 0)
 
        default:
            print("error: no valid menu position provided")
        }*/
        
        menuRect.fillColor = SKColor(red: 0.62,
                                     green: 0.84,
                                     blue: 0.84,
                                     alpha: 0.6)
        menuRect.strokeColor = SKColor(red:0.56,
                                       green:0.75,
                                       blue:0.75,
                                       alpha: 0.9)
        menuRect.lineWidth = 2
        
        super.init()
        
        self.addChild(menuRect)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
