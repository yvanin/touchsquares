import UIKit
import SpriteKit
import GameKit

protocol StartGameDelegate {
    func startGame()
}

protocol GameOverDelegate {
    func gameOver()
}

protocol RestartGameDelegate {
    func restartGame()
}

protocol PauseGameDelegate {
    func pauseGame()
}

protocol ContinueGameDelegate {
    func continueGame()
}

protocol ShowLeaderboardDelegate {
    func showLeaderboard()
}

protocol HelpDelegate {
    func showHelp(from scene: SKScene)
    func returnFromHelp(to scene: SKScene)
}

class GameViewController: UIViewController, GKGameCenterControllerDelegate, StartGameDelegate, GameOverDelegate, RestartGameDelegate, PauseGameDelegate, ContinueGameDelegate, ShowLeaderboardDelegate, HelpDelegate {
    var scene: GameScene!
    var level: Level!
    var gameOverScene: GameOverScene!
    var needToShowAuthenticationVC = false
    
    var skView: SKView {
        get {
            return self.view as! SKView
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAuthenticationViewController", name: PresentAuthenticationViewController, object: nil)
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()
        
        // Configure the view.
        skView.multipleTouchEnabled = false
        
        skView.presentScene(StartScene(size: skView.bounds.size, startGameDelegate: self, showLeaderboardDelegate: self, helpDelegate: self))
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAuthenticationViewController() {
        if let vc = GameKitHelper.sharedGameKitHelper.authenticationViewController {
            if skView.scene == scene {
                needToShowAuthenticationVC = true
            }
            else {
                presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    func delayedShowAuthenticationViewController() {
        if needToShowAuthenticationVC {
            if let vc = GameKitHelper.sharedGameKitHelper.authenticationViewController {
                presentViewController(vc, animated: true, completion: nil)
            }
            needToShowAuthenticationVC = false
        }
    }
    
    func enableUserInteraction() {
        delay(0.1) {
            self.view.userInteractionEnabled = true
        }
    }
    
    func beginGame(transition: SKTransition) {
        // Create level
        level = Level()
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size, level: level, gameOverDelegate: self, pauseGameDelegate: self)
        scene.scaleMode = .AspectFill
        
        // Present the scene.
        skView.presentScene(scene, transition: transition)
        enableUserInteraction()
        
        // Start the game
        
        let newTiles = level.generateAllTiles()
        scene.addSpritesForTiles(newTiles)
    }
    
    func startGame() {
        beginGame(SKTransition.fadeWithDuration(0.3))
    }
    
    func gameOver() {
        gameOverScene = GameOverScene(size: skView.bounds.size, score: level.score, restartGameDelegate: self, showLeaderboardDelegate: self, helpDelegate: self)
        skView.presentScene(gameOverScene, transition: SKTransition.moveInWithDirection(.Right, duration: 0.3))
        enableUserInteraction()
        
        delayedShowAuthenticationViewController()
    }
    
    func restartGame() {
        beginGame(SKTransition.moveInWithDirection(.Left, duration: 0.3))
    }
    
    func pauseGame() {
        scene.speed = 0.0
        let pauseScene = PauseScene(size: skView.bounds.size, timeLeft: level.time, continueGameDelegate: self, showLeaderboardDelegate: self, helpDelegate: self)
        skView.presentScene(pauseScene, transition: SKTransition.moveInWithDirection(.Right, duration: 0.3))
        enableUserInteraction()
    }
    
    func continueGame() {
        skView.presentScene(scene, transition: SKTransition.moveInWithDirection(.Left, duration: 0.3))
        enableUserInteraction()
        scene.speed = 1.0
    }
    
    func showLeaderboard() {
        let vc = GKGameCenterViewController.init()
        vc.gameCenterDelegate = self
        vc.viewState = .Leaderboards
        vc.leaderboardIdentifier = GameKitHelper.sharedGameKitHelper.leaderboardId
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func showHelp(from scene: SKScene) {
        let helpScene = HelpScene(size: skView.bounds.size, previousScene: scene, helpDelegate: self)
        skView.presentScene(helpScene, transition: SKTransition.moveInWithDirection(.Right, duration: 0.3))
    }
    
    func returnFromHelp(to scene: SKScene) {
        skView.presentScene(scene, transition: SKTransition.moveInWithDirection(.Left, duration: 0.3))
    }
}
