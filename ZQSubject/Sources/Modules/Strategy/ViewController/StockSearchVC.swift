
import UIKit
import Then
import RxCocoa
import RxSwift

class StockSearchVC: BaseViewController {
    
    private var historyItems: [SearchStockModel] = []

    
    let resultVC = StockSearchResultVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        if let items = loadAllHistory() {
            self.historyItems = items
        }
        reloadData()
        requestHot()
    
        searchBar.searchTextFild.delegate = self
        searchBar.searchTextFild.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.requestSearch(text)
            })
            .disposed(by: disposeBag)
        
        searchBar.searchBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.searchBar.searchTextFild.resignFirstResponder()
            if let text = self?.searchBar.searchTextFild.text, text.count == 0 {
                self?.resultVC.dismiss()
            }
        }).disposed(by: disposeBag)
        
        cleanBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.showClean()
        }).disposed(by: disposeBag)
        
    }
    override func baseBack() {
        if !resultVC.view.isHidden {
            resultVC.dismiss()
            return
        }
        super.baseBack()
    }
    
    func showClean() {
        let alert = UIAlertController(title: "提示", message: "确定要删除历史记录吗？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            self.cleanHistroy()
            self.historyItems = []
            self.reloadData()
        }))
        
        self.present(alert, animated: true)
    }
    
    func reloadData() {
        historyStack.cleanAllSubs()
        for (index, item) in historyItems.enumerated() {
            let tag = makeTag(with: item.name)
            tag.tag = index
            historyStack.addArrangedSubview(tag)
            tag.isUserInteractionEnabled = true
            tag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTag)))
        }
    }
    
    @objc func tapTag(_ tap: UITapGestureRecognizer) {
        guard let v = tap.view else { return }
        let item = historyItems[v.tag]
        
        self.save(history: item)
        reloadData()

        Router.shared.route("/stock/detail",parameters: ["code": item.code,
                                                         "name": item.name])
    }
    
    func makeUI() {
        navigationItem.titleView = searchBar
        view.addSubview(resultVC.view)
        resultVC.dismiss(false)
        resultVC.tableView.delegate = self
        resultVC.view.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
       
        view.addSubview(historyTitleLb)
        historyTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(15))
            make.top.equalTo(wScale(20))
        }
        view.addSubview(cleanBtn)
        
        cleanBtn.snp.makeConstraints { make in
            make.right.equalTo(wScale(-5))
            make.width.height.equalTo(35)
            make.centerY.equalTo(historyTitleLb)
        }
        historyStack.frame = CGRect(x: 0, y: wScale(42), width: SCREEN_WIDTH, height: 0)
        view.addSubview(historyStack)
        
        view.addSubview(hotStockView)
        hotStockView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(historyStack.snp.bottom).offset(12)
        }
    }
    
    lazy var searchBar: StockSearchView = {
        return StockSearchView().then {
            $0.frame = CGRect(x: 0, y: 0, width: wScale(317), height: 34)
            $0.searchTextFild.placeholder = "请输入品种代码/名称/简拼"
        }
    }()
    
    lazy var historyTitleLb: UILabel = {
        UILabel().then {
            $0.text = "搜索历史"
            $0.textColor = .kText2
            $0.font = .kScale(16, weight: .bold)
        }
    }()
    
    lazy var cleanBtn: UIButton = {
        UIButton().then {
            $0.setImage(UIImage(named: "delete.grey"), for: .normal)
            $0.setImage(UIImage(named: "delete.grey"), for: .highlighted)
        }
    }()
    
    func makeTag(with tag: String) -> InsetLabel {
        InsetLabel().then {
            $0.textColor = .kText2
            $0.text = tag
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.contentInsets = .init(top: 10, left: 12, bottom: 10, right: 12)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
       }
    }
    
    lazy var historyStack: TagStackView = {
        TagStackView().then {
            $0.contentInset = .init(top: 12, left: wScale(14), bottom: 12, right: wScale(14))
        }
    }()
    
    lazy var hotStockView: HotStockView = {
        HotStockView().then {
            $0.backgroundColor = UIColor("#FCFAED")
        }.gradient {
            $0.colors = [UIColor(0xFFFFFF).cgColor,UIColor(0xFCFAED).cgColor]
            $0.startPoint = CGPoint(x: 0.5, y: 1)
            $0.endPoint = CGPoint(x: 0.5, y: 0)
            $0.locations = [0, 1]
        }
    }()
}

