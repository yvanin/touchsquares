import SpriteKit

class CustomFont {
    static let light = "Montserrat-UltraLight"
    static let regular = "Montserrat-Light"
}

class CustomTileColor {
    static let red = UIColor(red: 109.0/255.0, green: 14.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    static let green = UIColor(red: 84.0/255.0, green: 186.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    static let blue = UIColor(red: 41.0/255.0, green: 95.0/255.0, blue: 133.0/255.0, alpha: 1.0)
    static let yellow = UIColor(red: 242.0/255.0, green: 187.0/255.0, blue: 6.0/255.0, alpha: 1.0)
    static let orange = UIColor(red: 215.0/255.0, green: 78.0/255.0, blue: 8.0/255.0, alpha: 1.0)
}

class Size {
    static let FontSize: CGFloat =
        DeviceType.IS_IPAD ? 36.0
        : (DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P) ? 32.0
        : DeviceType.IS_IPHONE_5 ? 28.0
        : 25.0
    static let SmallFontSize: CGFloat =
        DeviceType.IS_IPAD ? 27.0
        : (DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P) ? 24.0
        : DeviceType.IS_IPHONE_5 ? 21.0
        : 18.0
    static let TinyFontSize: CGFloat =
        DeviceType.IS_IPAD ? 20.0
        : (DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P) ? 16.0
        : DeviceType.IS_IPHONE_5 ? 14.0
        : 10.0
}

class LabelScreenPositions {
    static let LogoLabelY: CGFloat =
        DeviceType.IS_IPAD ? 300.0
        : DeviceType.IS_IPHONE_6P ? 220.0
        : DeviceType.IS_IPHONE_6 ? 180.0
        : DeviceType.IS_IPHONE_5 ? 180.0
        : 160.0
    static let Action1LabelY: CGFloat =
        DeviceType.IS_IPAD ? 49.0
        : DeviceType.IS_IPHONE_6P ? 33.0
        : DeviceType.IS_IPHONE_6 ? 31.0
        : DeviceType.IS_IPHONE_5 ? 27.0
        : 20.0
    static let InfoLabelY: CGFloat =
        DeviceType.IS_IPAD ? -38.0
        : DeviceType.IS_IPHONE_6P ? -25.0
        : DeviceType.IS_IPHONE_6 ? -21.0
        : DeviceType.IS_IPHONE_5 ? -17.0
        : -22.0
    static let BestScoreLabelY: CGFloat =
        DeviceType.IS_IPAD ? -280.0
        : DeviceType.IS_IPHONE_6P ? -220.0
        : DeviceType.IS_IPHONE_6 ? -200.0
        : DeviceType.IS_IPHONE_5 ? -170.0
        : -140.0
    static let LeaderboardLabelY: CGFloat =
        DeviceType.IS_IPAD ? -330.0
        : DeviceType.IS_IPHONE_6P ? -260.0
        : DeviceType.IS_IPHONE_6 ? -235.0
        : DeviceType.IS_IPHONE_5 ? -200.0
        : -170.0
    static let HelpLabelY: CGFloat =
        DeviceType.IS_IPAD ? -410.0
        : DeviceType.IS_IPHONE_6P ? -315.0
        : DeviceType.IS_IPHONE_6 ? -285.0
        : DeviceType.IS_IPHONE_5 ? -240.0
        : -210.0
}

class Background {
    static func getBackgroundImageName() -> String? {
        if DeviceType.IS_IPHONE_4 {
            return "Background.png"
        }
        if DeviceType.IS_IPHONE_5 {
            return "Background-568h.png"
        }
        if DeviceType.IS_IPHONE_6 {
            return "Background-667h.png"
        }
        if DeviceType.IS_IPHONE_6P {
            return "Background-736h.png"
        }
        return "Background.png"
    }
    
    static func getBackground2ImageName() -> String? {
        if DeviceType.IS_IPHONE_4 {
            return "Background2.png"
        }
        if DeviceType.IS_IPHONE_5 {
            return "Background2-568h.png"
        }
        if DeviceType.IS_IPHONE_6 {
            return "Background2-667h.png"
        }
        if DeviceType.IS_IPHONE_6P {
            return "Background2-736h.png"
        }
        return "Background2.png"
    }
}
