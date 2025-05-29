import MJRefresh
import Kingfisher

private let footerIdleText = "上拉加载"
private let footerRefreshingText = "正在加载"
private let footerPullingText = "松开加载更多内容"
private let footerNoMoreDataText = "别拉了，没有了"

/// 上拉加载文字显示
class RefreshFooter: MJRefreshBackNormalFooter {
    lazy var refreshingImage: ImageDataProvider = {
        let path = Bundle.main.path(forResource:"refresh_blue", ofType:"gif")
        let url = URL(fileURLWithPath: path!)
        let provider = LocalFileImageDataProvider(fileURL: url)
        return provider
    }()
    
    lazy var custemImage: UIImageView = {
        let custemImage = UIImageView(image: UIImage(named: "refresh_start"))
        custemImage.kf.setImage(with: refreshingImage)
        return custemImage
    }()

    var stateLabelOffsetX: CGFloat = 13
    
    override func prepare() {
        super.prepare()
        
        stateLabel?.textColor = UIColor.init(r: 49, g: 87, b: 182)
        
        labelLeftInset = 0
        
        setTitle(footerIdleText, for: .idle)
        setTitle(footerRefreshingText, for: .refreshing)
        setTitle(footerPullingText, for: .pulling)
        setTitle(footerNoMoreDataText, for: .noMoreData)
        
        arrowView?.alpha = 0
        arrowView?.mj_size = CGSize(width: 13, height: 13)

        if let _ = arrowView{
            addSubview(custemImage)
        }
        
    }
    
    override var state: MJRefreshState{
        didSet{
            switch state {
            case .refreshing:
                self.custemImage.kf.setImage(with: refreshingImage)
                self.custemImage.alpha = 1
                stateLabelOffsetX = 13
            default:
                self.custemImage.kf.setImage(with: refreshingImage)
                self.custemImage.alpha = 0
                stateLabelOffsetX = 0
            }
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if let _ = arrowView{
            custemImage.center = arrowView!.center
        }
        ///实时隐藏菊花
        loadingView?.alpha = 0
        
        self.stateLabel?.mj_x += stateLabelOffsetX
    }
}






class RefreshGifFooter: MJRefreshAutoGifFooter {
    
    lazy var animatingImgv: UIImageView = {
        let imgv = UIImageView(image: UIImage(named: "loading_more"))
        return imgv
    }()
    
    lazy var loadingView: UIView = {
        let v = UIView()
        v.isHidden = true
        
        let lb = UILabel()
        lb.font = .kScale(12)
        lb.textColor = .kText2
        lb.text = "玩命加载中"
        v.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        v.addSubview(animatingImgv)
        animatingImgv.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(lb.snp.right).offset(wScale(15))
            make.right.equalToSuperview()
        }
        
        return v
    }()
    
    lazy var noMoreDataView: UIView = {
        let v = UIView()
        v.isHidden = true
        
        let lb = UILabel()
        lb.font = .kScale(12)
        lb.textColor = .kText2
        lb.text = "我是有底线的"
        v.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let line1 = UIView()
        line1.backgroundColor = UIColor(r: 118, g: 133, b: 144, alpha: 0.5)
        v.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(wScale(26))
            make.right.equalTo(lb.snp.left).offset(wScale(-16))
        }
        
        let line2 = UIView()
        line2.backgroundColor = UIColor(r: 118, g: 133, b: 144, alpha: 0.5)
        v.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(0.5)
            make.right.equalToSuperview().inset(wScale(26))
            make.left.equalTo(lb.snp.right).offset(wScale(16))
        }
        
        return v
    }()
    
    private func startRefreshing() {
        let animate = CABasicAnimation()
        animate.fromValue = 0
        animate.toValue = Double.pi * 2
        animate.keyPath = "transform.rotation.z"
        animate.repeatCount = MAXFLOAT
        animate.duration = 0.5
        animatingImgv.layer.add(animate, forKey: "rotation")
        
        loadingView.isHidden = false
        noMoreDataView.isHidden = true
    }
    
    private func setNoMoreData() {
        animatingImgv.layer.removeAnimation(forKey: "rotation")
        
        loadingView.isHidden = true
        noMoreDataView.isHidden = false
    }
    
    private func setIdle() {
        animatingImgv.layer.removeAnimation(forKey: "rotation")
        loadingView.isHidden = true
        noMoreDataView.isHidden = true
    }
    
    override func prepare() {
    super.prepare()
        
        setTitle("", for: .idle)
        setTitle("", for: .refreshing)
        setTitle("", for: .pulling)
        setTitle("", for: .noMoreData)
        
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(noMoreDataView)
        noMoreDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 解决上拉加载显示位置的问题
        ignoredScrollViewContentInsetBottom = 0
        
    }
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .refreshing:
                startRefreshing()
            case .noMoreData:
                setNoMoreData()
            case .idle:
                setIdle()
            default:
                break
            }
        }
    }
}
