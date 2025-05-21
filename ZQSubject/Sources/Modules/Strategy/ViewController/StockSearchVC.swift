
import UIKit
import Then
import RxCocoa
import RxSwift

class StockSearchVC: BaseViewController {
    
    
    let textFieldText = BehaviorRelay(value: "")
    
    var hots: [String] = ["aa"]
    
    let resultVC = StockSearchResultVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        // 将UITextField的文本变化绑定到BehaviorRelay中，以便可以在其他地方访问最新的文本值
        searchBar.searchTextFild.rx.text.orEmpty
            .bind(to: textFieldText)
            .disposed(by: disposeBag)
               
        // 应用防抖操作符，例如在用户停止输入0.5秒后打印文本值
        searchBar.searchTextFild.rx.text.orEmpty
            .filter({ $0.count > 0 })
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.requestSearch(text)
            })
            .disposed(by: disposeBag)
        
        searchBar.searchBtn.rx.tap.subscribe { [weak self] _ in
            self?.view.endEditing(true)
            self?.resultVC.dismiss()
        }.disposed(by: disposeBag)
    }

    func requestSearch(_ text:String) {
        Logger.debug("search = \(text)")
        resultVC.results.append(text)
        resultVC.show()
        resultVC.tableView.reloadData()
    }
    
    func makeUI() {
        navigationItem.titleView = searchBar
        view.addSubview(resultVC.view)
        resultVC.dismiss(false)
        resultVC.view.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    lazy var searchBar: StockSearchView = {
        return StockSearchView().then {
            $0.frame = CGRect(x: 0, y: 0, width: wScale(317), height: 34)
            $0.searchTextFild.placeholder = "请输入品种代码/名称/简拼"
        }
    }()
    
}


class StockSearchResultVC: UITableViewController {
    var results: [String] = ["Apple", "Banana", "Orange", "Grape"]
    var keyword: String?
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
        cell.titleLb.text = results[indexPath.row]
        cell.codeLb.text = results[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
