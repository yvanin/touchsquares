import SpriteKit

class HelpScene: SKScene {
    var previousScene: SKScene!
    var helpDelegate: HelpDelegate!
    
    let helpLabel1Y: CGFloat =
        DeviceType.IS_IPAD ? 220.0
        : DeviceType.IS_IPHONE_4 ? 160.0
        : DeviceType.IS_IPHONE_5 ? 170.0
        : 180.0
    
    let helpLabel2Y: CGFloat =
        DeviceType.IS_IPAD ? -220.0
        : DeviceType.IS_IPHONE_4 ? -170.0
        : -190.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, previousScene: SKScene, helpDelegate: HelpDelegate) {
        super.init(size: size)
        self.previousScene = previousScene
        self.helpDelegate = helpDelegate
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: Background.getBackgroundImageName()!)
        addChild(background)

        let helpLabel1 = SKMultilineLabelNode(text: "Find 4 squares\nof the same color\nthat form a rectangle\nand tap two of them")
        helpLabel1.fontName = CustomFont.regular
        helpLabel1.fontColor = UIColor.blackColor()
        helpLabel1.fontSize = Size.SmallFontSize
        helpLabel1.position = CGPoint(x: 0.0, y: helpLabel1Y)
        addChild(helpLabel1)
        
        let howToImage = SKSpriteNode(imageNamed: "HowTo.png")
        addChild(howToImage)
        
        let helpLabel2 = SKMultilineLabelNode(text: "There is always\na rectangle out there")
        helpLabel2.fontName = CustomFont.regular
        helpLabel2.fontColor = UIColor.blackColor()
        helpLabel2.fontSize = Size.SmallFontSize
        helpLabel2.position = CGPoint(x: 0.0, y: helpLabel2Y)
        addChild(helpLabel2)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        helpDelegate.returnFromHelp(to: previousScene)
    }
}