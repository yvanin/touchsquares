import SpriteKit

class PauseScene: BaseCommandScene {
    var continueGameDelegate: ContinueGameDelegate!
    
    let continueLabel = SKLabelNode()
    let timeLeftLabel = SKLabelNode()
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, timeLeft: Int, continueGameDelegate: ContinueGameDelegate, showLeaderboardDelegate: ShowLeaderboardDelegate, helpDelegate: HelpDelegate) {
        super.init(size: size, showLeaderboardDelegate: showLeaderboardDelegate, helpDelegate: helpDelegate, backgroundImageName: Background.getBackground2ImageName())
        self.continueGameDelegate = continueGameDelegate
        
        continueLabel.text = "BACK TO GAME"
        continueLabel.fontName = CustomFont.regular
        continueLabel.fontColor = UIColor.blackColor()
        continueLabel.fontSize = Size.FontSize
        continueLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.Action1LabelY)
        addChild(continueLabel)
        makeBlinking(continueLabel)
        
        timeLeftLabel.text = "TIME LEFT: \(timeLeft.secToFormattedTime())"
        timeLeftLabel.fontName = CustomFont.light
        timeLeftLabel.fontColor = UIColor.blackColor()
        timeLeftLabel.fontSize = Size.SmallFontSize
        timeLeftLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.InfoLabelY)
        addChild(timeLeftLabel)
    }
    
    override func nodeTouched(node: SKNode) {
        if node == continueLabel {
            continueGameDelegate.continueGame()
        }
    }
}