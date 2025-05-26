
@preconcurrency import WebKit
import DeviceKit
import Combine

class BaseWebController: BaseViewController {
    
    /// NSKeyValueObservation
    fileprivate var observerProgress: NSKeyValueObservation?
    fileprivate var observerTitle: NSKeyValueObservation?
    
    override func stashInNavigationStack() -> Bool {
        return false
    }
    
    /// web页面
    lazy var webView: WKWebView = {
        
        //设置网页的配置文件
        let configuration = WKWebViewConfiguration()
        
        // 允许可以与网页交互，选择视图
        configuration.selectionGranularity = .character
        
        // web内容处理池
        configuration.processPool = WKProcessPool()
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        
        //自定义WKScriptMessageHandler，webview不释放问题
        let weakUserContent = WeakScriptMessageDelegate(self)
        configuration.userContentController.add(weakUserContent, name: "closeWeb")
        configuration.userContentController.add(weakUserContent, name: "getInfomation")
        configuration.userContentController.add(weakUserContent, name: "logOut")
        // webView初始化时要给一个frame, 不然某些机型或系统下, webView 排版出错
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()

    /// 加载的原始url,这个url不会随着web的内部跳转而改变,记录的是第一个加载的url
    private var firstLoadUrl: String = ""
 
    /// 当前页面url
    private var currentURL: URL?
    
    /// 进度条
    var progressView: UIProgressView = {
        let p = UIProgressView(frame: CGRect(x: 0, y: kStatusBarH(), width: SCREEN_WIDTH, height: 2))
        p.progressViewStyle = .default
        p.trackTintColor = UIColor.clear
        p.progressTintColor = UIColor.blue
        p.isHidden = true
        if #available(iOS 14, *) {
            p.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        }
        return p
    }()
    
    //页面关闭的回调
    var dismissedBlock: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kBackGround
        setupUI()
        //取消webView的自动适配偏移
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func backButtonAction() {
        //重写返回事件,如果是可以后退的web就后退,不可以的才返回上一个页面
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.backButtonAction()
        }
    }
    
    /// url 的配置
    func urlConfig(_ urlString: String) -> String {
        var url = urlString
        /// 拼接token
        let isInner = checkIsInnerURL(url)
        if isInner, !url.contains("token"), let token = AppManager.shared.token {
            url = url.contains("?") ? url + "&token=\(token)" : url + "?token=\(token)"
        }
        
        return url
    }
   
    
    ///判断是否内部链接
    func checkIsInnerURL(_ url: String?) -> Bool {
        guard let url = url  else {
            return false
        }
        var isInner = false
        let preUrl = url.split(separator: "?").first!
        let hostList = env.tokenWebHost.split(separator: ",")
        //循环host,判断是否需要添加token
        hostList.forEach { (host) in
            if preUrl.contains(host){
                //内部H5
                isInner = true
                return
            }
        }
        return isInner
    }
    
    func startLoadUrl(url: String, originUrl: String? = nil) {
        firstLoadUrl = urlConfig(url)
        if let url: URL = firstLoadUrl.validURL() {
            webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        }
    }

    deinit {
        dismissedBlock?()
    }
}

//MARK: - UI
extension BaseWebController {
    
    /// 初始化UI
    private func setupUI() {

        ///监听加载进度,用于展示进度条
        observerProgress = webView.observe(\WKWebView.estimatedProgress, options: .new, changeHandler: { [weak self] (_, _) in
            
            if let self = self, self.progressView.isHidden == false {
                
                self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
                
                if self.webView.estimatedProgress >= 1 {
                    //设置进度条消失动画
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                        self.progressView.alpha = 0
                    }) { (_) in
                        self.progressView.setProgress(0, animated: false)
                    }
                }
            }
        })
        
        ///监听H5的title
        observerTitle = webView.observe(\WKWebView.title, options: .new, changeHandler: { [weak self] (_, _) in
            if let title = self?.webView.title {
                self?.titleName = title
                return
            }
         
            if let currentURL = self?.currentURL {
                self?.webView.load(URLRequest(url: currentURL))
            } else if let url: URL = self?.firstLoadUrl.validURL() {
                self?.webView.load(URLRequest(url: url))
            }
        })
        
        /// 添加进度条
        view.addSubview(progressView)
        view.bringSubviewToFront(progressView)

    }
    
    class func clearCache(with host: String? = nil) {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: websiteDataTypes) { (records) in
            
            guard let host = host, !host.isEmpty else {
                dataStore.removeData(ofTypes: websiteDataTypes, for: records) {}
                return
            }
            
            for record in records {
                if record.displayName.contains(host) {
                    dataStore.removeData(ofTypes: record.dataTypes, for: [record]) {
                    }
                }
            }
        }
    }
}

