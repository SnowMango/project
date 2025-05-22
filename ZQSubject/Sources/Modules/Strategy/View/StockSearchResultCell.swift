
import UIKit
import Then

class StockSearchResultCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(_ model: SearchStockModel, with keyword: String?){
        if let keyword = keyword {
            self.titleLb.attributedText = model.name.highlightKeyword(keyword, color: .kTheme)
        } else {
            self.titleLb.attributedText = NSAttributedString(string: model.name)
        }
        self.codeLb.text = model.code
    }
    
    
    
    func setupUI() {
        contentView.addSubview(self.titleLb)
        contentView.addSubview(self.codeLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(wScale(15))
            make.centerY.equalToSuperview()
        }
        
        codeLb.snp.makeConstraints { make in
            make.left.equalTo(titleLb.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var titleLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText2
            $0.font = .kScale(14,weight: .medium)
        }
    }()
    
    lazy var codeLb: UILabel = {
        UILabel().then {
            $0.textColor = .kText1
            $0.font = .kScale(10, weight: .medium)
        }
    }()
    
}
