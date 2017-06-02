import SpriteKit

class BaseCommandScene: SKScene {
    var showLeaderboardDelegate: ShowLeaderboardDelegate!
    var helpDelegate: HelpDelegate!
    
    let touchTextLabel = SKLabelNode()
    let squaresTextLabel = SKLabelNode()
    let bestScoreLabel = SKLabelNode()
    let leaderboardLabel = SKLabelNode()
    let helpLabel = SKLabelNode()
    
    let helpBackground = SKSpriteNode(texture: nil, size: CGSize(width: 40, height: 40))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, showLeaderboardDelegate: ShowLeaderboardDelegate, helpDelegate: HelpDelegate, backgroundImageName: String?) {
        super.init(size: size)
        self.showLeaderboardDelegate = showLeaderboardDelegate
        self.helpDelegate = helpDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadBestScore", name: UserAuthenticated, object: nil)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Put an image on the background. Because the scene's anchorPoint is
        // (0.5, 0.5), the background image will always be centered on the screen.
        let backgroundImage = backgroundImageName != nil ? backgroundImageName! : "Background"
        let background = SKSpriteNode(imageNamed: backgroundImage)
        addChild(background)
        
        touchTextLabel.text = "TOUCH"
        touchTextLabel.fontName = CustomFont.light
        touchTextLabel.fontColor = UIColor.blackColor()
        touchTextLabel.fontSize = Size.FontSize
        touchTextLabel.position = CGPoint(x: -25.0, y: LabelScreenPositions.LogoLabelY)
        touchTextLabel.horizontalAlignmentMode = .Right
        addChild(touchTextLabel)
        
        squaresTextLabel.text = "SQUARES"
        squaresTextLabel.fontName = CustomFont.regular
        squaresTextLabel.fontColor = UIColor.blackColor()
        squaresTextLabel.fontSize = Size.FontSize
        squaresTextLabel.position = CGPoint(x: -25.0, y: LabelScreenPositions.LogoLabelY)
        squaresTextLabel.horizontalAlignmentMode = .Left
        addChild(squaresTextLabel)
        
        bestScoreLabel.text = "YOUR BEST SCORE: 0"
        bestScoreLabel.fontName = CustomFont.light
        bestScoreLabel.fontColor = UIColor.blackColor()
        bestScoreLabel.fontSize = Size.SmallFontSize
        bestScoreLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.BestScoreLabelY)
        addChild(bestScoreLabel)
        
        reloadBestScore()

        leaderboardLabel.text = "LEADERBOARD"
        leaderboardLabel.fontName = CustomFont.regular
        leaderboardLabel.fontColor = UIColor.blackColor()
        leaderboardLabel.fontSize = Size.SmallFontSize
        leaderboardLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.LeaderboardLabelY)
        addChild(leaderboardLabel)
        
        helpBackground.position = CGPoint(x: 0.0, y: LabelScreenPositions.HelpLabelY)
        addChild(helpBackground)
        
        helpLabel.text = "?"
        helpLabel.fontName = CustomFont.regular
        helpLabel.fontColor = UIColor.blackColor()
        helpLabel.fontSize = Size.SmallFontSize
        helpLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.HelpLabelY)
        addChild(helpLabel)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func makeBlinking(node: SKNode) {
        node.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.fadeAlphaTo(0.2, duration: 1),
                    SKAction.fadeAlphaTo(1.0, duration: 1)
                    ])))
    }
    
    func setBestScore(score: Int64) {
        bestScoreLabel.text = "YOUR BEST SCORE: \(score)"
    }
    
    func reloadBestScore() {
        ScoreHelper.sharedScoreHelper.loadBestScore(setBestScore)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let node = nodeAtPoint(location)
        
        if node == leaderboardLabel {
            showLeaderboardDelegate.showLeaderboard()
        }
        if node == helpLabel || node == helpBackground {
            helpDelegate.showHelp(from: self)
        }
        
        nodeTouched(node)
    }
    
    func nodeTouched(node: SKNode) {
        preconditionFailure("This method must be overridden")
    }
}