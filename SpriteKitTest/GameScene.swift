import SpriteKit
import UIKit
#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

class GameScene: SKScene {
    
    
    var xPlPos = UIScreen.main.bounds.width * 0.1 * 2// For Screen Size
    var yPlPos = UIScreen.main.bounds.height * 0.55 * 2// For Screen Size
    var xUpPos = UIScreen.main.bounds.width-50.0 * 2
    var yUpPos = UIScreen.main.bounds.height-50.0 * 2
    
    let UP: SKSpriteNode = SKSpriteNode(imageNamed: "UP")
    let player: SKSpriteNode? = nil
    let proj: SKSpriteNode = SKSpriteNode(imageNamed: "projectile")
    
    func setUpScene() {
        
        let UP = SKSpriteNode(imageNamed: "UP")
        let player = childNode(withName: "player")
        let proj = SKSpriteNode(imageNamed: "projectile")
        UP.position = CGPoint(x: xUpPos, y: yUpPos)
        
        player?.position = CGPoint(x: xPlPos, y: yPlPos)
        proj.position = CGPoint(x: xPlPos, y: yPlPos)
        addChild(proj)
        addChild(UP)
        NSLog(NSStringFromCGPoint((player?.position)!));
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
        //player.position = CGPoint(x: xPos, y: yPos)
        
        
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
            print("Position: \(t.location(in: view))")
        
            print("player: \(xPlPos),\(yPlPos)")
            print(UIScreen.main.bounds.width)
            
            if (self.nodes(at: t.location(in: self)).contains(UP)) {
                print("Going UP.")
            }
        }
        
    }
}

