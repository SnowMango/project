
import UIKit
import Then

class ChatInput: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeUI() {
        backgroundColor = .white
        addSubview(textField)
        addSubview(doneBtn)
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(wScale(25))
            make.height.equalTo(wScale(40))
            make.centerY.equalToSuperview()
        }

        doneBtn.snp.makeConstraints { make in
            make.right.equalTo(wScale(-6))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(wScale(36))
            make.left.equalTo(textField.snp.right).offset(5)
        }
    }
    
    lazy var textField: UITextField = {
        return UITextField().then {
            $0.textColor = .kText2
            $0.placeholder = "请输入你的问题"
        }
    }()
    
    lazy var doneBtn: UIButton = {
        UIButton().then {
            $0.setBackgroundImage(UIImage(named: "chat.send"), for: .normal)
        }
    }()
}
