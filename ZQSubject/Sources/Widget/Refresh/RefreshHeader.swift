import MJRefresh
import Kingfisher

/// 下拉刷新
class RefreshHeader: MJRefreshGifHeader {
    
    var beginRefreshingTime: TimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImages([UIImage(named: "refresh_logo_big")!], for: .idle)
        setImages([UIImage(named: "refresh_logo_big")!], for: .pulling)
        setImages([UIImage(named: "refresh_logo_big")!], for: .willRefresh)
        
        setImages([UIImage.animatedImageNamed("refresh_logo_", duration: 1.9)!], for: .refreshing)
        stateLabel?.isHidden = true
        lastUpdatedTimeLabel?.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        beginRefreshingTime = Date().timeIntervalSince1970
    }
    
    override func endRefreshing() {
        let endTime = Date().timeIntervalSince1970
        let sub = endTime - beginRefreshingTime
        if sub < 1.5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (1.5 - sub)) {
                super.endRefreshing()
            }
        } else {
            super.endRefreshing()
        }
    }
}
