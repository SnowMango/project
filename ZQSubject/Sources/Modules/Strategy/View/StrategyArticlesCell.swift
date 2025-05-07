

import UIKit

///文章列表cell
class StrategyArticlesCell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    ///标题
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .kFontScale(14)
        l.textColor = .kText2
        l.numberOfLines = 3
        return l
    }()
    
    ///摘要
    lazy var summaryLabel: UILabel = {
        let l = UILabel()
//        l.font = kFontScale(12)
//        l.textColor = kColor_51x3
        l.numberOfLines = 3
        return l
    }()
    
    
    ///作者、时间
    lazy var dateLabel: UILabel = {
        let l = UILabel()
        l.font = .kFontScale(10)
        l.textColor = .kText1
        return l
    }()
    
    ///图片
    lazy var pImageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.layer.cornerRadius = wScale(10)
        imgv.layer.masksToBounds = true
        return imgv
    }()
    
    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .kSeparateLine
        line.layer.cornerRadius = 0.25
        return line
    }()
    
    var articleModel: StrategyArticleModel? {
        didSet {
            titleLabel.text = articleModel?.title
//            summaryLabel.text = articleModel?.summary
            var group: [String] = []
            if let source = articleModel?.source {
                group.append(source)
            }
            
            if let timeStr = articleModel?.createTime {
                group.append(timeStr.replacingOccurrences(of: "T", with: " ").components(separatedBy: " ").first!)
            }
            if let read = articleModel?.readingVolume {
                group.append("\(read)阅读")
            }
            dateLabel.text = group.joined(separator: " ")
            pImageView.kf.setImage(with: articleModel?.titleUrl?.validURL(), placeholder: UIImage(named: "as_as_image_placeholder_info"))
        }
    }
    
    var rowPosition: TableViewCellPosition? = .middle {
        didSet{
            line.isHidden = rowPosition == .bottom || rowPosition == .onlyOne
            setNeedsDisplay()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerCorner(rowPos: rowPosition, container: bgView, radius: wScale(8))
    }
    
    func setupUI() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(wScale(14))
        }
        
        bgView.addSubview(pImageView)
        pImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(wScale(12))
            make.right.equalToSuperview().inset(wScale(10))
            make.size.equalTo(CGSize(width: wScale(109), height: wScale(84)))
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(wScale(10))
            make.top.equalToSuperview().offset(wScale(12))
            make.right.equalTo(pImageView.snp.left).offset(-wScale(14))
        }
                
        bgView.addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(wScale(10))
            make.left.right.equalTo(titleLabel)
        }
        
        bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(wScale(10))
            make.bottom.equalToSuperview().inset(wScale(10))
        }
        
        bgView.addSubview(line)
        line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(wScale(10))
        }
    }
}
