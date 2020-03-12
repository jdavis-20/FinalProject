//
//  GameViewController.swift
//  FinalProject
//
//  Created by Julian Davis on 10/12/19.
//  Copyright © 2019 Julian Davis. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var bgMusicPlayer: AVAudioPlayer?
var l1MusicPlayer: AVAudioPlayer?
var l2MusicPlayer: AVAudioPlayer?
var l3MusicPlayer: AVAudioPlayer?
var l4MusicPlayer: AVAudioPlayer?
var inMenu = false
var inLevSel = false
var inL1 = false
var inL2 = false
var inL3 = false
var inL4 = false

class GameViewController: UIViewController {

    override func viewDidLoad() {
        
        let bgmURL = Bundle.main.url(forResource:"menuloop", withExtension: "wav")!
        do {
            bgMusicPlayer = try AVAudioPlayer(contentsOf: bgmURL)
        } catch _ {
            bgMusicPlayer = nil
        }
        bgMusicPlayer?.numberOfLoops = -1

        super.viewDidLoad()
        
        
        
        if let view = self.view as! SKView? {
            //Load the next SKScene
            
            if let scene = SKScene(fileNamed: "MenuScene") {
                //Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size
                
                //Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.scenePlayMusic()
        }
    }
    
    func scenePlayMusic() {
        
        let currentView = self.view as! SKView?
        let currentScene = currentView?.scene!.name
        
        if currentScene == "Menu" && inMenu == false {
            inMenu = true
            inLevSel = false
            inL1 = false
            inL2 = false
            inL3 = false
            inL4 = false
            print("SCENE: MAINMENU")
            bgMusicPlayer?.play()
        }
        if currentScene == "LevelSelect" && inLevSel == false{
            inLevSel = true
            inMenu = false
            inL1 = false
            inL2 = false
            inL3 = false
            inL4 = false
            print("SCENE: LEVELSELECT")
        }
        if currentScene == "Level1" && inL1 == false {
            inL1 = true
            inMenu = false
            inLevSel = false
            inL2 = false
            inL3 = false
            inL4 = false
            print("SCENE: LEVEL1")
            bgMusicPlayer?.stop()
        }
        if currentScene == "Level2" && inL2 == false {
            inL2 = true
            inMenu = false
            inLevSel = false
            inL1 = false
            inL3 = false
            inL4 = false
            print("SCENE: LEVEL2")
            bgMusicPlayer?.stop()
        }
        if currentScene == "Level3" && inL3 == false {
            inL3 = true
            inMenu = false
            inLevSel = false
            inL1 = false
            inL2 = false
            inL4 = false
            print("SCENE: LEVEL3")
            bgMusicPlayer?.stop()
        }
        if currentScene == "Level4" && inL4 == false {
            inL4 = true
            inMenu = false
            inLevSel = false
            inL1 = false
            inL2 = false
            inL3 = false
            print("SCENE: LEVEL4")
            bgMusicPlayer?.stop()
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
