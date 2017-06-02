import GameKit

let PresentAuthenticationViewController = "present_authentication_view_controller"
let UserAuthenticated = "user_authenticated"

let LeaderboardForIPhone = "TouchSquares.iPhone"
let LeaderboardForIPad = "TouchSquares.iPad"

class GameKitHelper {
    static let sharedGameKitHelper = GameKitHelper()
    
    var gameCenterEnabled = true
    
    var authenticationViewController: UIViewController?
    private var lastError: NSError?
    
    var leaderboardId: String {
        get {
            return DeviceType.IS_IPAD ? LeaderboardForIPad : LeaderboardForIPhone
        }
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController : UIViewController?, error : NSError?) -> Void in
            self.setLastError(error)
            if let vc = viewController {
                self.setAuthenticationViewController(vc)
            }
            else {
                self.gameCenterEnabled = GKLocalPlayer.localPlayer().authenticated
                if self.gameCenterEnabled {
                    NSNotificationCenter.defaultCenter().postNotificationName(UserAuthenticated, object: self)
                }
            }
        }
    }
    
    func setAuthenticationViewController(authenticationViewController: UIViewController) {
        self.authenticationViewController = authenticationViewController
        NSNotificationCenter.defaultCenter().postNotificationName(PresentAuthenticationViewController, object: self)
    }
    
    func setLastError(error: NSError?) {
        lastError = error
        if let er = error {
            NSLog("GameKitHelper ERROR: %@", er.userInfo.description)
        }
    }
    
    func reportScore(score: Int64) {
        if gameCenterEnabled && score > 0 {
            let gkScore = GKScore.init(leaderboardIdentifier: leaderboardId)
            gkScore.value = score
            
            GKScore.reportScores([gkScore], withCompletionHandler: setLastError)
        }
    }
    
    func loadBestScore(completionHandler: ((Int64?) -> Void)) {
        let leaderboardRequest = GKLeaderboard.init()
        leaderboardRequest.identifier = leaderboardId
        leaderboardRequest.loadScoresWithCompletionHandler {(gkScores : [GKScore]?, error : NSError?) -> Void in
            self.setLastError(error)
            if error == nil {
                if let playerScore = leaderboardRequest.localPlayerScore {
                    completionHandler(playerScore.value)
                    return
                }
            }
            completionHandler(nil)
        }
    }
}
