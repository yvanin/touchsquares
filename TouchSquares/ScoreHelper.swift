import Foundation

class ScoreHelper {
    static let sharedScoreHelper = ScoreHelper()
    
    let BestScoreLocalKey = "BestScore"
    
    func reportScore(score: Int64) {
        if let localBestScore = getLocalBestScore() {
            if score > localBestScore {
                setLocalBestScore(score)
            }
        }
        else {
            setLocalBestScore(score)
        }
        
        let gkh = GameKitHelper.sharedGameKitHelper
        if gkh.gameCenterEnabled {
            gkh.reportScore(score)
        }
    }
    
    func loadBestScore(completionHandler: ((Int64) -> Void)) {
        let gkh = GameKitHelper.sharedGameKitHelper
        
        if let localBestScore = getLocalBestScore() {
            completionHandler(localBestScore)
            if gkh.gameCenterEnabled {
                gkh.reportScore(localBestScore)
            }
        }
        else {
            if gkh.gameCenterEnabled {
                gkh.loadBestScore {(score: Int64?) -> Void in
                    if let s = score {
                        self.setLocalBestScore(s)
                        completionHandler(s)
                    }
                    else {
                        completionHandler(0)
                    }
                }
            }
        }
    }
    
    private func setLocalBestScore(score: Int64) {
        if score > 0 {
            NSUserDefaults.standardUserDefaults().setValue(NSNumber(longLong: score), forKey: BestScoreLocalKey)
        }
    }
    
    private func getLocalBestScore() -> Int64? {
        if let nsNumber = NSUserDefaults.standardUserDefaults().valueForKey(BestScoreLocalKey) as? NSNumber {
            return nsNumber.longLongValue
        }
        else {
            return nil
        }
    }
}