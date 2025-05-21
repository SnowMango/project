
import UIKit
import Then
import Kingfisher
import RxCocoa

class AIStrategyVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenBackBtn = true
        hiddenNavigationBarWhenShow = true
        makeUI()
    }
    private func makeUI() {
       
        let bgIV = UIImageView(image: UIImage(named:"asset_bg"))
        view.addSubview(bgIV)
        bgIV.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(wScale(812))
        }
        
        let gifIV = UIImageView()
        view.addSubview(gifIV)
        if let path = Bundle.main.url(forResource: "aibot.logo", withExtension: "gif") {
            gifIV.kf.setImage(with: path,options: [.forceRefresh])
        }
        gifIV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(wScale(-100))
        }
        
        let strategyIV = UIImageView(image: UIImage(named:"ai.strategy"))
        view.addSubview(strategyIV)
        strategyIV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(wScale(40))
        }
        
        let descLb: UILabel = UILabel().then {
            $0.text = "你的线上AI量化专家"
            $0.textColor = UIColor("#298BFF")
            $0.font = .kScale(15)
        }
        view.addSubview(descLb)
        descLb.snp.makeConstraints { make in
            make.top.equalTo(strategyIV.snp.bottom).offset(wScale(10))
            make.centerX.equalToSuperview()
        }
        
        let chakanBtn = UIButton()
        chakanBtn.rx.tap.bind { _ in
            Router.shared.route("/ai/chat")
        }.disposed(by: disposeBag)
        
        chakanBtn.setTitle("问问AI", for: .normal)
        chakanBtn.setTitleColor(.white, for: .normal)
        chakanBtn.titleLabel?.font = .kScale(17, weight: .medium)
        chakanBtn.layer.cornerRadius = wScale(24)
        chakanBtn.backgroundColor = .kTheme
       
        view.addSubview(chakanBtn)
        chakanBtn.snp.makeConstraints { make in
            make.top.equalTo(descLb.snp.bottom).offset(wScale(38))
            make.left.right.equalToSuperview().inset(wScale(28))
            make.height.equalTo(wScale(48))
        }
    }
    
}

