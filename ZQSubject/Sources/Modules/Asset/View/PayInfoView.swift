
import UIKit
import Then

class PayInfoView: UIView {

    var commitModel: BindAccountModel?
    weak var controller: UIViewController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            if CGRectContainsPoint(self.contentView.frame, loc){
                super.touchesBegan(touches, with: event)
            }else {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func plusBtnClick(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .overFullScreen
        controller?.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func commitClick(){
        guard let name = nameInputField.text, name.count >= 2  else {
            self.showText("请输入2位有效姓名")
            return
        }
        guard let account = accountInputField.text, account.count >= 6  else {
            self.showText("请输入6位以上有效账号")
            return
        }
        guard let order = payOrderInputField.text, order.count >= 16  else {
            self.showText("请输入16位以上订单号")
            return
        }
        guard let image = payPicIV.image else {
            self.showText("请选择支付截图")
            return
        }
        self.commitModel?.payerName = name
        self.commitModel?.paymentAccount = account
        self.commitModel?.paymentOrderNumber = order
        upload(image)
    }
    
    func upload(_ pic: UIImage) {
        guard let jpeg = pic.jpegData(compressionQuality: 0.3) else { return }
        self.showLoading()
        NetworkManager.shared.request(AuthTarget.upload(jpeg)) { (result:JSONResult) in
            self.hideHud()
            do {
                let response = try result.get()
                if let path = response.object as? String {
                    self.commitModel?.paymentScreenshotUrl = path
                    self.commitAllInfo()
                }else{
                    self.showText("图片上传失败")
                }
            } catch NetworkError.server(_,let message) {
                self.showText(message)
            } catch {
                self.showText("网络错误，上传失败")
            }
        }
    }
    
    func commitAllInfo() {
        guard let model = self.commitModel else { return }
        NetworkManager.shared.request(AuthTarget.bindFund(model)) { [weak self](result:OptionalJSONResult) in
            switch result {
            case .success(_):
                self?.removeFromSuperview()
                StrategyAlert(title: "温馨提示", content: "审核中", desc: "财务审核中，请您耐心等待", alertType: .info) {
                    Router.shared.route(.backHome)
                }.show()
            case .failure(let error):
                switch error {
                case .server(_,let message):
                    self?.showText(message)
                default:
                    self?.showText("网络错误，提交失败")
                }
            }
        }
    }
    
    // MARK: setup
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(nameTitleLb)
        contentView.addSubview(nameInputField)
        
        contentView.addSubview(accountTitleLb)
        contentView.addSubview(accountInputField)
        
        contentView.addSubview(payOrderTitleLb)
        contentView.addSubview(payOrderInputField)
        
        contentView.addSubview(payPicTitleLb)
        contentView.addSubview(payPicIV)
        contentView.addSubview(plusPicBtn)
        
        contentView.addSubview(doneBtn)
    }
    
    func setupLayout() {
        contentView.snp.makeConstraints { make in
            make.left.equalTo(wScale(55))
            make.right.equalTo(wScale(-55))
            make.centerY.equalToSuperview()
        }
        
        nameTitleLb.snp.makeConstraints { make in
            make.left.top.equalTo(wScale(20))
        }
        nameInputField.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.centerX.equalToSuperview()
            make.top.equalTo(nameTitleLb.snp.bottom).offset(wScale(10))
            make.height.equalTo(wScale(30))
        }
        
        accountTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(nameInputField.snp.bottom).offset(wScale(16))
        }
        accountInputField.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.centerX.equalToSuperview()
            make.top.equalTo(accountTitleLb.snp.bottom).offset(wScale(10))
            make.height.equalTo(wScale(30))
        }
        
        payOrderTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(accountInputField.snp.bottom).offset(wScale(16))
        }
        
        payOrderInputField.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.centerX.equalToSuperview()
            make.top.equalTo(payOrderTitleLb.snp.bottom).offset(wScale(10))
            make.height.equalTo(wScale(30))
        }
        
        payPicTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(payOrderInputField.snp.bottom).offset(wScale(16))
        }
        
        payPicIV.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(payPicTitleLb.snp.bottom).offset(wScale(10))
            make.width.height.equalTo(wScale(60))
        }
        
        plusPicBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(payPicTitleLb.snp.bottom).offset(wScale(10))
            make.width.height.equalTo(wScale(60))
        }
        
        doneBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.centerX.equalToSuperview()
            make.top.equalTo(payPicIV.snp.bottom).offset(wScale(18))
            make.bottom.lessThanOrEqualTo(wScale(-10))
            make.height.equalTo(wScale(34))
        }
    }
    
    // MARK: lazy
    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    
    lazy var nameTitleLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = .kText3
            $0.text = "姓名："
        }
    }()
    
    lazy var nameInputField: UITextField = {
        UITextField().then {
            $0.backgroundColor = .kBackGround
            $0.borderStyle = .roundedRect
            $0.textColor = .kText2
            $0.font = .kScale(14)
            $0.delegate = self
        }
    }()
    
    lazy var accountTitleLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = .kText3
            $0.text = "账号："
        }
    }()
    
    lazy var accountInputField: UITextField = {
        UITextField().then {
            $0.backgroundColor = .kBackGround
            $0.borderStyle = .roundedRect
            $0.textColor = .kText2
            $0.font = .kScale(14)
            $0.delegate = self
        }
    }()
    
    lazy var payOrderTitleLb:UILabel = {
        return UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = .kText3
            $0.text = "支付订单号："
        }
    }()
    
    lazy var payOrderInputField: UITextField = {
        UITextField().then {
            $0.backgroundColor = .kBackGround
            $0.borderStyle = .roundedRect
            $0.textColor = .kText2
            $0.font = .kScale(14)
            $0.delegate = self
        }
    }()
    
    lazy var payPicTitleLb: UILabel = {
        return UILabel().then {
            $0.font = .kScale(14, weight: .medium)
            $0.textColor = .kText3
            $0.text = "支付截图："
        }
    }()
    
    lazy var payPicIV: UIImageView = {
        return UIImageView().then {
            $0.backgroundColor = .kBackGround
            $0.layer.cornerRadius = wScale(4)
            $0.layer.borderColor = UIColor("#C9C9C9")?.cgColor
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
        }
    }()
    
    lazy var plusPicBtn: UIButton = {
        return UIButton().then {
            $0.setImage(UIImage(named: "plus.grey"), for: .normal)
            $0.addTarget(self, action: #selector(plusBtnClick), for: .touchUpInside)
        }
    }()
    
    
    lazy var doneBtn: UIButton = {
        return UIButton().then {
            $0.titleLabel?.font =  .kScale(14, weight: .medium)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = wScale(8)
            $0.backgroundColor = .kTheme
            $0.setTitle("确认", for: .normal)
            $0.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        }
    }()

    
}

extension PayInfoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            payPicIV.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil) // 关闭图片选择器
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) // 用户取消了选择，关闭图片选择器
    }
}

extension PayInfoView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
