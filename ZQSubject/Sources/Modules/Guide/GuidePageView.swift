//
//  GuidePageView.swift
//  BaseProject
//
//  Created by Dason on 2020/3/30.
//  Copyright © 2020 Dason. All rights reserved.
//

import UIKit

public class GuidePageView: UIView {
    
    private var imageArray: Array<String>?
    // 是否隐藏跳过按钮(true 隐藏; false 不隐藏)，default: false
    private var isHiddenSkipBtn: Bool = false
    // 是否隐藏立即体验按钮(true 隐藏; false 不隐藏)，default: false
    private var isHiddenStartBtn: Bool = false
    // 是否隐藏页码指示器(true 隐藏; false 不隐藏)，default: false
    private var isHiddenPageControl: Bool = false
    private var pageControlBottom = 60.0
    private var startBtnBottom = 100.0
    
    private lazy var guideScrollView: UIScrollView = {
        let view = UIScrollView.init()
        view.backgroundColor = UIColor.lightGray
        view.bounces = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    
    public lazy var pageControl: PageControl = {
        var pageControl = PageControl()
        let size = CGSize(width: 7, height: 7)
        let normalImage = creatImage(color:UIColor.init(r: 236, g: 236, b:  236), size: size, cornerRadius: size.width * 0.5)
        let selectedImage = creatImage(color: UIColor.init(r: 27, g: 113, b: 255), size: size, cornerRadius: size.width * 0.5)
        pageControl.setImage(normalImage, for: .normal)
        pageControl.setImage(selectedImage, for: .selected)
        pageControl.itemSpacing = 8
        pageControl.isHidden = isHiddenPageControl
        return pageControl
    }()
    
    /// 跳过按钮
    public lazy var skipButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.setTitle("跳 过", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(skipBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    /// 立即体验按钮
    public lazy var startButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("立即体验", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(startBtnClicked), for: .touchUpInside)
        btn.layer.cornerRadius = wScale(20)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    var startCompletion: (() -> ())?
    let pageControlHeight: CGFloat = 7
    let startHeigth: CGFloat = wScale(40)
    
    /// 是否打开左滑跳过
    public var canSlipSkip: Bool = false {
        willSet{
            if newValue {
                // 设置
                guideScrollView.contentSize = CGSize.init(width: frame.size.width * CGFloat(imageArray?.count ?? 0) + 1.0, height: frame.size.height)
            }
        }
    }
    
    // MARK: - life cycle
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// App启动引导页
    ///
    /// - Parameters:
    ///   - frame: 引导页大小
    ///   - images: 引导页图片或者gif
    ///   - isHiddenSkipBtn: 是否隐藏跳过按钮
    ///   - isHiddenStartBtn: 是否隐藏立即体验按钮
    ///   - loginRegistCompletion: 登录/注册回调
    ///   - startCompletion: 立即体验回调
    public convenience init(frame: CGRect = UIScreen.main.bounds,
                            images: Array<String>,
                            isHiddenSkipBtn: Bool = false,
                            isHiddenStartBtn: Bool = false,
                            isHiddenPageControl: Bool = false,
                            startCompletion: (() -> ())?) {
        self.init(frame: frame)
        
        self.imageArray       = images
        self.isHiddenSkipBtn  = isHiddenSkipBtn
        self.isHiddenStartBtn = isHiddenStartBtn
        self.isHiddenPageControl = isHiddenPageControl
        self.startCompletion  = startCompletion
        
        setupSubviews(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    private func setupSubviews(frame: CGRect) {
        let size = UIScreen.main.bounds.size
        guideScrollView.frame = frame
        guideScrollView.contentSize = CGSize.init(width: frame.size.width * CGFloat(imageArray?.count ?? 0), height: frame.size.height)
        self.addSubview(guideScrollView)
        
        skipButton.frame = CGRect.init(x: size.width - 80.0 , y: kSafeTopH() + 15.0, width: 50.0, height: 24.0)
        skipButton.isHidden = isHiddenSkipBtn
        self.addSubview(skipButton)
        
        pageControl.frame = CGRect(x: 0.0, y: size.height - pageControlHeight - pageControlBottom, width: size.width, height: pageControlHeight)
        pageControl.numberOfPages = imageArray?.count ?? 0
        self.addSubview(pageControl)
        
        guard imageArray != nil, imageArray?.count ?? 0 > 0 else { return }
        for index in 0..<(imageArray?.count ?? 1) {
            let name        = imageArray![index]
            let imageFrame  = CGRect.init(x: size.width * CGFloat(index), y: 0.0, width: size.width, height: size.height)
            //获取本地资源路径
            let filePath    = Bundle.main.path(forResource: name, ofType: nil) ?? ""
            let data: Data? = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath), options: Data.ReadingOptions.uncached)
            var view: UIView
            let type = GifImageOperation.checkDataType(data: data)
            if type == DataType.gif {   // gif
                view = GifImageOperation.init(frame: imageFrame, gifData: data!)
            } else {                    // 其它图片
                view = UIImageView.init(frame: imageFrame)
                view.contentMode = .scaleAspectFill
                // Warning: 假如说图片是放在Assets中的，使用Bundle的方式加载不到，需要使用init(named:)方法加载。
                (view as! UIImageView).image = (data != nil ? UIImage.init(data: data!) : UIImage.init(named: name))
                (view as! UIImageView).layer.masksToBounds = true
            }
            // 添加“立即体验”按钮和登录/注册按钮
            if imageArray?.last == name {
                view.isUserInteractionEnabled = true
                if !isHiddenStartBtn {
                    let y = size.height - startHeigth - startBtnBottom
                    let width = wScale(114)
                    startButton.frame = CGRect.init(x: (size.width - width) * 0.5, y: y, width: width, height: startHeigth)
                    view.addSubview(startButton)
                }
            }
            guideScrollView.addSubview(view)
        }
    }
    
    // MARK: - actions
    private func removeGuideViewFromSupview() {
        UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    /// 点击“跳过”按钮事件，立即退出引导页
    @objc private func skipBtnClicked() {
        if self.startCompletion != nil {
            self.startCompletion!()
        }
        self.removeGuideViewFromSupview()
    }
    
    /// 点击“立即体验”按钮事件，退出引导页
    @objc private func startBtnClicked() {
        if self.startCompletion != nil {
            self.startCompletion!()
        }
        self.removeGuideViewFromSupview()
    }
    
    /// 根据UIColor创建UIImage
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    /// - Returns: 图片
    private func creatImage(color: UIColor, size: CGSize = CGSize.init(width: 100, height: 100), cornerRadius: CGFloat = 0) -> UIImage {
        let size = (size == CGSize.zero ? CGSize(width: 100, height: 100): size)
        let frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        if cornerRadius > 0 {
            let path = UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius)
            context.addPath(path.cgPath)
            context.clip()
        }
        context.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: - <UIScrollViewDelegate>
extension GuidePageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page: Int = lroundf(Float(scrollView.contentOffset.x / scrollView.bounds.size.width))
        // 设置指示器
        pageControl.currentPage = page
        
        if canSlipSkip {
            //设置左边无弹簧,右边有弹簧
            guideScrollView.bounces = scrollView.contentOffset.x <= 0 ? false : true
        }
        
        let totalWidth = UIScreen.main.bounds.size.width * CGFloat((imageArray?.count ?? 1) - 1)
        let offsetX = scrollView.contentOffset.x - totalWidth
        if offsetX > 30 {
            // 左滑退出后,仍然会触发该代理方法,所以设置isScrollEnabled = false,防止多次触发下面的代码.
            scrollView.isScrollEnabled = false
            // 立刻设置偏移
            var frame = self.guideScrollView.frame
            frame.origin.x = -offsetX
            self.guideScrollView.frame = frame
            
            // 剩余的部分偏移添加动画
            UIView.animate(withDuration: 1.0, animations: {
                self.guideScrollView.alpha = 0.0
                var frame = self.guideScrollView.frame
                frame.origin.x = -UIScreen.main.bounds.size.width
                self.guideScrollView.frame = frame
            }) { (_) in
                self.startBtnClicked()
            }
        }
    }
}

