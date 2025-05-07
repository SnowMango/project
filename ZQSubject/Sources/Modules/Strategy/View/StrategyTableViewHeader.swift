

import UIKit
import FSPagerView

class StrategyTableViewHeader: UIView {
    
    var ads_L02: [StrategyProduct] = []
    var ads_L03: [AppResource.ResourceData] = []
    
    private lazy var pageControl = {
        let control = FSPageControl()
        control.contentHorizontalAlignment = .center
        control.setFillColor(.white.withAlphaComponent(0.5), for: .normal)
        control.setFillColor(.white, for: .selected)
        control.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: wScale(8), height: wScale(4)), cornerRadius: wScale(2)), for: .selected)
        control.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: wScale(4), height: wScale(4)), cornerRadius: wScale(2)), for: .normal)
        return control
    }()
    func setupUI() {
        subviews.forEach { $0.removeFromSuperview() }
        
        let stackView = UIStackView()
        stackView.axis = .vertical // 设置排列方向为垂直
        stackView.distribution = .equalSpacing
        stackView.alignment = .center // 子视图在其框架内的对齐方式
        stackView.spacing = wScale(14) // 子视图之间的间距()
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        let count: Int = min(ads_L02.count, 3)
        if count > 0 {
            for index in 0..<count {
                let view = StrategyInfoView()
                stackView.addArrangedSubview(view)
                view.snp.makeConstraints { make in
                    make.height.equalTo(wScale(187))
                    make.width.equalTo(wScale(347))
                }
                view.strategy = ads_L02[index]
                view.reloadData()
            }
        }
       
        
        if ads_L03.count > 0 {
            let count = ads_L03.count
            let L03View = getL03AdsView()
            L03View.isScrollEnabled = count > 1
            L03View.automaticSlidingInterval = count > 1 ? 3.0 : 0.0
            pageControl.isHidden = count == 1
            stackView.addArrangedSubview(L03View)
            L03View.snp.makeConstraints { make in
                make.height.equalTo(wScale(100))
                make.width.equalTo(wScale(347))
            }
        }
        
        // 约束stackView以确定其大小和位置
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func getL03AdsView() -> FSPagerView {
        let bannerView = FSPagerView()
        bannerView.register(L03BannerCell.self, forCellWithReuseIdentifier: "L03BannerCell")
        bannerView.delegate    = self
        bannerView.dataSource  = self
        bannerView.isInfinite = true

        bannerView.addSubview(pageControl)
        pageControl.contentHorizontalAlignment = .center
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(wScale(4))
            make.left.right.equalToSuperview()
            make.height.equalTo(wScale(10))
        }
        return bannerView
    }
    
    func layout(_ products: [StrategyProduct], banners:[AppResource.ResourceData]) -> CGFloat {
        let count: Int = min(products.count, 3)
        var height: CGFloat = CGFloat(count) * wScale(187) + CGFloat(count - 1) * wScale(14)
        if banners.count > 0 {
            height += wScale(100 + 14)
        }
//        setupUI()
        return height
    }
}

extension StrategyTableViewHeader: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        pageControl.numberOfPages = ads_L03.count
        return ads_L03.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "L03BannerCell", at: index)
        let model = ads_L03[index]
        cell.imageView?.kf.setImage(with: model.resourceUrl?.validURL())
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let model = ads_L03[index]
        JumpManager.jumpToWeb(model.linkAddress)
        pagerView.deselectItem(at: index, animated: false)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}


class L03BannerCell: FSPagerViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultSet()
    }
    
    ///取消高亮状态
    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = false
        }
        get {
            return super.isHighlighted
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSet()
    }
    
    func defaultSet() {
        self.imageView?.layer.cornerRadius = wScale(10)
        self.imageView?.layer.masksToBounds = true
        self.imageView?.contentMode = .scaleAspectFill
        self.contentView.layer.shadowOpacity = 0
    }
}
