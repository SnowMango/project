import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.hidesBottomBarWhenPushed = true
    }
    
    func bottomBarWhenPushed(_ hides: Bool) -> Self {
        self.hidesBottomBarWhenPushed = hides
        return self
    }
    
    // MARK: - properties
    lazy var noNetView: NoNetTips = {
        let x = NoNetTips()
        x.action = {[weak self] in
            let vc = NetHintVC()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        x.isHidden = true
        self.view.addSubview(x)
        self.view.bringSubviewToFront(x)
        return x
    }()
    // 提供给外界设置的额外高度
    var noNetViewExtraHeight: CGFloat = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if kAppManager.currentNetState == true {return}
        self.view.bringSubviewToFront(noNetView)
    }
    
    lazy var backBtn:UIButton = {
        let backButtonImage = UIImage(named: "back_navbar")
        let backButton =  UIButton.init(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.setImage(backButtonImage, for: .highlighted)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return backButton
    }()
    
    var titleName:String? {
        didSet {
            self.navigationItem.title = titleName
        }
    }
    
    var hiddenBackBtn:Bool? {
        didSet {
            if hiddenBackBtn! {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.hidesBackButton = true
            } else {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = .kBackGround
        
        configNavBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkState), name: .reachabilityChanged, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if kAppManager.currentNetState == false {
            showNetStatusView(true)
        }
    }
    
    private func showNetStatusView(_ show: Bool) {
        noNetView.isHidden = !show
        if !show { return }
        if let x = self.navigationController?.navigationBar.isHidden, x {
            noNetView.frame = CGRect(x: 0, y: kSafeTopH()+noNetViewExtraHeight, width: SCREEN_WIDTH, height: 34)
        } else {
            noNetView.frame = CGRect(x: 0, y: noNetViewExtraHeight, width: SCREEN_WIDTH, height: 34)
        }
    }
    
    ///网络状态监听
    @objc func networkState() {
        let state = AppManager.shared.currentNetState
        showNetStatusView(!state)
    }
        
    // MARK: - func
    @objc func backButtonAction() {
        view.endEditing(true)
        baseBack()
    }
    // 子类重载
    func baseBack(){
        if self.navigationController?.viewControllers.first == self{
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func configNavBar() {
        //设置标题颜色与字体
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.black ,NSAttributedString.Key.font : UIFont.kBoldScale(18)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : Any]
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(type(of: self)) __ deinit")
    }
}



class NoNetTips: UIView {
    
    var action: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .white
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(r: 250, g: 228, b: 230)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        bgView.addGestureRecognizer(tap)
        
        let icon = UIImageView(image: UIImage.init(named: "as_as_net_worn"))
        bgView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(wScale(20))
            make.width.height.equalTo(wScale(14))
        }
        
        let label = UILabel()
        label.font = .kScale(13)
        label.textColor =  UIColor.init(r: 208, g: 2, b: 27)
        label.text = "当前网络不可用，请检查您的网络设置。"
        bgView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(wScale(5))
            make.centerY.equalToSuperview()
        }
        
    }
    
    @objc func tapView() {
        action?()
    }
}
