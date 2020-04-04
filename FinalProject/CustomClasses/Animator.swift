//
//  Animator.swift
//  FinalProject
//
//  Created by Julian Davis on 4/4/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import SpriteKit

class Animator: SKNode {
    var animFrames: [SKTexture] = []
    var node: SKSpriteNode
    
    init(animNode: SKSpriteNode, atlas: String, animSpeed: Double) {
        node = animNode
        let animAtlas = SKTextureAtlas(named: atlas)
        let frameImages = animAtlas.textureNames.count
        for i in 1...frameImages {
            let textureName = "frame\(i)"
            animFrames.append(animAtlas.textureNamed(textureName))
        }
        
        let firstFrame = animFrames[0]
//        node.setScale(0.5)
        node.texture = firstFrame
        node.run(SKAction.repeatForever(SKAction.animate(with: animFrames, timePerFrame: 0.1 * animSpeed,
                                                         resize: false, restore: false)), withKey: "item")
        
        super.init()
    }
    
//    func animateNode() {
//        let firstFrame = animFrames[0]
//        node.setScale(0.5)
//        node.texture = firstFrame
//        node.run(SKAction.repeatForever(SKAction.animate(with: animFrames, timePerFrame: 0.1,
//                                                           resize: false, restore: false)), withKey: "item")
//    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
