import UIKit
import Kingfisher

class SplashAD: UIView {
    
    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        imageView.addGestureRecognizer(tap)
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return imageView
    }()
    
    private lazy var skipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("\(cutDownTime+1)s跳过", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: wScale(12))
        btn.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.5)
        btn.layer.cornerRadius = wScale(15)
        btn.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        adImageView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kStatusBarH() + wScale(22))
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(wScale(60))
            make.height.equalTo(wScale(30))
        }
        return btn
    }()
    
    let downloader = KingfisherManager.shared.downloader;
    
    ///倒计时时间
    private var cutDownTime: Int = 3
    
    private var timer: Timer?
    
    ///广告链接
    private var adUrl: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    convenience init(frame: CGRect = UIScreen.main.bounds, imageUrl: String, adUrl: String?, didRemoved: ((Bool) -> ())?) {
        self.init(frame: frame)
        
        self.didRemoved = didRemoved
        self.adUrl = adUrl
        // 超时时间
        downloader.downloadTimeout = 6;
        
        adImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage.init(named: "as_qdt"), options: nil, progressBlock: nil) { (re) in
            switch re {
            case.success(_):
                self.skipBtn.isHidden = false
                self.isUserInteractionEnabled = true
                self.invaTimer()
                self.startTimer()
            case.failure(_):
                self.skipAction()
            }
        }
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    private func removeADView(didTap: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { (finish) in
            self.removeFromSuperview()
            self.didRemoved?(didTap)
            //防止在倒计时到0的时候又点击广告,导致走了两遍removeADView
            self.didRemoved = nil
        }
        layoutIfNeeded()
    }
    
    private var didRemoved: ((Bool) -> ())?
    
    //var tapCallBack: (() -> Bool)?
    @objc func tapAction() {
        invaTimer()
        removeADView(didTap: true)
    }
    
    @objc func skipAction() {
        invaTimer()
        removeADView(didTap: false)
    }
    
    private func startTimer() {
        handleTimer()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc private func handleTimer() {
        //0秒的时候也显示出来,所以这段代码拿到if外面
        if isUserInteractionEnabled == true {
            skipBtn.setTitle("\(cutDownTime)s跳过", for: .normal)
        }
        if cutDownTime <= 0 {
            timer?.invalidate()
            timer = nil
            removeADView(didTap: false)
        }
        cutDownTime -= 1
    }
    
    private func invaTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        downloader.downloadTimeout = 15;
        print("adPage_deinit")
    }
}
