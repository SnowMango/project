
import UIKit
import Then

class UserQA2VC: BaseViewController {
    typealias QueMeta = (icon: String, title: String)
    var answers: [QueMeta] = []
    var selectIndex: Int = 0
    var commoit: [JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor("#E4EAF6")
        setupUI()
        setupLayout()
        answers = [("qa.none.user","从没炒过股"),
                   ("qa.noob","刚开始炒股"),
                   ("qa.old","老股民"),]
        
        quesionInfoLb.text = "这将帮助我们为你提供更个性化的服务"
        quesionTitleLb.text = "你是否有炒股经验?"
    }
    
    func showNext() {
        let vc = UserQA3VC()
        let answer = answers[selectIndex].title
        commoit.append(JSON(["question":"2", "answer":answer]))
        vc.commoit = commoit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        view.addSubview(quesionInfoLb)
        view.addSubview(quesionTitleLb)
        view.addSubview(collectionView)
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
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: wScale(27), bottom: wScale(0), right: wScale(27))
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.register(UserQA2Cell.self, forCellWithReuseIdentifier: "UserQA2Cell")
        }
    }()
    
}
extension UserQA2VC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = answers[indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"UserQA2Cell",
                                                       for: indexPath) as! UserQA2Cell
        cell.show(item.icon, with: item.title, select: selectIndex == indexPath.row)
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGRectGetWidth(collectionView.frame) - wScale(27)*2,
                     height: wScale(80))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        collectionView.reloadData()
        showNext()
    }

}

