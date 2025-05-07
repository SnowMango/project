
import UIKit
import Then

class SeverListVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        titleName = "服务器"
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        view.addSubview(infoView)
        infoView.addSubview(ipView)
        infoView.addSubview(macView)
        infoView.addSubview(infoTitle)
        
        view.addSubview(fundsView)
        view.addSubview(transactionView)
    }
    
    func setupLayout() {
        infoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(10))
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
        }
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(wScale(15))
            make.left.equalTo(wScale(15))
        }
        
        ipView.snp.makeConstraints { make in
            make.top.equalTo(wScale(25))
            make.left.right.equalTo(0)
            make.height.equalTo(wScale(60))
        }
        macView.snp.makeConstraints { make in
            make.top.equalTo(ipView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(wScale(60))
            make.bottom.lessThanOrEqualTo(0)
        }

        fundsView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(wScale(4))
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(wScale(60))
        }
        
        transactionView.snp.makeConstraints { make in
            make.top.equalTo(fundsView.snp.bottom).offset(wScale(4))
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(wScale(60))
        }
    }
    
    lazy var infoView: UIView = {
        UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(8)
        }
    }()
    
    lazy var infoTitle: UILabel = {
        UILabel().then {
            $0.text = "服务器信息"
            $0.textColor = UIColor("#252525")
            $0.font = .kScale(16, weight: .medium)
        }
    }()
    
    lazy var ipView: ServerItemView = {
        ServerItemView().then {
            $0.count = 2
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(8)
            $0.upate("mini.compass", title: "IP地址：", desc: "xxxxxx", option: "复制")
        }
    }()
    
    lazy var macView: ServerItemView = {
        ServerItemView().then {
            $0.index = 1
            $0.count = 2
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(8)
            $0.upate("mini.compass", title: "MAC地址：", desc: "xxxxxx", option: "复制")
        }
    }()
    
    lazy var fundsView: ServerItemView = {
        ServerItemView().then {
            
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(8)
            $0.upate("mini.account", title: "资金账户：", desc: "xxxxxx", option: "修改")
        }
    }()
    
    lazy var transactionView: ServerItemView = {
        ServerItemView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(8)
            $0.upate("mini.account", title: "交易账户：", desc: "xxxxxx", option: "修改")
        }
    }()
}
