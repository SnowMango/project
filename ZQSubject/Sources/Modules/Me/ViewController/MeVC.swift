
import UIKit
import Kingfisher
import WebKit
import Then
import AVFoundation

class MeVC: BaseViewController {
    
    private var mineData: MineModel?
    var sections: [Array<MineItemModel>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenBackBtn = true
        fd_prefersNavigationBarHidden = true
        
//        loadLocalData()
        initUI()
        
        sections.append([.Account])
        sections.append([.Group])
    
        sections.append([.Setting,
                         .Feedback,
                         .Support,
                         .RealAuth,
                         .Assessment,
                         .Servers,
                         .Orders])
        
//        sections.append([.Banner])
    
        NotificationCenter.default.addObserver(self, selector: #selector(updataUserProfile), name: UserProfileDidUpdateName, object: nil)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        checkUnread()
    }

    @objc private func updataUserProfile() {
        reloadData()
    }
    
    @objc private func gotoMessageCenter() {
        Router.shared.route("/message")
//        Tools.getTopVC().navigationController?.show(BuildStrategyVC(), sender: nil)
    }
    
    func reloadData() {
        
    }
    
    @objc private func changeAvatar() {
        let alert = UIAlertController(title: nil, message: "是否要修改头像？", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "从相册上传", style: .default, handler: {[weak self] _ in
            self?.pickerImage(form: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: {[weak self] _ in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.pickerImage(form: .camera)
                    } else {
                        self?.view.showText("未相机授权")
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickerImage(form source: UIImagePickerController.SourceType ) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .overFullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    private func loadData() {
        AppManager.shared.refreshUserInfo()
    }
    
    private func checkUnread() {
        
        NetworkManager.shared.request(AuthTarget.unreadMsg) { (result: JSONResult) in
            do {
                let response = try result.get()
                let unreadCount = response["unreadCount"].intValue
                let _ = response["readCount"].intValue
                self.redPoint.isHidden = unreadCount == 0
            } catch {
                
            }
        }
    }
    
    func uploadImage(_ pic: UIImage) {
        guard let jpeg = pic.jpegData(compressionQuality: 0.3) else { return }
        self.view.showLoading()
        NetworkManager.shared.request(AuthTarget.upload(jpeg)) { (result:JSONResult) in
            self.view.hideHud()
            do {
                let response = try result.get()
                if let path = response.object as? String {
                    self.updateUserAvatar(path)
                }else{
                    self.view.showText("图片上传失败")
                }
            } catch NetworkError.server(_,let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误，上传失败")
            }
        }
    }
    
    func updateUserAvatar(_ url: String) {
        self.view.showLoading()
        NetworkManager.shared.request(AuthTarget.updateAvatar(url)) { (result:OptionalJSONResult) in
            self.view.hideHud()
            switch result {
            case .success(_):
                self.view.showText("头像更新成功", isUserInteractionEnabled: true)
                AppManager.shared.profile?.avatar = url
                self.avatarIV.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "avatar.default"))
            case .failure(let error):
                switch error {
                case .server(_,let message):
                    self.view.showText(message)
                default:
                    self.view.showText("网络错误，提交失败")
                }
            }
        }
    }
    
    private func initUI() {
        view.addSubview(backgourdIV)
       
        backgourdIV.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(wScale(381))
        }
        
        let msgBtn = UIButton(type: .custom)
        msgBtn.setImage(UIImage(named: "message"), for: .normal)
        msgBtn.addTarget(self, action: #selector(gotoMessageCenter), for: .touchUpInside)
        view.addSubview(msgBtn)
        msgBtn.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(50))
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview().inset(wScale(5))
        }
        msgBtn.addSubview(redPoint)
        redPoint.snp.makeConstraints { make in
            make.width.height.equalTo(6)
            make.top.equalToSuperview().offset(wScale(15.5))
            make.right.equalToSuperview().inset(wScale(17.5))
        }
        view.addSubview(avatarIV)
        avatarIV.kf.setImage(with: URL(string: AppManager.shared.profile?.avatar ?? ""), placeholder: UIImage(named: "avatar.default"))
        avatarIV.isUserInteractionEnabled = true
        avatarIV.clipsToBounds = true
        avatarIV.addTapGesture(self, sel: #selector(changeAvatar))
        avatarIV.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(90))
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(wScale(30+44))
        }
        
        let phoneNum = AppManager.shared.profile?.mobile ?? "--"
        let safePhoneNum = phoneNum.desensitizationPhone()
        phoneNumLb.text = safePhoneNum
        view.addSubview(phoneNumLb)
        phoneNumLb.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.bottom).offset(wScale(18))
            make.centerX.equalToSuperview()
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(phoneNumLb.snp.bottom).offset(wScale(30))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    lazy var backgourdIV: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "me_top_bg")
        }
    }()
    
    private lazy var avatarIV: UIImageView = {
        UIImageView().then {
            $0.layer.cornerRadius = wScale(45)
            $0.contentMode = .scaleAspectFill
        }
    }()
    
    private lazy var phoneNumLb = {
        let lb = UILabel()
        lb.font = .kBoldFontScale(18)
        lb.textColor = .kText2
        lb.text = ""
        return lb
    }()
    
    private lazy var redPoint = {
        let v = UIView()
        v.backgroundColor = .red
        v.layer.cornerRadius = 3
        v.isHidden = true
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: wScale(0), left: wScale(14), bottom: wScale(14), right: wScale(14))
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return  UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.register(RadiusCollectionCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
            
            $0.register(MineAccountCell.self, forCellWithReuseIdentifier: MineItemModel.Identifier.account.rawValue)
            $0.register(MineGroupCell.self, forCellWithReuseIdentifier: MineItemModel.Identifier.group.rawValue)
            $0.register(MineNormalCell.self, forCellWithReuseIdentifier: MineItemModel.Identifier.normal.rawValue)
            $0.register(MineBannerCell.self, forCellWithReuseIdentifier: MineItemModel.Identifier.banner.rawValue)
        }
    }()
    
}

extension MeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.sections[indexPath.section][indexPath.row]
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: item.identifier.rawValue, for: indexPath)
        
        if let cell = cell as? MineItemLoadProtocol {
            cell.load(item)
        }
        cell.contentView.backgroundColor = .white
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.sections[indexPath.section][indexPath.row]
        let height = item.identifier.rowHeight
        return CGSize(width: CGRectGetWidth(collectionView.frame) - wScale(14)*2, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.sections[indexPath.section][indexPath.row]

        if let path = item.link {
            if path.hasPrefix("http") {
                JumpManager.jumpToWeb(path)
            }else if let link = URL(string: path){
                Router.route(url: link)
            }
        }
    }

}

extension MeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            uploadImage(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil) // 关闭图片选择器
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) // 用户取消了选择，关闭图片选择器
    }
}
