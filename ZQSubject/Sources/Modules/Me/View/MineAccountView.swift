
import UIKit
import Then
import RxCocoa
import RxSwift
import Kingfisher

class MineAccountView: RadiusView {
    var item: AppResource.ResourceData? {
        didSet {
            reloadData()
        }
    }
    var disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.imageView.isHidden = item == nil
        guard let item = self.item, let url = item.resourceUrl else {
           return
        }
        self.imageView.kf.setImage(with: url.validURL())
    }
    
    func tapImg() {
        guard let item = self.item, let path = item.linkAddress else { return}
        Router.shared.route(path)
    }
    
    func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        let tapGesture = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tapGesture)
               
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            self?.tapImg()
        })
        .disposed(by: disposeBag)
    }
    
    lazy var imageView: UIImageView = {
        UIImageView().then {
            $0.isUserInteractionEnabled = true
        }
    }()
}
