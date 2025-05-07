

import UIKit

class SettingCell: UITableViewCell {
    
    lazy var titleLb = {
        let lb = UILabel()
        lb.textColor = .kText2
        lb.font = .kFontScale(14)
        return lb
    }()
    
    lazy var line = {
        let v = UIView()
        v.backgroundColor = .kSeparateLine
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func initUI() {
        selectionStyle = .none
        
        contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(wScale(20.5))
            make.centerY.equalToSuperview()
        }
        
        let imgv = UIImageView(image: UIImage(named: "go_ahead"))
        contentView.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(wScale(20.5))
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(wScale(20.5))
            make.bottom.equalToSuperview()
        }
    }
}
