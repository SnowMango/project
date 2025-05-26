import UIKit
import Kingfisher
import Then
import AVFoundation
import RxCocoa
import RxSwift

class MineVC: BaseViewController {
 

    var hasUnread: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenNavigationBarWhenShow = true
        setupUI()
        setupLayout()
    
        reloadData()
        
        NotificationCenter.default.rx.notification(UserProfileDidUpdateName).subscribe(onNext: {[weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
        
        settingBtn.rx.tap.subscribe(onNext: { _ in
            Router.shared.route("/app/setting")
        }).disposed(by: disposeBag)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppManager.shared.refreshUserInfo()

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
        
        //账号
        if let resource = AppManager.shared.resource(with:"my_account"){
            mineAccount.item = resource.data.first
        }
        mineAccount.isHidden = mineAccount.item == nil
        
        //我的底部banner
        if let resource = AppManager.shared.resource(with:"my_bottom_banner") {
            mineGroup.item = resource.data.first
        }
        mineGroup.isHidden = mineGroup.item == nil
        
        //我的底部活动图
        if let resource = AppManager.shared.resource(with:"my_bottom_activity_diagram"){
            banners.items = resource.data
        }
        banners.isHidden = banners.items.count == 0
        
        if let items = AppManager.shared.kingkong(with: 1) {
            self.mineFeatures.categories = items
            self.mineFeatures.isHidden = false
    
        } else {
            self.mineFeatures.categories = []
            self.mineFeatures.isHidden = true
        }
    }
    
    @objc func showCoupos() {
        Router.shared.route("coupons")
    }
    @objc func showIntegral() {
        Router.shared.route("")
    }
    //MARK: -
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backgourdIV)
        contentView.addSubview(userView)
        contentView.addSubview(settingBtn)
    
        userView.addSubview(avatarIV)
        userView.addSubview(phoneNumLb)
        
        contentView.addSubview(infoView)
        infoView.addSubview(integralView)
        integralView.addSubview(integralLb)
        integralView.addSubview(integralTitleLb)
        infoView.addSubview(couponsView)
        couponsView.addSubview(couponsLb)
        couponsView.addSubview(couponsTitleLb)
        
        contentView.addSubview(sectionsStack)
        sectionsStack.addArrangedSubview(mineAccount)
        sectionsStack.addArrangedSubview(mineGroup)
        sectionsStack.addArrangedSubview(banners)
        sectionsStack.addArrangedSubview(featuresView)
        featuresView.addSubview(featureTitleLb)
        featuresView.addSubview(mineFeatures)
        
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
            make.height.equalTo(wScale(780))
        }
        
        settingBtn.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(2)
            make.right.equalTo(-8)
        }
        
        userView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(wScale(40))
            make.left.right.equalTo(0)
        }
        
        avatarIV.snp.makeConstraints { make in
            make.width.height.equalTo(wScale(50))
            make.left.equalTo(wScale(30))
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(0)
        }
        
        phoneNumLb.snp.makeConstraints { make in
            make.centerY.equalTo(avatarIV)
            make.left.equalTo(avatarIV.snp.right).offset(10)
        }
        
        infoView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.centerX.equalToSuperview()
            make.top.equalTo(userView.snp.bottom).offset(wScale(22))
            make.bottom.lessThanOrEqualTo(0)
        }
        
        integralView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.top.greaterThanOrEqualTo(0)
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualTo(0)
        }
        
        integralLb.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
            make.height.equalTo(wScale(28))
        }
        
        integralTitleLb.snp.makeConstraints { make in
            make.top.equalTo(integralLb.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        couponsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.top.greaterThanOrEqualTo(0)
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualTo(0)
        }
        
        couponsLb.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
            make.height.equalTo(wScale(28))
        }
        
        couponsTitleLb.snp.makeConstraints { make in
            make.top.equalTo(couponsLb.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(0)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        sectionsStack.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(infoView.snp.bottom).offset(wScale(18))
            make.bottom.lessThanOrEqualTo(wScale(-14))
        }
        
        mineAccount.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.height.equalTo(wScale(180))
        }
        
        mineGroup.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.height.equalTo(wScale(76))
        }
        
        banners.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
        }
        
        featuresView.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
        }

        featureTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(16))
            make.top.equalTo(0)
        }
    
        mineFeatures.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(featureTitleLb.snp.bottom).offset(wScale(14))
            make.bottom.lessThanOrEqualTo(0)
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
        UIImageView().then { $0.image = UIImage(named: "mine.top.bg") }
    }()
    
    lazy var settingBtn: UIButton = {
        UIButton().then {
            $0.setImage(UIImage(named: "mine.setting"), for: .normal)
        }
    }()
    
    lazy var userView: UIView = {
        UIView().then {
            $0.backgroundColor = .clear
        }
    }()
    
    lazy var avatarIV: UIImageView = {
        UIImageView().then {
            $0.layer.cornerRadius = wScale(50)/2.0
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
    
    lazy var infoView: UIView = {
        UIView().then {
            $0.backgroundColor = .clear
        }
    }()
    
    lazy var integralView: UIView = {
        UIView().then {
            $0.backgroundColor = .clear
            $0.addTapGesture(self, sel: #selector(showIntegral))
        }
    }()
    
    lazy var integralLb = {
        UILabel().then {
            $0.font = .kScale(24, weight: .bold)
            $0.textColor = .kText2
            $0.text = "0"
        }
    }()
    lazy var integralTitleLb = {
        UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = .kText2
            $0.text = "积分"
        }
    }()
    
    lazy var couponsView: UIView = {
        UIView().then {
            $0.backgroundColor = .clear
            $0.addTapGesture(self, sel: #selector(showCoupos))
        }
    }()
    
    lazy var couponsLb = {
        UILabel().then {
            $0.font = .kScale(24, weight: .bold)
            $0.textColor = .kText2
            $0.text = "0"
        }
    }()
    lazy var couponsTitleLb = {
        UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = .kText2
            $0.text = "优惠券"
        }
    }()
    
    lazy var sectionsStack: UIStackView = {
        return UIStackView().then {
            $0.spacing = wScale(18)
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .vertical
        }
    }()
    
    
    lazy var mineAccount: MineAccountView = {
        MineAccountView().then {
            $0.clipsToBounds = true
        }
    }()
    
    lazy var mineGroup: MineGroupView = {
        MineGroupView().then {
            $0.clipsToBounds = true
        }
    }()
    
    lazy var banners: MineBannerView = {
        MineBannerView()
    }()
    
    lazy var featuresView: UIView = {
        UIView().then {
            $0.backgroundColor = .clear
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }()
    
    lazy var featureTitleLb = {
        UILabel().then {
            $0.font = .kScale(18, weight: .bold)
            $0.textColor = .kText2
            $0.text = "更多功能"
        }
    }()

    lazy var mineFeatures: MineFeaturesView = {
        return MineFeaturesView().then {
            $0.backgroundColor = .white
        }
    }()
    
    
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
