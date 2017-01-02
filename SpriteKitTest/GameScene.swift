import SpriteKit
import UIKit
#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif
var x = 0

class GameScene: SKScene {
    
    
    var xPlPos = UIScreen.main.bounds.width * 0.1 * 2// For Screen Size
    var yPlPos = UIScreen.main.bounds.height * 0.55 * 2// For Screen Size
    var xUpPos = 50.0 * 2 //Hardcoded, but fits for all screen so it reachable with fingers
    var yUpPos = 50.0 * 2
    var xPrPos = UIScreen.main.bounds.height * 0.1 * 2// For Screen Size
    var yPrPos = UIScreen.main.bounds.height * 0.55 * 2// For Screen Size
    let UP: SKSpriteNode = SKSpriteNode(imageNamed: "UP")
    let player: SKSpriteNode? = nil
    let proj: SKSpriteNode = SKSpriteNode(imageNamed: "projectile")
    var projArray = [SKSpriteNode]()
    var pressNotifier = false
    
    func setUpScene() {
        
        let player = childNode(withName: "player")
        proj.position = CGPoint(x: xPlPos, y: yPlPos)
        UP.position = CGPoint(x: xUpPos, y: yUpPos)
        UP.setScale(3)
        
        player?.position = CGPoint(x: xPlPos, y: yPlPos)
        
        
        addChild(UP)
        
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
    
    override func update(_ currentTime: TimeInterval) {
        if pressNotifier == true { // Need to run this every frame after the first press after all the projectile are offscreen
            outOfScreen()
            //print(projArray[0].position.x)
        }
        
        
        

        }
    func didFire() {
        
        let proj = SKSpriteNode(imageNamed: "projectile")
        projArray.append(proj)
        proj.position = CGPoint(x: xPrPos, y: yPrPos)

        proj.zPosition = 1000
        addChild(proj)
        
        
        let moveRight = SKAction.moveBy(x: ((UIScreen.main.bounds.width*2)+20), y: 0.0, duration: 3)
        
        print((UIScreen.main.bounds.width*2)-50)
        
        for x in 1...projArray.count {
            projArray[(x-1)].run(moveRight)
        }
        
        
        
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
            didFire()
            pressNotifier = true
            if UP.contains(_: tlocation) == true {
                didFire()
            }
            print(t.location(in: view))
            

        }
    }
    func outOfScreen() {
        if (projArray[0].position.x > ((UIScreen.main.bounds.width*2)-50)) {
            //!proj.intersects(self)
            projArray[0].removeFromParent()
            projArray.remove(at: 0)
            pressNotifier = false

        }
    }
}
