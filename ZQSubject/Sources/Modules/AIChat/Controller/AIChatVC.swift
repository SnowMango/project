
import UIKit
import Then
import RxCocoa
import RxSwift
import Combine

class AIChatVC: BaseViewController {
    var messages: [ChatMessage] = []
    
    @Published var isloading: Bool = false
    weak var loadingView: ChatLoadingCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNavigationBarWhenShow = true
        makeUI()
        
        input.doneBtn.rx.tap.subscribe(onNext: {[weak self] in
            self?.sendMessageToAI()
        }).disposed(by: disposeBag)
        
        self.$isloading.asObservable()
            .map({ !$0 })
            .bind(to: input.doneBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        requestAIhistory()
    }
    
    
    func sendMessageToAI(){
        guard let msg = input.textField.text, msg.count > 0 else { return }
        input.textField.resignFirstResponder()
        input.textField.text = ""
        if isloading { return }
        requsetAiChat(msg)
    }
    
    func startAnserLoading() {
        if isloading { return }
        isloading = true
        guard let loadingView = loadingView else { return  }
        let index = IndexPath(item: 0, section: 1)
        loadingView.loading(isloading)
        collectionView.performBatchUpdates(nil) { _ in
            self.collectionView.scrollToItem(
                at: index,
                at: .bottom,
                animated: true
            )
        }
    }
    
    
    func stopAnserLoading() {
        if !isloading { return }
        isloading = false
        guard let loadingView = loadingView else { return  }
        loadingView.loading(isloading)
    }
    
    func reloadMessages(_ items: [ChatMessage]) {
        guard items.count != 0 else { return }
        let indexs: [IndexPath] = items.enumerated().map { index, _ in
            IndexPath(item: index, section: 0)
        }
        self.showNewMessages(indexs)
    }
    
    func showNewMessages(_ indexs: [IndexPath]) {
        let last = IndexPath(item: self.messages.count - 1, section: 0)
        collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: indexs)
        }, completion: { _ in
            self.collectionView.scrollToItem(
                at: last,
                at: .bottom,
                animated: true
            )
        })
    }
    
    private func makeUI() {
        view.addSubview(bgIV)
        bgIV.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
        view.addSubview(chatBackBtn)
        chatBackBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            make.width.height.equalTo(36)
            make.left.equalTo(8)
        }
        view.addSubview(chatTitleLb)
        chatTitleLb.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(50))
            make.centerX.equalToSuperview()
        }
        view.addSubview(chatDescLb)
        chatDescLb.snp.makeConstraints { make in
            make.top.equalTo(chatTitleLb.snp.bottom).offset(wScale(12))
            make.centerX.equalToSuperview()
        }
        view.addSubview(collectionView)
        view.addSubview(input)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(chatDescLb.snp.bottom).offset(40)
            make.left.right.equalTo(0)
            make.bottom.equalTo(input.snp.top).offset(wScale(-10))
        }
        
        input.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(wScale(-6))
            make.centerX.equalToSuperview()
            make.left.equalTo(wScale(16))
            make.height.equalTo(wScale(48))
        }
    }

    lazy var bgIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "chat.bg")
        }
    }()
    
    lazy var chatBackBtn:UIButton = {
        return UIButton().then {
            $0.setImage(UIImage(named: "back_navbar"), for: .normal)
            $0.setImage(UIImage(named: "back_navbar"), for: .highlighted)
            $0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        }
    }()
    
    lazy var chatTitleLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#161A23")
            $0.font = .kScale(21, weight: .medium)
            $0.textAlignment = .center
            $0.text = "您好!我是你的AI量化助手！"
        }
    }()
    
    lazy var chatDescLb: UILabel = {
        UILabel().then {
            $0.textColor = UIColor("#7188B3")
            $0.font = .kScale(15, weight: .regular)
            $0.textAlignment = .center
            $0.text = "您想了解什么策略，请对我说"
        }
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: wScale(16), bottom: 20, right: wScale(16))
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(ChatMessageCell.self, forCellWithReuseIdentifier: "ChatMessageCell")
            $0.register(ChatLoadingCell.self, forCellWithReuseIdentifier: "ChatLoadingCell")
        }
    }()
    
    lazy var input: ChatInput = {
        ChatInput().then {
            $0.layer.cornerRadius = wScale(24)
            $0.textField.delegate = self
        }
    }()
}


extension AIChatVC :UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.messages.count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var iden: String = "ChatMessageCell"
        if indexPath.section > 0 {
            iden = "ChatLoadingCell"
        }
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: iden, for: indexPath)
        if let cell = cell as? ChatMessageCell {
            let item = self.messages[indexPath.row]
            cell.load(with: item)
        }
        if let cell = cell as? ChatLoadingCell {
            self.loadingView = cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}

extension AIChatVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 100 // 设置最大长度
        
        // 检测是否存在未确认的拼音输入
        if let markedRange = textField.markedTextRange, !markedRange.isEmpty {
            return true
        }
        guard let currentText = textField.text else { return true }
        // 计算新文本
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 校验长度
        if newText.count <= maxLength {
            return true
        }
        
        // 截断并更新文本
        textField.text = String(newText.prefix(maxLength))
        return false
    }
}

extension AIChatVC {
    
    func requsetAiChat(_ message: String) {
       
        if message.count > 0 {
            let user: ChatMessage = ChatMessage(role: .user, content: message)
            let lastIndex = self.messages.count
            let items = [user]
            self.messages += items
            let indexs: [IndexPath] = items.enumerated().map { index, _ in
                IndexPath(item: lastIndex + index, section: 0)
            }
            self.collectionView.insertItems(at: indexs)
        }
        
        self.startAnserLoading()
        NetworkManager.shared.request(GetTarget.aichat(message)) { (result: NetworkResult<String>) in
            self.stopAnserLoading()
            do {
                let respnose = try result.get()
                let ai: ChatMessage = ChatMessage(role: .assistant, content: respnose)
                let lastIndex = self.messages.count
                let items = [ai]
                self.messages += items
                let indexs: [IndexPath] = items.enumerated().map { index, _ in
                    IndexPath(item: lastIndex + index, section: 0)
                }
                self.showNewMessages(indexs)
            } catch NetworkError.server(_ ,let message){
                self.view.showText(message)
            } catch {
                self.view.showText("请求失败")
            }
        }
    }
    
    func requestAIhistory() {
        self.view.showLoading()
        NetworkManager.shared.request(GetTarget.chatHistory) { (result: NetworkResult<[ChatMessage]>) in
            self.view.hideHud()
            do {
                let respnose = try result.get()
                self.messages = respnose
                self.reloadMessages(respnose)
            } catch NetworkError.server(_ ,let message){
                self.view.showText(message)
            } catch {
                self.view.showText("历史记录获取失败")
            }
        }
    }
}
