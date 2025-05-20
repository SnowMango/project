
import UIKit
import WMZPageController

class CouponsVC: WMZPageController {

    lazy var titleParam: WMZPageParam = {
        let pageParam = PageParam()
        pageParam.wMenuDefaultIndex = 0
        pageParam.wMenuHeight = wScale(44)
        pageParam.wTopSuspension = true
        pageParam.wBounces = true
        pageParam.wMenuAnimal = PageTitleMenuPDD
        pageParam.wMenuTitleSelectUIFont = .kFontScale(16)
        pageParam.wMenuTitleUIFont = .kFontScale(16)
        pageParam.wMenuTitleColor = .kText1
        pageParam.wMenuTitleSelectColor = .kText2
        pageParam.wMenuIndicatorColor = .kTheme
        pageParam.wMenuIndicatorHeight = 4
        pageParam.wMenuIndicatorWidth = wScale(22)
        pageParam.wMenuIndicatorRadio = 2
        pageParam.wMenuIndicatorY = wScale(9)
        pageParam.wMenuBgColor = .kBackGround
        pageParam.wMenuInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
      
        return pageParam
    }()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
     
    }

    
}


