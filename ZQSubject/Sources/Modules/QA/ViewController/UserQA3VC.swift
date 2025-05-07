
import UIKit
import Then

class UserQA3VC: BaseViewController {

    var answers: [String] = []
    var selectIndexs: [Int] = []
    
    var commoit:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor("#E4EAF6")
        setupUI()
        setupLayout()
        answers = ["使用平台量化策略","学习量化投资","浏览财经内容","随便逛逛"]
        
        quesionInfoLb.text = "可多选，希望我们能够不负期望"
        quesionTitleLb.text = "你希望在量界做什么？"
    }
    
    func commitAnswer() {
        var temp: [String] = []
        for (index, value) in answers.enumerated() {
            if selectIndexs.contains(index){
                temp.append(value)
            }
        }
        self.view.showLoading()
        var list = self.commoit
        list.append(["question":"3", "answer":temp.joined(separator: ",")])
        NetworkManager.shared.request(AuthTarget.saveQA(list)) { (result: OptionalJSONResult) in
            self.view.hideHud()
            switch result {
            case .success(_):
                Router.shared.route(.home)
            case .failure(let error):
                switch error {
                case .server(_,let message):
                    self.view.showText(message)
                default:
                    self.view.showText("网络连接失败")
                }
            }
        }
    }
    
    @objc func startBtnClick() {
        if selectIndexs.count == 0 {
            self.view.showText("请至少选择一项", isUserInteractionEnabled: true)
            return
        }
        commitAnswer()
    }
    
    func setupUI() {
        view.addSubview(quesionInfoLb)
        view.addSubview(quesionTitleLb)
        view.addSubview(collectionView)
        view.addSubview(startBtn)
        
    }
    
    func setupLayout() {
        
        quesionTitleLb.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(45))
            make.centerX.equalToSuperview()
        }
        
        quesionInfoLb.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(0)
            make.top.equalTo(quesionTitleLb.snp.bottom).offset(wScale(12))
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(quesionInfoLb.snp.bottom).offset(wScale(30))
            make.bottom.equalTo(startBtn.snp.top).offset(-20)
        }
        
        startBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.right.equalTo(wScale(-28))
            make.left.equalTo(wScale(28))
            make.height.equalTo(48)
        }
    }
    
    lazy var quesionInfoLb: UILabel = {
        return UILabel().then {
            $0.textColor = UIColor("#969DAB")
            $0.font = .kScale(13)
        }
    }()
    
    lazy var quesionTitleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(18, weight: .medium)
        }
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: wScale(28), bottom: wScale(10), right: wScale(28))
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.register(UserQA3Cell.self, forCellWithReuseIdentifier: "UserQA3Cell")
        }
    }()
    
    lazy var startBtn = {
        UIButton(type: .custom).then {
            $0.setTitle("财富之旅即将开始", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(16)
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        }
    }()

    
}
extension UserQA3VC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = answers[indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"UserQA3Cell",
                                                       for: indexPath) as! UserQA3Cell
        cell.show(item, select: selectIndexs.contains(indexPath.row))
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame) - wScale(28)*2,
                     height: wScale(70))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
       
        if selectIndexs.contains(index) {
            selectIndexs.removeAll { $0 == index}
        }else{
            selectIndexs.append(index)
        }
        collectionView.reloadData()
    }

}


