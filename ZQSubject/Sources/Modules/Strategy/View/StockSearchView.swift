
import UIKit
import Then

class StockSearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeUI() {
        addSubview(logo)
        addSubview(searchTextFild)
        addSubview(searchBtn)
        backgroundColor = UIColor(0xF5F5F5)
        layer.cornerRadius = 17
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let img = logo.image {
            logo.frame = CGRect(origin: CGPoint(x: 18, y: bounds.midY - img.size.height/2.0), size: img.size)
        }else {
            logo.frame = CGRect(x: 18, y: bounds.midY, width: 0, height: 0)
        }
        let searchSize = CGSize(width: 50, height: 26)
        searchBtn.frame = CGRect(origin: CGPoint(x: bounds.maxX - searchSize.width - 4,
                                                 y: bounds.midY - searchSize.height/2.0),
                                 size: searchSize)
        
        searchTextFild.frame = CGRect(origin: CGPoint(x: logo.frame.maxX + 8, y: 4),
                                      size: CGSize(width: searchBtn.frame.minX - logo.frame.maxX - 16,
                                                   height: bounds.height - 8))
    }

    lazy var logo: UIImageView = {
        UIImageView().then {
            $0.image = UIImage(named: "search.logo.grey")
        }
    }()
    
    lazy var searchTextFild: UITextField = {
        return UITextField().then {
            $0.textColor = .kText2
        }
    }()
    
    lazy var searchBtn: UIButton = {
        UIButton().then {
            $0.setTitle("搜索", for: .normal)
            $0.backgroundColor = .kTheme
            $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
            $0.layer.cornerRadius = 13
        }
    }()
}
