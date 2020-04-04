//
//  PlayerAnimator.swift
//  FinalProject
//
//  Created by Julian Davis on 4/2/20.
//  Copyright © 2020 Julian Davis. All rights reserved.
//

import SpriteKit


class PlayerAnimator: SKNode {
    let gameScene = GameScene.self()
    var frontFrames: [SKTexture] = []
    var backFrames: [SKTexture] = []
    var rightFrames: [SKTexture] = []
    var leftFrames: [SKTexture] = []
    var animKey: String
    
    init(frontAtlas: String, backAtlas: String, leftAtlas: String, rightAtlas: String, key: String) {
        animKey = key
        let frontTextureAtlas = SKTextureAtlas(named: frontAtlas)
        let backTextureAtlas = SKTextureAtlas(named: backAtlas)
        let leftTextureAtlas = SKTextureAtlas(named: leftAtlas)
        let rightTextureAtlas = SKTextureAtlas(named: rightAtlas)
        
        let frontFrameImages = frontTextureAtlas.textureNames.count
        for i in 1...frontFrameImages {
            let textureName = "frame\(i)"
            frontFrames.append(frontTextureAtlas.textureNamed(textureName))
        }
        
        let backFrameImages = backTextureAtlas.textureNames.count
        for i in 1...backFrameImages {
            let textureName = "frame\(i)"
            backFrames.append(backTextureAtlas.textureNamed(textureName))
        }
        
        let leftFrameImages = leftTextureAtlas.textureNames.count
        for i in 1...leftFrameImages {
            let textureName = "frame\(i)"
            leftFrames.append(leftTextureAtlas.textureNamed(textureName))
        }
        
        let rightFrameImages = rightTextureAtlas.textureNames.count
        for i in 1...rightFrameImages {
            let textureName = "frame\(i)"
            rightFrames.append(rightTextureAtlas.textureNamed(textureName))
        }
        
        super.init()
    }
    
    func animatePlayerFront() {
        let firstFrameFront = frontFrames[0]
        if let player = gameScene.childNode(withName: "player") {
            player.setScale(0.5)
            (player as! SKSpriteNode).texture = firstFrameFront
        }
        player.run(SKAction.repeatForever(SKAction.animate(with: frontFrames, timePerFrame: 0.1,
                                                           resize: false, restore: false)), withKey: "anim")
    }
    func animatePlayerBack() {
        let firstFrameBack = backFrames[0]
        if let player = gameScene.childNode(withName: "player") {
            player.setScale(0.5)
            (player as! SKSpriteNode).texture = firstFrameBack
        }
        player.run(SKAction.repeatForever(SKAction.animate(with: backFrames, timePerFrame: 0.1,
                                                           resize: false, restore: false)), withKey: "anim")
    }
    func animatePlayerLeft() {
        let firstFrameLeft = leftFrames[0]
        if let player = gameScene.childNode(withName: "player") {
            player.setScale(0.5)
            (player as! SKSpriteNode).texture = firstFrameLeft
        }
        player.run(SKAction.repeatForever(SKAction.animate(with: leftFrames, timePerFrame: 0.1,
                                                           resize: false, restore: false)), withKey: "anim")
    }
    func animatePlayerRight() {
        let firstFrameRight = frontFrames[0]
        if let player = gameScene.childNode(withName: "player") {
            player.setScale(0.5)
            (player as! SKSpriteNode).texture = firstFrameRight
        }
        player.run(SKAction.repeatForever(SKAction.animate(with: rightFrames, timePerFrame: 0.1,
                                                           resize: false, restore: false)), withKey: "anim")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

