
import UIKit
import Kingfisher

class BrowseImageView: UIView {
   
    // MARK: - lazy load
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: .zero).then {
            $0.showsVerticalScrollIndicator = false
        }
    }()
    
    lazy var contentView: UIView = {
        UIView()
    }()

    lazy var imageView: UIImageView = {
        UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .clear
        }
    }()
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            super.touchesBegan(touches, with: event)
//            return
//        }
//        let loc = touch.location(in: self)
//        if !CGRectContainsPoint(self.imageView.frame, loc){
//           
//            return
//        }
//        super.touchesBegan(touches, with: event)
        BrowseImageView.dismiss(animate: true, form: self.superview)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black.withAlphaComponent(0.6)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(with url:String) {
        imageView.kf.setImage(with: URL(string: url)) { result in
            do {
                let respone = try result.get()
                let size = respone.image.size
                print("\(size)-\(respone.image.scale)")
                
            } catch {
            }
        }
    }
    
    func setupUI() {
//        addSubview(scrollView)
//        scrollView.addSubview(contentView)
        addSubview(contentView)
        contentView.addSubview(imageView)
    }
    
    func setupLayout() {
//        scrollView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(safeAreaLayoutGuide.snp.top)
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
//        }
        contentView.snp.makeConstraints { make in
//            make.left.right.top.bottom.equalTo(0)
//            make.centerX.equalToSuperview()
            make.left.equalTo(0)
            make.top.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(44)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
    }

    deinit {
        print("\(type(of: self))_deinit")
    }
}

//MARK: - UI
extension BrowseImageView {
    
    static func show(_ url:String, animate: Bool = true, to view: UIView? = nil) {
        guard let window = UIApplication.shared.keyWindow else { return  }
        var toview:UIView = window
        if let view = view {
            toview = view
        }
        let toast: BrowseImageView = BrowseImageView(frame: toview.bounds)
        toview.addSubview(toast)
        toast.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        toast.load(with: url)
        if animate {
            toast.alpha = 0
            UIView.animate(withDuration: 0.25) {
                toast.alpha = 1
            }
        }else {
            toast.alpha = 1
        }
    }
    
    static func dismiss(animate: Bool = true, form view: UIView? = nil) {
        guard let window = UIApplication.shared.keyWindow else { return  }
        var formview:UIView = window
        if let view = view {
            formview = view
        }
        var toast: BrowseImageView?
        for view in formview.subviews.reversed() {
            if let view = view as? BrowseImageView{
                toast = view
                break
            }
        }
        guard let toast = toast else { return  }
        if animate {
            UIView.animate(withDuration: 0.25) {
                toast.alpha = 0
            } completion: { _ in
                toast.removeFromSuperview()
            }
        }else {
            toast.removeFromSuperview()
        }
    }

}


