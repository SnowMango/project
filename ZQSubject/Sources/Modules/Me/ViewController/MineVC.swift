import UIKit
import Kingfisher
import Then
import AVFoundation

class MineVC: BaseViewController {
 
    var normals: [MineItemModel] = []
    var hasUnread: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenBackBtn = true
        hiddenNavigationBarWhenShow = true

        normals = [.Setting,
                   .Feedback,
                   .Support,
                   .RealAuth,
                   .Assessment,
                   .Servers,
                   .Orders]
        setupUI()
        setupLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(updataUserProfile), name: UserProfileDidUpdateName, object: nil)
        reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppManager.shared.refreshUserInfo()
        checkUnread()
    }
    
    private func checkUnread() {
        NetworkManager.shared.request(AuthTarget.unreadMsg) { (result: JSONResult) in
            do {
                let response = try result.get()
                let unreadCount = response["unreadCount"].intValue
                let _ = response["readCount"].intValue
                self.hasUnread = unreadCount > 0
                self.updateUnread()
            } catch {
                
            }
        }
    }
    
    @objc private func updataUserProfile() {
        reloadData()
    }
    @objc private func gotoMessageCenter() {
        Router.shared.route("/message")
    }
    
    @objc private func tapNormalItem(_ tap: UITapGestureRecognizer) {
        guard let itemView = tap.view as? MineNormalView else {
            return
        }
        let item = self.normals[itemView.index]
        if let path = item.link {
            if path.hasPrefix("http") {
                JumpManager.jumpToWeb(path)
            }else if let link = URL(string: path){
                Router.route(url: link)
            }
        }
    }
    
    func reloadData() {
        guard let profile = AppManager.shared.profile else { return }
        if let avatarPath = profile.avatar {
            avatarIV.kf.setImage(with: URL(string: avatarPath), placeholder: UIImage(named: "avatar.default"))
        }else {
            avatarIV.image = UIImage(named:"avatar.default")
        }

        var phoneNum = "--"
        if let phone = profile.mobile {
            phoneNum = phone.desensitizationPhone()
        }
        phoneNumLb.text = phoneNum
        updateUnread()
    }
    
    func updateUnread() {
        self.redPoint.isHidden = !self.hasUnread
    }
    
    //MARK: -
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgourdIV)
        contentView.addSubview(msgBtn)
        contentView.addSubview(redPoint)
        contentView.addSubview(avatarIV)
        contentView.addSubview(phoneNumLb)
        contentView.addSubview(sectionsStack)
        sectionsStack.addArrangedSubview(mineAccount)
        sectionsStack.addArrangedSubview(mineGroup)
        sectionsStack.addArrangedSubview(normalsStack)

        for (index, item) in normals.enumerated() {
            let v = makeNormal(item)
            v.index = index
            v.count = normals.count
            normalsStack.addArrangedSubview(v)
            v.snp.makeConstraints { make in
                make.left.equalTo(0)
                make.height.equalTo(item.identifier.rowHeight)
            }
        }
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        backgourdIV.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(wScale(381))
        }
        
        msgBtn.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(50))
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview().inset(wScale(5))
        }
        
        redPoint.snp.makeConstraints { make in
            make.right.equalTo(msgBtn).offset(-17)
            make.top.equalTo(msgBtn).offset(15)
            make.width.height.equalTo(6)
        }
        
        avatarIV.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(90))
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(wScale(74))
        }
        
        phoneNumLb.snp.makeConstraints { make in
            make.top.equalTo(avatarIV.snp.bottom).offset(wScale(18))
            make.centerX.equalToSuperview()
        }
        
        sectionsStack.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(phoneNumLb.snp.bottom).offset(wScale(30))
            make.bottom.lessThanOrEqualTo(wScale(-14))
        }
        
        mineAccount.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(MineItemModel.Account.identifier.rowHeight)
        }
        mineGroup.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.height.equalTo(MineItemModel.Group.identifier.rowHeight)
        }
        
        normalsStack.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
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
    
    lazy var backgourdIV: UIImageView = {
        UIImageView().then { $0.image = UIImage(named: "me_top_bg") }
    }()
    
    lazy var msgBtn: UIButton = {
        UIButton().then {
            $0.setImage(UIImage(named: "message"), for: .normal)
            $0.addTarget(self, action: #selector(gotoMessageCenter), for: .touchUpInside)
        }
    }()
    
    lazy var avatarIV: UIImageView = {
        UIImageView().then {
            $0.layer.cornerRadius = wScale(45)
            $0.isUserInteractionEnabled = true
            $0.clipsToBounds = true
            $0.addTapGesture(self, sel: #selector(changeAvatar))
        }
    }()
    
    lazy var phoneNumLb = {
        UILabel().then {
            $0.font = .kScale(18, weight: .bold)
            $0.textColor = .kText2
        }
    }()
    
    private lazy var redPoint: UIView = {
        UIView().then {
            $0.backgroundColor = .red
            $0.layer.cornerRadius = 3
        }
    }()
    lazy var sectionsStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 12
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    lazy var normalsStack: UIStackView = {
        return UIStackView(frame: .zero).then {
            $0.spacing = 0
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    lazy var mineAccount: MineAccountView = {
        MineAccountView().then {
            $0.index = 0
            $0.count = 1
            $0.backgroundColor = .white
        }
    }()
    
    lazy var mineGroup: MineGroupView = {
        MineGroupView().then {
            $0.index = 0
            $0.count = 1
            $0.backgroundColor = .white
        }
    }()
    
    func makeNormal(_ item: MineItemModel) -> MineNormalView {
        MineNormalView().then {
            $0.load(item)
            $0.backgroundColor = .white
            $0.addTapGesture(self, sel: #selector(tapNormalItem))
        }
    }
    
}
//MARK: - 上传图片
extension MineVC {
    
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
            do {
                let _ = try result.get()
                self.view.showText("头像更新成功", isUserInteractionEnabled: true)
                AppManager.shared.profile?.avatar = url
                self.reloadData()
            } catch NetworkError.server(_,let message){
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误，提交失败")
            }
        }
    }
}

extension MineVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
