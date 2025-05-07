
import UIKit
import Then

class UserQA1VC: BaseViewController {
    
    typealias QueMeta = (icon: String, title: String, desc: String)

    var answers: [QueMeta] = []
    var selectIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor("#E4EAF6")
        hiddenBackBtn = true
        setupUI()
        setupLayout()
        answers = [QueMeta("qa.icon.1","学生","学习充电中"),
                   QueMeta("qa.icon.2","上班族","普通职员"),
                   QueMeta("qa.icon.3","管理者","管理层与专家"),
                   QueMeta("qa.icon.4","全职顾家","专职照顾家庭"),
                   QueMeta("qa.icon.5","养老退休","颐养天年中"),
                   QueMeta("qa.icon.6","其他","自媒体/个体户/自由职业者/其他"),]
        
        quesionInfoLb.text = "为匹配合适的服务，需了解您的基本情况"
        quesionTitleLb.text = "以下哪个描述最符合您？"
    }
    
    func showNext() {
        let answer = answers[selectIndex].title
        let vc = UserQA2VC()
        vc.commoit.append(JSON(["question":"1", "answer":answer]))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        view.addSubview(quesionInfoLb)
        view.addSubview(quesionTitleLb)
        view.addSubview(collectionView)
    }
    
    func setupLayout() {
        
        quesionInfoLb.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(45))
            make.centerX.equalToSuperview()
        }
        
        quesionTitleLb.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(0)
            make.top.equalTo(quesionInfoLb.snp.bottom).offset(wScale(12))
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(quesionInfoLb.snp.bottom).offset(wScale(30))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 0
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = .init(top: wScale(14), left: wScale(14), bottom: wScale(10), right: wScale(14))

            $0.register(UserQA1Cell.self, forCellWithReuseIdentifier: "UserQA1Cell")
        }
    }()
    
}
extension UserQA1VC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = answers[indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"UserQA1Cell",
                                                       for: indexPath) as! UserQA1Cell
        
        cell.show(item.icon, with: item.title, desc: item.desc, select: selectIndex == indexPath.row)
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (CGRectGetWidth(collectionView.frame) - wScale(14)*2 - wScale(12))/2.0
        return CGSize(width: width,
                     height: wScale(85))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        collectionView.reloadData()
        showNext()
    }

}