extension StockSearchVC {

    func loadAllHistory() -> [SearchStockModel]?  {
        guard let profile = AppManager.shared.profile else { return nil }
        let key = "key-histroy-\(profile.id)"
        guard let jsonData = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        guard let response = try? JSONDecoder().decode([SearchStockModel].self, from: jsonData) else { return nil}
        return response
    }
    
    func save(history: SearchStockModel) {
        if let index = self.historyItems.firstIndex(of: history) {
            self.historyItems.remove(at: index)
        }
        if self.historyItems.count >= 20 {
            self.historyItems.removeLast()
        }
        var save: [SearchStockModel] = []
        save.append(history)
        save += self.historyItems
       
        guard let profile = AppManager.shared.profile else { return  }
        let key = "key-histroy-\(profile.id)"
        self.historyItems = save
        guard let data = try? JSONEncoder().encode(save) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func cleanHistroy() {
        guard let profile = AppManager.shared.profile else { return  }
        let key = "key-histroy-\(profile.id)"
        kUserDefault.removeObject(forKey: key)
    }
}

extension StockSearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.resultVC.show()
    }
}

extension StockSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.searchTextFild.resignFirstResponder()
        let stock = self.resultVC.results[indexPath.row]
        
        self.save(history: stock)
        reloadData()
        Router.shared.route("/stock/detail",parameters: ["code": stock.code,
                                                         "name": stock.name])
    }
}
extension StockSearchVC {
    
    func requestSearch(_ text:String) {
        if self.resultVC.dismissing{
            return
        }
        if text.count == 0 {
            self.resultVC.results.removeAll()
            self.resultVC.keyword = nil
            self.resultVC.tableView.reloadData()
            return
        }
        NetworkManager.shared.request(AuthTarget.stockSearch(keyword: text)) { (result: NetworkResult<[SearchStockModel]>) in
            do {
                let response = try result.get()
                self.resultVC.results = response
                self.resultVC.keyword = text
                self.resultVC.tableView.reloadData()
            } catch {
                
            }
        }
    }
    
    func requestHot() {
        NetworkManager.shared.request(AuthTarget.stockHot) { (result:NetworkResult<[HotStockModel]>) in
            do {
                let response = try result.get()
                self.hotStockView.items = response
                self.hotStockView.reloadData()
            } catch {
                
            }
        }
    }
}

//MARK: StockSearchResultVC
class StockSearchResultVC: UITableViewController {
    
    var results: [SearchStockModel] = []
    var keyword: String?
    var dismissing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = 40
            
            $0.register(StockSearchResultCell.self, forCellReuseIdentifier: "StockSearchResultCell")
           
            $0.showsVerticalScrollIndicator = false
        
            $0.separatorInset = .init(top: 0, left: 14, bottom: 0, right: 14)
            $0.separatorStyle = .singleLine
            $0.separatorColor = .kBackGround
    
            $0.backgroundColor = .white
        }
    }
    
    func show(_ animated: Bool = true) {
        self.dismissing = false
        self.view.superview?.bringSubviewToFront(self.view)
        if !self.view.isHidden {
            return
        }
        self.view.isHidden = false
        if !animated {
            self.view.alpha = 1;
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.curveEaseOut], animations: {
            self.view.alpha = 1;
        })
    }
    func dismiss(_ animated: Bool = true) {
        self.dismissing = true
        self.keyword = nil
        self.results.removeAll()
        self.tableView.reloadData()
        if !animated {
            self.view.alpha = 1
            self.view.isHidden = true
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: [.curveEaseOut], animations: {
            self.view.alpha = 0;
        }) { _ in
            self.view.alpha = 1;
            self.view.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockSearchResultCell", for: indexPath) as! StockSearchResultCell
        cell.selectionStyle = .none
        let item = results[indexPath.row]
        cell.reload(item, with: self.keyword)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
