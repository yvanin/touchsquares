import SpriteKit

class GameScene: SKScene {
    var level: Level!
    var selectedTiles = Set<Tile>()
    
    var gameOverDelegate: GameOverDelegate!
    var pauseGameDelegate: PauseGameDelegate!
    
    let TileSize: CGFloat =
        DeviceType.IS_IPAD ? 75.0
        : DeviceType.IS_IPHONE_6P ? 55.0
        : DeviceType.IS_IPHONE_6 ? 50.0
        : 42.0
    let VisibleTileSize: CGFloat =
        DeviceType.IS_IPAD ? 62.0
        : DeviceType.IS_IPHONE_6P ? 44.0
        : DeviceType.IS_IPHONE_6 ? 40.0
        : 34.0
    let InfoTextMargin: CGFloat =
        DeviceType.IS_IPAD ? 50.0
        : DeviceType.IS_IPHONE_6P ? 36.0
        : DeviceType.IS_IPHONE_6 ? 30.0
        : DeviceType.IS_IPHONE_5 ? 26.0
        : 20.0
    let PauseLabelMargin: CGFloat =
        DeviceType.IS_IPAD ? 90.0
        : DeviceType.IS_IPHONE_6P ? 80.0
        : DeviceType.IS_IPHONE_6 ? 70.0
        : DeviceType.IS_IPHONE_5 ? 60.0
        : 40.0
   
    let TileBorderWidth: CGFloat = DeviceType.IS_IPAD ? 3 : 2
    
    let tilesLayer = SKNode()
    
    let rectangle = SKShapeNode()
    
