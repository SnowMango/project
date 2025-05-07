
import UIKit
import Then

class MineGroupCell: RadiusCollectionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func linkBtnClick() {
        guard let profile = AppManager.shared.profile else { return }
        if let url = profile.salesStaffInfo?.salespersonQrCode {
            let alert = WindowAlert(title: "截图微信扫码进群", content: "添加客服，加入投资者交流群", url: url, actionTitle: "在线客服", alertType: .join)
            alert.doneCallBack = {
                JumpManager.jumpToWeb(AppLink.support.path)
            }
            alert.show()
        }
        
    }
    
    func setupUI() {
        
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLb)
        contentView.addSubview(descLb)
        contentView.addSubview(linkBtn)
        titleLb.text = "进群交流"
        descLb.text = "投资分享与解读"
        linkBtn.setTitle("立即进群", for: .normal)
        
        iconIV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(wScale(12))
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(wScale(11))
            make.centerY.equalToSuperview().offset(wScale(-14))
        }
        
        descLb.snp.makeConstraints { make in
            make.left.equalTo(iconIV.snp.right).offset(wScale(11))
            make.centerY.equalToSuperview().offset(wScale(12))
        }
        
        linkBtn.snp.makeConstraints { make in
            make.right.equalTo(wScale(-12))
            make.centerY.equalToSuperview()
            make.width.equalTo(wScale(98))
            make.height.equalTo(wScale(29))
        }
    }
    
    lazy var iconIV: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "chat_group")
        }
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var descLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .medium)
        }
    }()
    
    lazy var linkBtn: UIButton = {
        return UIButton(type: .custom).then {
            $0.titleLabel?.font = .kScale(12, weight: .medium)
            $0.backgroundColor = .kTheme
            $0.layer.cornerRadius = wScale(29)/2.0
            $0.addTarget(self, action: #selector(linkBtnClick), for: .touchUpInside)
        }
    }()
}

