
import UIKit
import Then
import SnapKit

class BaseScrollController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _makeUI()
    }
    
    func add(content view: UIView) {
        contentView.addSubview(view)
    }
    
    private func _makeUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(0).priority(.low)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    lazy var contentView: UIView = {
        return UIView().then {
            $0.backgroundColor = .clear
        }
    }()
}
