import Foundation

let NumColumns = DeviceType.IS_IPAD ? 8 : 7
let NumRows = DeviceType.IS_IPAD ? 9 : 8

class Level {
    var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    var score: Int64 = 0
    var time = 180
    
    func generateTiles(rowStart: Int, rowEnd: Int, colStart: Int, colEnd: Int) -> Set<Tile> {
        var set: Set<Tile>
        repeat {
            set = Set<Tile>()
            for row in rowStart..<rowEnd+1 {
                for column in colStart..<colEnd+1 {
                    let tile = Tile(column: column, row: row, color: TileColor.random())
                    tiles[column, row] = tile
                    set.insert(tile)
                }
            }
        }
        while !checkIfSquareExists()
        return set
    }
    
    func generateAllTiles() -> Set<Tile> {
        return generateTiles(0, rowEnd: NumRows-1, colStart: 0, colEnd: NumColumns-1)
    }
    
    func updateScore(rowStart: Int, rowEnd: Int, colStart: Int, colEnd: Int) {
        score += (rowEnd - rowStart + 1) * (colEnd - colStart + 1)
    }
    
    func checkIfSquareExists() -> Bool {
        let requiredSquareCount = 2
        var squareCount = 0
        for row in 0..<NumRows-1 {
            for column in 0..<NumColumns-1 {
                if let tile = tiles[column, row] {
                    let color = tile.color
                    for k1 in (row+1)..<NumRows {
                        if tiles[column, k1]?.color == color {
                            for k2 in (column+1)..<NumColumns {
                                if tiles[k2, row]?.color == color && tiles[k2, k1]?.color == color {
                                    squareCount++
                                    if squareCount == requiredSquareCount {
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}