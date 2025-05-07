
import UIKit
import Then

class MessageListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func reload(with model: MessageModel ){
        self.titleLb.text = model.messageTitle
        self.messageLb.text = model.messageContent
    }
    
    func setupUI() {
        contentView.addSubview(self.typeIconIV)
        contentView.addSubview(self.titleLb)
        contentView.addSubview(self.messageLb)
       
        typeIconIV.snp.makeConstraints { make in
            make.left.equalTo(wScale(27))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(wScale(36))
        }
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(typeIconIV.snp.right).offset(wScale(14))
            make.top.equalTo(typeIconIV)
            make.right.lessThanOrEqualTo(wScale(-24))
        }
        messageLb.snp.makeConstraints { make in
            make.left.equalTo(typeIconIV.snp.right).offset(wScale(14))
            make.top.equalTo(titleLb.snp.bottom).offset(wScale(11))
            make.right.lessThanOrEqualTo(wScale(-24))
            make.bottom.lessThanOrEqualTo(-5)
        }
    
    }
    
    lazy var typeIconIV: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "message.type.1")
        }
    }()
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(15,weight: .regular)
        }
    }()
    
    lazy var messageLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(12, weight: .regular)
            $0.numberOfLines = 0
        }
    }()
    
   
}
