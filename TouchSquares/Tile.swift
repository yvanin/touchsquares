import SpriteKit

enum TileColor: Int {
    case Unknown = 0, Red, Green, Blue, Yellow, Orange
    
    static func random() -> TileColor {
        return TileColor(rawValue: Int(arc4random_uniform(5)) + 1)!
    }
    
    func getUIColor() -> UIColor {
        switch self {
        case .Red: return CustomTileColor.red
        case .Green: return CustomTileColor.green
        case .Blue: return CustomTileColor.blue
        case .Yellow: return CustomTileColor.yellow
        case .Orange: return CustomTileColor.orange
        default: fatalError("Tile color is not supported")
        }
    }
}

class Tile: Hashable {
    var column: Int
    var row: Int
    let color: TileColor
    var sprite: SKSpriteNode?
    var selected = false
    
    var border: SKSpriteNode? {
        get {
            return sprite?.children.first as? SKSpriteNode
        }
    }
    
    init(column: Int, row: Int, color: TileColor) {
        self.column = column
        self.row = row
        self.color = color
    }
  
    var hashValue: Int {
        return row*10 + column
    }
}

func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}