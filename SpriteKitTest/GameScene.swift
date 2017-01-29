/**
 * Copyright (c) 2017 Westlake APC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//
//  GameScene.swift
//  LarryPlatformer
//


import SpriteKit
import UIKit
#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif


class GameScene: SKScene {
    
    
    var xPlPos = UIScreen.main.bounds.width * 0.1 * 2// For Screen Size
    var yPlPos = UIScreen.main.bounds.height-UIScreen.main.bounds.height+350.0 // Background always is same distance to bottom so player needs to touch the ground
    var xUpPos = 50.0 * 2 //Hardcoded, but fits for all screen so it reachable with fingers
    var yUpPos = 50.0 * 2
    var xPrPos = UIScreen.main.bounds.width * 0.1 * 2// For Screen Size
    var yPrPos = UIScreen.main.bounds.height-UIScreen.main.bounds.height+325.0
    //let UP: SKSpriteNode = SKSpriteNode(imageNamed: "UP")
    var player : SKSpriteNode?
    let proj: SKSpriteNode = SKSpriteNode(imageNamed: "projectile")
    var projArray = [SKSpriteNode]()
    var fireNotifier = false
    var jumpNotifier = false
    var maxFireRate = 5
    var startTime = TimeInterval()
    var currentTime = NSDate.timeIntervalSinceReferenceDate
    
    var elapsedTime = TimeInterval()
    func setUpScene() {
        
        //let player = childNode(withName: "player")
        self.player = self.childNode(withName: "player") as? SKSpriteNode
        proj.position = CGPoint(x: xPlPos, y: yPlPos)
        
        player?.position = CGPoint(x: xPlPos, y: yPlPos)
        
        
        
        
        //player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        
    }
    
    // MARK: Platform conditional SKView initialization
    #if os(watchOS)
        override func sceneDidLoad() {
            // Matching dimensions
            self.size.width = WKInterfaceDevice.current().screenBounds.width * 2
            self.size.height = WKInterfaceDevice.current().screenBounds.height * 2
    
            self.setUpScene()
        }
    #elseif os(iOS) || os(tvOS)
        override func didMove(to view: SKView) {
            // Matching dimensions
            self.size.width = UIScreen.main.bounds.width * 2
            self.size.height = UIScreen.main.bounds.height * 2
            self.setUpScene()
        }
    #elseif os(macOS)
        override func didMove(to view: SKView) {
            // Matching dimensions
            self.size.width = (NSScreen.main()?.visibleFrame.width)! * 2
            self.size.height = (NSScreen.main()?.visibleFrame.height)! * 2
    
            self.setUpScene()
        }
    #endif
    
    override func update(_ curTime: TimeInterval) {
        
        if projArray.count > 0 {
            fireNotifier = true
        }
        if fireNotifier == true { // Need to run this every frame after the first press and not after all the projectiles are offscreen
            
            
            outOfScreen()
        }
        if jumpNotifier == true {
            normalPos()
            
            elapsedTime = currentTime - startTime
            //print(elapsedTime)
        }
        currentTime = NSDate.timeIntervalSinceReferenceDate
        

        }
    func didFire() {
        
        let proj = SKSpriteNode(imageNamed: "projectile")
        projArray.append(proj)
        proj.position = CGPoint(x: xPrPos, y: yPrPos)

        proj.zPosition = 1000
        addChild(proj)

        
        let moveRight = SKAction.moveBy(x: ((UIScreen.main.bounds.width*2)+20), y: 0.0, duration: 3)
        
        projArray[(projArray.count)-1].run(moveRight)

        
        
        
    }
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let tlocation = t.location(in: self)
            
            
            if tlocation.x > UIScreen.main.bounds.width && projArray.count < maxFireRate {
                didFire()
                
            }
            if tlocation.x < UIScreen.main.bounds.width && player!.position.y == yPlPos {
                //print("JUMP")
                jumpNotifier = true
                startTime = currentTime
                //print(currentTime)
            }
            //print(t.location(in: view))
            

        }
    }
    func outOfScreen() {
        if (projArray[0].position.x > ((UIScreen.main.bounds.width*2)-50)) {
            //!proj.intersects(self)
            projArray[0].removeFromParent()
            projArray.remove(at: 0)
            fireNotifier = false
            
        }
    }
    func normalPos() {
        if (player?.position.y)! < yPlPos {
            player?.position.y = yPlPos
            jumpNotifier = true
        }
    }
    
}
