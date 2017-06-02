import SpriteKit

class StartScene: BaseCommandScene {
    var startGameDelegate: StartGameDelegate!
    
    let newGameLabel = SKLabelNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, startGameDelegate: StartGameDelegate, showLeaderboardDelegate: ShowLeaderboardDelegate, helpDelegate: HelpDelegate) {
        super.init(size: size, showLeaderboardDelegate: showLeaderboardDelegate, helpDelegate: helpDelegate, backgroundImageName: Background.getBackground2ImageName())
        self.startGameDelegate = startGameDelegate
        
        newGameLabel.text = "NEW GAME"
        newGameLabel.fontName = CustomFont.regular
        newGameLabel.fontColor = UIColor.blackColor()
        newGameLabel.fontSize = Size.FontSize
        newGameLabel.position = CGPoint(x: 0.0, y: LabelScreenPositions.Action1LabelY)
        addChild(newGameLabel)
        makeBlinking(newGameLabel)
    }
    
    override func nodeTouched(node: SKNode) {
        if node == newGameLabel {
            startGameDelegate.startGame()
        }
    }
}
