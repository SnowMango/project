
import UIKit
import Then

class BindBrokerageVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleName = "申请服务器"
        setupUI()
        setupLayout()
    }
    
    //MARK: -
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(flowView)
        
        contentView.addSubview(nameView)
        contentView.addSubview(accoutnView)
        contentView.addSubview(fundsView)
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        }
        flowView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(wScale(16))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(flowView.snp.bottom).offset(wScale(18))
            make.height.equalTo(wScale(48))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        accoutnView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(wScale(48))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        fundsView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(accoutnView.snp.bottom)
            make.height.equalTo(wScale(48))
            make.bottom.lessThanOrEqualTo(0)
        }
        
    }
    
    //MARK: -
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
            $0.contentInsetAdjustmentBehavior = .never
        }
    }()
    
    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .clear
        }
    }()
    
    lazy var flowView: BindFlowView = {
        return BindFlowView().then {
            $0.backgroundColor = .clear
        }
    }()
    
    lazy var nameView: FormInfoView = {
        return FormInfoView().then {
            $0.isRequired = true
            $0.backgroundColor = .white
            $0.index = 0
            $0.count = 3
            $0.titleLb.text = "券商名称"
            $0.descLb.text = "申港证券"
        }
    }()
    
    lazy var accoutnView: FormInputView = {
        return FormInputView().then {
            $0.isRequired = true
            $0.backgroundColor = .white
            $0.index = 1
            $0.count = 3
            $0.titleLb.text = "资金账户"
            $0.inputField.placeholder = "请输入资金账户"
        }
    }()
    
    lazy var fundsView: FormInputView = {
        return FormInputView().then {
            $0.isRequired = true
            $0.backgroundColor = .white
            $0.index = 2
            $0.count = 3
            $0.titleLb.text = "搭载资金"
            $0.inputField.text = "1000000"
        }
    }()
    
     
    
}
