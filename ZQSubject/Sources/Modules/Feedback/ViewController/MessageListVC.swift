
import UIKit
import Then
import MJRefresh

class MessageListVC: BaseViewController {
   
    var messages: [MessageModel] = []
    var currentPage:Int = 1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        titleName = "消息中心"
        setupUI()
        setupLayout()
        view.backgroundColor = .white
//        let btn = UIButton(frame: .init(x: 0, y: 0, width: 40, height: 40))
//        btn.setImage(UIImage(named: "message.clear"), for: .normal)
//        btn.addTarget(self, action:  #selector(clearRightClick), for: .touchDown)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        tableView.mj_header?.beginRefreshing()
        self.reportRead()
    }
    
    @objc func clearRightClick() {
        
    }
    
    func requestMore()  {
        requestList(page: currentPage + 1,true)
    }
    
    func requestNew()  {
        requestList(page: 1, false)
    }
    
    func requestList(page:Int, _ more: Bool = false) {
    
        NetworkManager.shared.request(AuthTarget.messageList(current: page, size: 10)) { (result: NetworkPageResult<MessageModel>) in
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.mj_header?.endRefreshing()
            do {
                self.currentPage = page
                let response = try result.get()
                if more {
                    if response.records.count > 0 {
                        self.messages += response.records
                    }else {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else {
                    self.messages = response.records
                }
    
                self.tableView.reloadData()
            } catch NetworkError.server(_ ,let message){
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误刷新失败")
            }
        }
    }
    
    func reportRead() {
        NetworkManager.shared.request(AuthTarget.changeMsgRead) { (result:OptionalJSONResult) in
            
        }
    }
    //MARK: setup
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.mj_header = RefreshHeader(refreshingBlock: { [weak self] in
            self?.requestNew()
        })
        tableView.mj_footer = RefreshFooter(refreshingBlock: {[weak self] in
            self?.requestMore()
        })
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain).then {
            
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = wScale(66)
            $0.registerCell(cls: MessageListCell.self, identifier: "MessageListCell")
            $0.showsVerticalScrollIndicator = false
        
            $0.separatorInset = .init(top: 0, left: wScale(24), bottom: 0, right: wScale(24))
            $0.separatorStyle = .singleLine
            $0.separatorColor = .kBackGround
        }
    }()
}

extension MessageListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        cell.selectionStyle = .none
        cell.reload(with: item)
        return cell
    }

}