//MARK: - Action
extension BaseWebController {
    @objc func closeAction() {
        super.backButtonAction()
    }
    
    static func baseInfo() -> String {
        let dict = [
            "channel": channel,
            "version": kAppVersion,
            "userId": kUserDefault.string(forKey: UserDefaultKey.userID.rawValue) ?? "",
            "deviceType": Device.current.safeDescription,
            "systemVersion": kDeviceSystemVersion,
            "token": kUserDefault.string(forKey: UserDefaultKey.userToken.rawValue) ?? "",
        ]
        let json = Tools.convertDictionaryToJson(dictionary: dict as NSDictionary)
        return json
    }
    
    //打电话
    private func phoneCall(url: String) {
        guard let phoneURL = URL(string: url) else {
            return
        }
        DispatchQueue.main.async {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
}

extension BaseWebController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    /// web开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载\(webView.url?.absoluteString ?? "")")
    }
    
    /// web加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
        
        self.progressView.isHidden = true
        self.view.hideHud()
        
        //尝试取消webview的长按
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
    }
    
    /// web加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      
        let err = error as NSError
        print("didFailProvisionalNavigation加载失败:\(err.description)")
        
        self.view.hideHud()
        self.progressView.progress = 0
        self.progressView.isHidden = true
        
        ///如果是特定的加载失败,不需要显示这个页面,如当页面正在加载时,离开了这个界面,那么回来的时候不需要显示加载失败
        //(错误提示:"未能完成操作。（“NSURLErrorDomain”错误 -999。）")
        // 102 "帧框加载已中断"
        // -1002 无法识别URL，可能是中文等问题
        let code = (error as NSError).code
        if code == -999 || code == 102 || code == -1002 {
            return
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //目前这个失败的触发是第三方页面再次跳转之后,点击返回会出现-999的加载错误
        let err = error as NSError
        
        print("didFail加载失败:\(err.description)")
        self.view.hideHud()
        self.progressView.progress = 0
        self.progressView.isHidden = true
    }
    /// wkwebview白屏是会调用这个方法,但是也有可能不调用
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        if let currentURL = self.currentURL {
            webView.load(URLRequest(url: currentURL))

        }
    }
    
    /// 交互方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
     
        
        func toString(_ any: Any?) -> String {
            return any as? String ?? ""
        }
        
        let paramBody = message.body as? [AnyHashable: Any]
        
        switch message.name {
        case "closeWeb":
            self.navigationController?.popViewController(animated: true)
        case "getInfomation":
            webView.evaluateJavaScript("pushInfomation('\(BaseWebController.baseInfo())')") { (msg, error) in
                guard let error = error else { return }
                print(error)
            }
        case "logOut":
            var title: String?
            if let body = paramBody {
                title = toString(body["title"])
            }
            AppManager.shared.showLogin(reason: title)
            
        default:
            return
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //targetFrame就会为nil,会出现点击无响应的问题,所以这里重新加载
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        if let url = navigationAction.request.url {
            Logger.debug("web link to \(url.absoluteString)")
            if url.scheme == "liangjie", let host = url.host {
                let stay: [String] = ["open-account","service"]
                if !stay.contains(host) {
                    self.navigationController?.popViewController(animated: false)
                }
                Router.shared.route(url.absoluteString)
                decisionHandler(.cancel)
                return
            }
        }
    
        decisionHandler(.allow)
    }
    
}

/// 解决WKScriptMessageHandler循环引用问题
class WeakScriptMessageDelegate: NSObject,WKScriptMessageHandler {
    
    weak var scriptmsgdelegate: WKScriptMessageHandler?
    
    init(_ delegate: WKScriptMessageHandler) {
        super.init()
        scriptmsgdelegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptmsgdelegate?.userContentController(userContentController, didReceive: message)
    }
    
}




