
import UIKit
import Then
import FSPagerView

class TopBannerView: UIView{

    var banners: [AppResource.ResourceData] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(){
        pagerView.isScrollEnabled = banners.count > 1
        pagerView.automaticSlidingInterval = banners.count > 1 ? 3.0 : 0.0
        self.pagerView.reloadData()
    }
    func setupUI() {

        self.addSubview(self.pagerView)
        pagerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(0)
        }
    }
    
    private lazy var pageControl = {
        let control = FSPageControl()
        control.contentHorizontalAlignment = .center
        control.setFillColor(.white.withAlphaComponent(0.5), for: .normal)
        control.setFillColor(.white, for: .selected)
        control.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: wScale(8), height: wScale(4)), cornerRadius: wScale(2)), for: .selected)
        control.setPath(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: wScale(4), height: wScale(4)), cornerRadius: wScale(2)), for: .normal)
        return control
    }()
    
    lazy var pagerView: FSPagerView = {
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
    }()
}

extension TopBannerView: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        pageControl.numberOfPages = banners.count
        return banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "L03BannerCell", at: index)
        let model = banners[index]
        cell.imageView?.kf.setImage(with: model.resourceUrl?.validURL())
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let model = banners[index]
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
