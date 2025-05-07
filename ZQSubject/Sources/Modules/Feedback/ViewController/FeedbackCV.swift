
import UIKit
import Then
import UITextView_Placeholder
import AVFoundation

class FeedbackCV: BaseViewController {
   
    var links: [Int:String] = [:]
    
    private var selectTag: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleName = "反馈"
        setupUI()
        setupLayout()
    }

    //MARK: action
    @objc func commitClick() {
        guard let message = feedbackInptTV.text, message.count > 0 else {
            self.view.showText("请输入反馈意见")
            return
        }
        let phone = numberTextFiled.text ?? ""
        
        if phone.count > 0 && phone.count != 11 {
            self.view.showText("请输入11位手机号")
        }
        let req: FeedbackReq = FeedbackReq()
        if phone.count == 11 {
            req.contactMobile = phone
        }
        req.feedbackMessage = message
        
        var urls: [String] = []
        for item in picturesStack.arrangedSubviews {
            if let link = self.links[item.tag] {
                urls.append(link)
            }
        }
        self.view.showLoading()
        req.feedbackScreenshotUrls = urls
        NetworkManager.shared.request(AuthTarget.feedback(req)) { (result:OptionalJSONResult) in
            self.view.hideHud()
            do {
                let _ = try result.get()
                Router.shared.route(.backHome)
                self.view.window?.showText("提交成功")
            } catch NetworkError.server(_,let message) {
                self.view.showText(message)
            } catch {
                self.view.showText("网络错误，提交失败")
            }
        }
    }
    
    @objc private func addPictureTap(_ tap: UITapGestureRecognizer) {
        self.selectTag = tap.view?.tag
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
                    if let tag = self.selectTag {
                        self.links[tag] = path
                        for item in self.picturesStack.arrangedSubviews {
                            if item.tag == tag, let item = item as? UIImageView {
                                item.image = pic
                            }
                        }
                        self.reloadPicData()
                    }
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

    func reloadPicData() {
        var nextTag:Int = 0
        if self.links.count < self.picturesStack.arrangedSubviews.count {
            nextTag = self.picturesStack.arrangedSubviews[self.links.count].tag
        }
        for item in self.picturesStack.arrangedSubviews {
            if (self.links[item.tag] != nil) || nextTag == item.tag{
                item.isHidden = false
            }else{
                item.isHidden = true
            }
        }
        self.pictureCountLb.text = "\(self.links.count)/4"
    }
    //MARK: setup
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(messageLb)
        contentView.addSubview(feedbackTitleLb)
        contentView.addSubview(inputBg)
        inputBg.addSubview(feedbackInptTV)
        contentView.addSubview(wordCountLb)
        
        contentView.addSubview(pictureTitleLb)
        contentView.addSubview(picturesStack)
        contentView.addSubview(pictureCountLb)
        
        contentView.addSubview(numberTitleLb)
        contentView.addSubview(numberTextFiled)
        
        contentView.addSubview(commitBtn)
        let tags: [Int] = [100,101,102,103]
        for tag in tags {
            let item = makeTapImageView(tag)
            picturesStack.addArrangedSubview(item)
            item.isHidden = tag != 100
            item.snp.makeConstraints { make in
                make.width.height.equalTo(wScale(80))
            }
        }
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        messageLb.snp.makeConstraints { make in
            make.left.top.equalTo(wScale(20))
            make.right.equalTo(wScale(-20))
        }
        
        feedbackTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(messageLb.snp.bottom).offset(wScale(18))
        }
        
        inputBg.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(feedbackTitleLb.snp.bottom).offset(wScale(11))
            make.height.equalTo(wScale(200))
        }
        feedbackInptTV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
        
        wordCountLb.snp.makeConstraints { make in
            make.right.equalTo(inputBg).offset(wScale(-16))
            make.bottom.equalTo(inputBg).offset(wScale(-11))
        }
        
        pictureTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(inputBg.snp.bottom).offset(wScale(24))
        }
        
        picturesStack.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.top.equalTo(pictureTitleLb.snp.bottom).offset(wScale(11))
            make.height.equalTo(wScale(80))
        }
        
        pictureCountLb.snp.makeConstraints { make in
            make.right.equalTo(wScale(-30))
            make.bottom.equalTo(picturesStack)
        }
        
        numberTitleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(20))
            make.top.equalTo(picturesStack.snp.bottom).offset(wScale(24))
        }
        
        numberTextFiled.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(numberTitleLb.snp.bottom).offset(wScale(11))
            make.height.equalTo(wScale(44))
        }
        
        commitBtn.snp.makeConstraints { make in
            make.left.equalTo(wScale(14))
            make.right.equalTo(wScale(-14))
            make.top.equalTo(numberTextFiled.snp.bottom).offset(wScale(40))
            make.height.equalTo(wScale(48))
            make.bottom.lessThanOrEqualTo(wScale(-40))
        }

    }
    
    func makeTapImageView(_ tag: Int) -> UIImageView {
        UIImageView().then {
            $0.image = UIImage(named: "feedback.add.pic")
            $0.layer.cornerRadius = wScale(10)
            $0.clipsToBounds = true
            $0.tag = tag
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPictureTap)))
        }
    }
    //MARK: lazy
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .kBackGround
        }
    }()
    
    lazy var messageLb: UILabel = {
        return UILabel().then {
            $0.text = "在使用过程中对软件功能、产品服务有任何建议，欢迎向我们反馈。"
            $0.textColor = .kText1
            $0.font = .kScale(13)
            $0.numberOfLines = 0
        }
    }()
    
    lazy var feedbackTitleLb: UILabel = {
        return UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(15,weight: .medium)
            $0.text = "填写反馈"
        }
    }()
    
    lazy var inputBg: UIView = {
        return UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
        }
    }()
    lazy var feedbackInptTV: UITextView = {
        return UITextView().then {

            $0.placeholderColor = UIColor("#AAAAAA")
            $0.placeholder = "团队会充分聆听您的声音(请输入10字以上的描述)"
            $0.textColor = .kText2
            $0.font = .kScale(14)
            $0.delegate = self
        }
    }()
    
    lazy var wordCountLb: UILabel = {
        return UILabel().then {
            $0.textColor = UIColor("#AAAAAA")
            $0.font = .kScale(14)
            $0.text = "0/500"
        }
    }()
    
    lazy var pictureTitleLb: UILabel = {
        return UILabel().then {
            $0.text = "相关截图或照片（可选）"
            $0.textColor = .kText2
            $0.font = .kScale(15, weight: .medium)
        }
    }()
    lazy var picturesStack: UIStackView = {
        return UIStackView().then {
            $0.spacing = 12
            $0.distribution = .equalSpacing
            $0.alignment = .center
            $0.axis = .horizontal
        }
    }()
    
    lazy var pictureCountLb: UILabel = {
        return UILabel().then {
            $0.textColor = UIColor("#AAAAAA")
            $0.font = .kScale(14)
            $0.text = "0/4"
        }
    }()

    
    lazy var numberTitleLb: UILabel = {
        return UILabel().then {
            $0.text = "联系电话"
            $0.textColor = .kText2
            $0.font = .kScale(15, weight: .medium)
        }
    }()
    
    lazy var numberTextFiled: UITextField = {
        UITextField().then {
            $0.placeholder = "如有需要，我们将与您取得联系"
            $0.textColor = .kText2
            $0.font = .kScale(14, weight: .medium)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = wScale(10)
            $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 40))
            $0.leftViewMode = .always
            $0.delegate = self
            $0.keyboardType = .numberPad
            $0.returnKeyType = .done
        }
    }()
    
    
    lazy var commitBtn:UIButton = {
        UIButton(type: .custom).then {
            $0.setTitle("提交", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .kScale(17, weight: .medium)
            $0.layer.cornerRadius = wScale(48)/2.0
            $0.backgroundColor = .kTheme
            $0.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        }
    }()

}

extension FeedbackCV: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if string == "." { return false }
        if let _ = Int(updatedText){
            return true
        }
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension FeedbackCV: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if updatedText.count > 500 {
            return false
        }
        self.wordCountLb.text = "\(updatedText.count)/500"
        return true
    }
    
}

extension FeedbackCV: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