    let timerLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    let pauseLabel = SKLabelNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, level: Level, gameOverDelegate: GameOverDelegate, pauseGameDelegate: PauseGameDelegate) {
        super.init(size: size)
        self.level = level
        self.gameOverDelegate = gameOverDelegate
        self.pauseGameDelegate = pauseGameDelegate
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Put an image on the background. Because the scene's anchorPoint is
        // (0.5, 0.5), the background image will always be centered on the screen.
        let background = SKSpriteNode(imageNamed: Background.getBackgroundImageName()!)
        addChild(background)
        
        let layerPosition = CGPoint(
            x: -TileSize * CGFloat(NumColumns) / 2,
            y: -TileSize * CGFloat(NumRows) / 2)
        
        tilesLayer.position = layerPosition
        addChild(tilesLayer)
        
        scoreLabel.text = String(level.score)
        scoreLabel.fontName = CustomFont.light
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = Size.FontSize
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: TileSize * CGFloat(NumColumns) / 2 - 3.0, y: TileSize * CGFloat(NumRows) / 2 + InfoTextMargin)
        addChild(scoreLabel)
        
        timerLabel.text = level.time.secToFormattedTime()
        timerLabel.fontName = CustomFont.light
        timerLabel.fontColor = UIColor.blackColor()
        timerLabel.fontSize = Size.FontSize
        timerLabel.horizontalAlignmentMode = .Left
        timerLabel.position = CGPoint(x: -TileSize * CGFloat(NumColumns) / 2 + 3.0, y: TileSize * CGFloat(NumRows) / 2 + InfoTextMargin)
        addChild(timerLabel)
        timerLabel.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.waitForDuration(1),
                    SKAction.runBlock {
                        self.level.time--;
                        
                        if (self.level.time == 0) {
                            self.gameOverDelegate.gameOver()
                        }
                        else {
                            if (self.level.time == 15) {
                                self.timerLabel.fontColor = UIColor.redColor()
                            }
                            self.timerLabel.text = self.level.time.secToFormattedTime()
                        }
                    }])))
        
        pauseLabel.text = "PAUSE"
        pauseLabel.fontName = CustomFont.light
        pauseLabel.fontColor = UIColor.blackColor()
        pauseLabel.fontSize = Size.FontSize
        pauseLabel.position = CGPoint(x: 0, y: -TileSize * CGFloat(NumRows) / 2 - PauseLabelMargin)
        addChild(pauseLabel)
    }
    
    func addSpritesForTiles(tiles: Set<Tile>) {
        for tile in tiles {
            let sprite = SKSpriteNode(color: tile.color.getUIColor(), size: CGSize(width: VisibleTileSize, height: VisibleTileSize))
            sprite.position = pointForColumn(tile.column, row: tile.row)
            sprite.zPosition = 100
            tilesLayer.addChild(sprite)
            tile.sprite = sprite
            
            let border = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: VisibleTileSize + TileBorderWidth, height: VisibleTileSize + TileBorderWidth))
            border.zPosition = -1
            sprite.addChild(border)
        }
    }
    
    // Converts a column,row pair into a CGPoint that is relative to the tilesLayer.
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileSize + TileSize/2,
            y: CGFloat(row)*TileSize + TileSize/2)
    }
    
    func pointForColumnF(column: CGFloat, row: CGFloat) -> CGPoint {
        return CGPoint(
            x: column*TileSize + TileSize/2,
            y: row*TileSize + TileSize/2)
    }
    
    // Converts a point relative to the tilesLayer into column and row numbers.
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        // Is this a valid location within the tiles layer? If yes,
        // calculate the corresponding row and column numbers.
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileSize &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileSize {
                return (true, Int(point.x / TileSize), Int(point.y / TileSize))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    func selectTile(tile: Tile) {
        tile.selected = true
        selectedTiles.insert(tile)
        
        tile.border?.color = UIColor.whiteColor()
        
        let border2 = SKShapeNode(rectOfSize: CGSize(width: VisibleTileSize + 6, height: VisibleTileSize + 6))
        border2.strokeColor = UIColor.blackColor()
        border2.lineWidth = 4.0
        tile.sprite?.addChild(border2)
    }
    
    func deselectTile(tile: Tile) {
        tile.selected = false
        selectedTiles.remove(tile)
        
        tile.border?.color = UIColor.blackColor()
        
        // remove border2
        tile.sprite?.children.last?.removeFromParent()
    }
    
    func checkSquare(tile: Tile) {
        if selectedTiles.count < 2 {
            return
        }
        
        let tile1 = selectedTiles[selectedTiles.startIndex.advancedBy(0)]
        let tile2 = selectedTiles[selectedTiles.startIndex.advancedBy(1)]
        
        if tile1.row == tile2.row || tile1.column == tile2.column {
            deselectTile(tile1)
            deselectTile(tile2)
            return
        }
        
        let rowStart = tile1.row < tile2.row ? tile1.row : tile2.row
        let rowEnd = tile1.row > tile2.row ? tile1.row : tile2.row
        let colStart = tile1.column < tile2.column ? tile1.column : tile2.column
        let colEnd = tile1.column > tile2.column ? tile1.column : tile2.column
        
        let rectangle = SKShapeNode(rectOfSize: CGSize(width: CGFloat(colEnd-colStart)*TileSize, height: CGFloat(rowEnd-rowStart)*TileSize), cornerRadius: 3.0)
        rectangle.position = pointForColumnF(CGFloat(colStart) + CGFloat(colEnd - colStart) / 2, row: CGFloat(rowStart) + CGFloat(rowEnd - rowStart) / 2)
        rectangle.strokeColor = UIColor.blackColor()
        rectangle.lineWidth = TileBorderWidth
        rectangle.zPosition = 110
        tilesLayer.addChild(rectangle)
        
        self.view?.userInteractionEnabled = false
        
        if tile1.color == tile2.color &&
            level.tiles[tile1.column, tile2.row]?.color == tile1.color &&
            level.tiles[tile2.column, tile1.row]?.color == tile1.color {
                level.updateScore(rowStart, rowEnd: rowEnd, colStart: colStart, colEnd: colEnd)
                scoreLabel.text = String(level.score)

                selectedTiles.removeAll()
                delay(0.05) {
                    rectangle.removeFromParent()
                    for row in rowStart..<rowEnd+1 {
                        for column in colStart..<colEnd+1 {
                            let scaleAction = SKAction.scaleTo(0.4, duration: 0.1)
                            scaleAction.timingMode = .EaseOut
                            self.level.tiles[column, row]?.sprite?.runAction(
                                SKAction.sequence([
                                    scaleAction,
                                    SKAction.removeFromParent()]))
                        }
                    }
                    
                    delay(0.1) {
                        let newTiles = self.level.generateTiles(rowStart, rowEnd: rowEnd, colStart: colStart, colEnd: colEnd)
                        self.addSpritesForTiles(newTiles)
                        self.view?.userInteractionEnabled = true
                    }
                }
        }
        else {
            deselectTile(tile1)
            deselectTile(tile2)
            
            delay(0.005) {
                rectangle.runAction(
                    SKAction.sequence([
                        SKAction.fadeOutWithDuration(0.17),
                        SKAction.runBlock({
                            self.view?.userInteractionEnabled = true
                        }),
                        SKAction.removeFromParent()]))
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let node = nodeAtPoint(location)
        
        if node == pauseLabel {
            pauseGameDelegate.pauseGame()
        }
        else {
            let location = touch.locationInNode(tilesLayer)
            let (success, column, row) = convertPoint(location)
            if success {
                if let tile = level.tiles[column, row] {
                    if !tile.selected {
                        selectTile(tile)
                        delay(0.1) {
                            self.checkSquare(tile)
                        }
                    }
                    else {
                        deselectTile(tile)
                    }
                }
            }
        }
    }
}
