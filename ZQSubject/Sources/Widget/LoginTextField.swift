
import UIKit

enum TextFieldType {
    case normal         // 普通
    case verifyCode     // 验证码
}

class LoginTextField: UIView {
    
    /// 键盘类型
    var keyboardtype: UIKeyboardType? {
        didSet {
            textField.keyboardType = keyboardtype!
        }
    }
    
    ///倒计时字样
    private var countDownText: String = ""
    
    /// 限制字数
    var limitCount = 0
    
    /// 获取验证码闭包
    var getCode: (() -> ())?
    
    /// 输入变化回调
    var editingChanged: ((_ text: String)->())?
    
    private var cutDownSeconds: Int = 60
    private var timer: Timer?
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.keyboardType = UIKeyboardType.numberPad
        field.font = UIFont.systemFont(ofSize: wScale(18))
        field.textColor = .kText2
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.addSubview(field)
        return field
    }()
    
    lazy private var cutDownBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = .kFontScale(14)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(getCodeAction), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: wScale(14))
        label.textColor = UIColor("AAAAAA")
        label.text = "\(cutDownSeconds)s"
        label.textAlignment = .center
        label.isHidden = true
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-wScale(10))
            make.centerY.equalToSuperview()
            make.width.equalTo(wScale(105))
            make.height.equalTo(wScale(30))
        }
        return label
    }()
    
    /// 初始化
    /// - Parameters:
    ///   - imageName: 左侧图片名称
    ///   - placeHolder: 占位字符
    init(leftImage: String, placeHolder: String? = nil, cornerRadius: CGFloat, type: TextFieldType = .normal) {
        super.init(frame: CGRect.zero)
        setupUI(leftImage: leftImage, placeHolder: placeHolder, cornerRadius: cornerRadius, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopTimer()
    }
    
}

extension LoginTextField {
    private func setupUI(leftImage: String, placeHolder: String? = nil, cornerRadius: CGFloat, type: TextFieldType) {
        
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = UIColor("F8F8F8")
        
        textField.attributedPlaceholder = placeHolder?.attributedString(font: .kFontScale(14), textColor: UIColor("AAAAAA"), lineSpaceing: nil, wordSpaceing: nil)
        timeLabel.textAlignment = .center
        countDownText = "后重新获取"
        
        let leftImgv = UIImageView(image: UIImage(named: leftImage))
        addSubview(leftImgv)
        leftImgv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(wScale(21.5))
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(wScale(46))
        }
        
        if type == .normal {
            textField.snp.makeConstraints { (make) in
                make.right.equalToSuperview().inset(wScale(21.5))
            }
            return
        }
        
        if type == .verifyCode {
            cutDownBtn.setTitleColor(.kText1, for: .normal)
            cutDownBtn.titleLabel?.font = .kFontScale(14)
            cutDownBtn.snp.makeConstraints { (make) in
                make.left.equalTo(textField.snp.right).offset(wScale(5))
                make.width.equalTo(wScale(105))
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(wScale(5))
            }
            return
        }
    }
    
    //当textField有字符串长度的限制时，频繁的copy、paste三指手势的撤销键会有bug，所以要禁用
    @available(iOS 13.0, *)
    override var editingInteractionConfiguration: UIEditingInteractionConfiguration {
        return .none
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        //系统中文输入法会有高亮的选择文字,不做任何限制
        if let selectedRange = sender.markedTextRange, sender.position(from: selectedRange.start, offset: 0) != nil {return}
        //最大长度为0也不限制长度
        if limitCount == 0 {return}
        
        if let count = sender.text?.count, count > limitCount, let newStr = sender.text?.prefix(limitCount) {
            //截取
            sender.text =  String(newStr)
        }
        if let pp_callback = editingChanged {
            pp_callback(sender.text ?? "")
        }
    }
    
    @objc private func getCodeAction() {
        getCode?()
    }
    
    func timeCountdown() {
        addTimer()
    }
    
    private func func_resetUI() {
        cutDownBtn.setTitle("重新获取", for: .normal)
        timeLabel.isHidden = true
        cutDownBtn.isHidden = false
        cutDownSeconds = 60
    }
    
    private func addTimer() {
        cutDownBtn.isHidden = true
        timeLabel.isHidden = false
        handleTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] _ in
            self?.handleTimer()
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 倒计时修改文字
    @objc private func handleTimer() {
        if cutDownSeconds > 0 {
            timeLabel.text = "\(cutDownSeconds)s\(countDownText)"
        }else{
            stopTimer()
            func_resetUI()
        }
        cutDownSeconds -= 1
    }
    
    ///修改倒计时颜色
    func changeCutDownColor(state: Int) {
        if state == 0 {
            cutDownBtn.setTitleColor(.kText1, for: .normal)
            cutDownBtn.isEnabled = false
        } else {
            cutDownBtn.setTitleColor(.kTheme, for: .normal)
            cutDownBtn.isEnabled = true
        }
    }
}
