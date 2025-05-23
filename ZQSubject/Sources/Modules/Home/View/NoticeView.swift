import UIKit
import MarqueeLabel

class NoticeView: UIView {
    
    //图片
    private lazy var imgView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "notice"))
        return img
    }()
    
    private lazy var marquee: MarqueeLabel = {
        let label = MarqueeLabel()
        label.textColor = UIColor("#FC4B4B")
        label.font = .kFontScale(12)
        label.speed = .rate(30)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTapGesture(self, sel: #selector(tap))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        backgroundColor = UIColor("#FFB0AA")?.withAlphaComponent(0.2)
        
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(wScale(25.5))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(wScale(12))
        }
        
        addSubview(marquee)
        marquee.text = "通知：通知通知通知通知通知通知通知通知通知通知通知通知通知通知"
        marquee.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(wScale(6))
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    var model: AppResource.ResourceData? = nil {
        didSet {
            if let summary = model?.message {
                isHidden = false
                marquee.text = summary + "   "//加几个空格，避免无线轮播的时候头尾紧挨在一起
            } else {
                isHidden = true
            }
        }
    }
    
}
