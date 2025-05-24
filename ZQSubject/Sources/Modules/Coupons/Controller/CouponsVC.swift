
import UIKit
import WMZPageController
import Then

class CouponsVC: WMZPageController {
    
    var mapSubs: [String: CouponListVC] = [:]
    lazy var backBtn:UIButton = {
        return UIButton().then {
            $0.setImage(UIImage(named: "back_navbar"), for: .normal)
            $0.setImage(UIImage(named: "back_navbar"), for: .highlighted)
            $0.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            $0.contentHorizontalAlignment = .left
            $0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        }
    }()
    
    @objc func backButtonAction() {
        view.endEditing(true)
        baseBack()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.upSc.backgroundColor = .kBackGround

    }
    // 子类重载
    func baseBack(){
        if self.navigationController?.viewControllers.first == self{
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.title = "我的优惠券"
        self.param = makeParam()
        self.param.wMenuTitleWidth = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)).width/3.0
        self.param.wViewController = { index in
            let vc = CouponListVC()
            vc.status = index
            return vc
        }
    }

    func makeParam() -> WMZPageParam {
        PageParam().then {
            $0.wMenuDefaultIndex = 0
            $0.wMenuHeight = wScale(44)
//            $0.wTopSuspension = true
//            $0.wBounces = true
            $0.wTitleArr = ["未使用","已使用","已过期"]
            
            $0.wMenuAnimal = PageTitleMenuPDD
            $0.wMenuTitleSelectUIFont = .kScale(15, weight: .medium)
            $0.wMenuTitleUIFont = .kScale(15, weight: .medium)
            $0.wMenuTitleColor = .kText2
            $0.wMenuTitleSelectColor = .kTheme
            
            $0.wMenuIndicatorColor = .kTheme
            $0.wMenuIndicatorHeight = 4
            $0.wMenuIndicatorWidth = wScale(27)
            $0.wMenuIndicatorRadio = 2
            $0.wMenuBgColor = .kBackGround
            $0.wMenuInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        }
    }
}


