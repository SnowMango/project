
import UIKit

class AppGuideVC: BaseViewController {
    override func viewDidLoad() {
        setup()
    }
    
    func done() {
        kUserDefault.setValue("install", forKey: UserDefaultKey.firstInstall.rawValue)
        Router.shared.route(.login)
    }
    
    func setup() {
        self.view.addSubview(guidePageView)
        guidePageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    lazy var guidePageView: GuidePageView = {
        let guideView = GuidePageView(images: ["guide_0", "guide_1"], isHiddenSkipBtn: true, isHiddenStartBtn: false, isHiddenPageControl: false) { [weak self] in
            self?.done()
        }
        guideView.pageControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(wScale(100))
            make.bottom.equalToSuperview().inset(kSafeBottomH()+wScale(40))
            make.height.equalTo(wScale(10))
        }
        
        guideView.startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(guideView.pageControl.snp.top).offset(-wScale(20))
            make.width.equalTo(wScale(160))
            make.height.equalTo(wScale(40))
        }
        guideView.startButton.setTitle("立即体验", for: .normal)
        guideView.startButton.backgroundColor = .kTheme
        guideView.startButton.layer.cornerRadius = wScale(20)
        guideView.startButton.layer.borderWidth = 0
        return guideView
    }()
}
