//
//  Level3Scene.swift
//  FinalProject
//
//  Created by Julian Davis on 10/14/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox

var level3Label = SKLabelNode(text: "Level 3")

class Level3Scene: GameScene {
    override func didMove(to view: SKView) {
        level3Label.position = CGPoint(x:(frame.size.width / 2),
                                       y:(frame.size.height / 4))
        
        let leftWall: Wall =
            Wall(height: 400.0,
                 width: 10.0,
                 color: .blue,
                 position: CGPoint(x:(frame.size.width / 10),
                                   y:(frame.size.height / 2)))
        addChild(leftWall)
        
        let rightWall: Wall =
            Wall(height: 400.0,
                 width: 10.0,
                 color: .blue,
                 position: CGPoint(x:(frame.size.width * (9/10)),
                                   y: (frame.size.height / 2)))
        addChild(rightWall)
        
        let topWall: Wall =
            Wall(height: 10,
                 width: 600,
                 color: .blue,
                 position: CGPoint(x:(frame.size.width / 2),
                                   y:(frame.size.height / 10)))
        addChild(topWall)
        
        let bottomWall: Wall =
            Wall(height: 10,
                 width: 600,
                 color: .blue,
                 position: CGPoint(x:(frame.size.width / 2),
                                   y:(frame.size.height * (9/10))))
        addChild(bottomWall)
        
        super.didMove(to: view)
    }
}
