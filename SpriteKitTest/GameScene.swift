import SpriteKit
import UIKit
#if os(watchOS)
    import WatchKit
    // <rdar://problem/26756207> SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

class GameScene: SKScene {
    
    var xPlPos = (UIScreen.main.bounds.width * 0.1)-UIScreen.main.bounds.width*0.5
    var yPlPos = (UIScreen.main.bounds.height * 0.5)-UIScreen.main.bounds.height*0.5
    var xUpPos = (UIScreen.main.bounds.width)-50.0
    
    var yUpPos = (UIScreen.main.bounds.height-50.0)
    
    let UP: SKSpriteNode = SKSpriteNode(imageNamed: "UP")
    let player: SKSpriteNode = SKSpriteNode(imageNamed: "player")
    let proj: SKSpriteNode = SKSpriteNode(imageNamed: "projectile")
    
    func setUpScene() {
        
        let UP = SKSpriteNode(imageNamed: "UP")
        let player = SKSpriteNode(imageNamed: "player")
        let proj = SKSpriteNode(imageNamed: "projectile")
        print(xUpPos)
        print(yUpPos)
        UP.position = CGPoint(x: xUpPos, y: yUpPos)
        player.position = CGPoint(x: 193, y: 193)
        proj.position = CGPoint(x: xPlPos, y: yPlPos)
        addChild(player)
        addChild(proj)
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
            print("UP: \(xUpPos),\(yUpPos)")
            print(UIScreen.main.bounds.width)
            
            if (self.nodes(at: t.location(in: self)).contains(UP)) {
                print("Going UP.")
            }
        }
        
    }
}

