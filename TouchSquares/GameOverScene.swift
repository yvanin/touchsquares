import SpriteKit

class GameOverScene: BaseCommandScene {
    var restartGameDelegate: RestartGameDelegate!
    
    let restartLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, score: Int64, restartGameDelegate: RestartGameDelegate, showLeaderboardDelegate: ShowLeaderboardDelegate, helpDelegate: HelpDelegate) {
        ScoreHelper.sharedScoreHelper.reportScore(score)
        
        super.init(size: size, showLeaderboardDelegate: showLeaderboardDelegate, helpDelegate: helpDelegate, backgroundImageName: Background.getBackground2ImageName())
        self.restartGameDelegate = restartGameDelegate
        
        restartLabel.text = "PLAY AGAIN"
        restartLabel.fontName = CustomFont.regular
        restartLabel.fontColor = UIColor.blackColor()
        restartLabel.fontSize = Size.FontSize
        restartLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.Action1LabelY)
        addChild(restartLabel)
        makeBlinking(restartLabel)
        
        scoreLabel.text = "SCORE: \(score)"
        scoreLabel.fontName = CustomFont.light
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = Size.SmallFontSize
        scoreLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.InfoLabelY)
        addChild(scoreLabel)
    }
    
    override func nodeTouched(node: SKNode) {
        if node == restartLabel {
            restartGameDelegate.restartGame()
        }
    }
}