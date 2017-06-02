import SpriteKit

class SKMultilineLabelNode: SKNode {
    private var labels = Array<SKLabelNode>()
    private var placeholderLabel = SKLabelNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String?) {
        super.init()
        placeholderLabel.text = text
        
        if let t = text {
            let lines = t.characters.split(isSeparator: {$0 == "\n"})
            for line in lines {
                let label = SKLabelNode(text: String(line))
                labels.append(label)
                addChild(label)
            }
            recalcLabelPositions()
        }
    }
    
    var fontName: String? {
        get {
            return placeholderLabel.fontName
        }
        set(value) {
            placeholderLabel.fontName = value
            for label in labels {
                label.fontName = value
            }
        }
    }
    
    var fontColor: UIColor? {
        get {
            return placeholderLabel.fontColor
        }
        set(value) {
            placeholderLabel.fontColor = value
            for label in labels {
                label.fontColor = value
            }
        }
    }
    
    var fontSize: CGFloat {
        get {
            return placeholderLabel.fontSize
        }
        set(value) {
            placeholderLabel.fontSize = value
            for label in labels {
                label.fontSize = value
            }
            recalcLabelPositions()
        }
    }
    
    override var position: CGPoint {
        get {
            return placeholderLabel.position
        }
        set(value) {
            placeholderLabel.position = value
            recalcLabelPositions()
        }
    }
    
    private var _lineSpacing: CGFloat = 5.0
    var lineSpacing: CGFloat {
        get {
            return _lineSpacing
        }
        set(value) {
            _lineSpacing = value
            recalcLabelPositions()
        }
    }
    
    private func recalcLabelPositions() {
        let anchor = placeholderLabel.position
        let medianLabelIndex = labels.count/2
        
        for index in 0...labels.count-1 {
            let direction = medianLabelIndex > index ? 1 : medianLabelIndex == index ? 0 : -1
            if labels.count%2 == 1 {
                labels[index].position = CGPoint(x: anchor.x, y: anchor.y + (CGFloat(medianLabelIndex) - CGFloat(index))*(lineSpacing + fontSize) + CGFloat(direction)*fontSize)
            }
            else {
                labels[index].position = CGPoint(x: anchor.x, y: anchor.y + (CGFloat(medianLabelIndex) - CGFloat(index))*(lineSpacing + fontSize) + CGFloat(direction)*(lineSpacing/2))
            }
        }
    }
}