
@preconcurrency import WebKit
import DeviceKit
import Combine
import RxSwift

class BaseWebController: BaseViewController {
    
    static func load(_ path: String) -> BaseWebController? {
        guard let url = URL(string: path) else {
            return nil
        }
        let web =  BaseWebController()
        web.openURL = url
        return web
    }
    
    static func load(_ url: URL) -> BaseWebController {
        let web =  BaseWebController()
        web.openURL = url
        return web
    }
    
    var openURL: URL!
    
    override func backButtonAction() {
        //重写返回事件,如果是可以后退的web就后退,不可以的才返回上一个页面
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.backButtonAction()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .kBackGround
        makeUI()
        
        webView.publisher(for: \.estimatedProgress)
            .receive(on: DispatchQueue.main)
            .asObservable()
            .subscribe(onNext: { [weak self] progress in
                self?.progressView.setProgress(Float(progress), animated: true)
            }).disposed(by: disposeBag)
        
        webView.publisher(for: \.title)
            .receive(on: DispatchQueue.main)
            .asObservable()
            .subscribe(onNext: { [weak self] title in
                self?.navigationItem.title = title
            }).disposed(by: disposeBag)
        
        webView.load(URLRequest(url: adapter(openURL)))
        
    }
    
    override func stashInNavigationStack() -> Bool {
        return false
    }
    
    func registerJS(_ configuration: WKWebViewConfiguration) {
        //自定义WKScriptMessageHandler，webview不释放问题
//        let weakUserContent = WeakScriptMessageDelegate(self)
//        configuration.userContentController.add(weakUserContent, name: "closeWeb")
//        configuration.userContentController.add(weakUserContent, name: "getInfomation")
//        configuration.userContentController.add(weakUserContent, name: "logOut")
    }
    
    
    func internalURL(_ url: URL) -> Bool {
        return url.absoluteString.hasPrefix(env.tokenWebHost)
    }
    
    func adapter(_ url: URL) -> URL {
        guard internalURL(url), let token = AppManager.shared.token else { return url }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: "token",value: token))
        components.queryItems = items
        if let newURL = components.url {
            return newURL
        }
        return url
    }
    
    func makeUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(2)
        }
    }
    
    /// web页面
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration().then {
            // 允许可以与网页交互，选择视图
            $0.selectionGranularity = .character
            $0.processPool = WKProcessPool()
            self.registerJS($0)
        }
        
        return WKWebView(frame: view.bounds, configuration: configuration).then {
                $0.allowsBackForwardNavigationGestures = true
                $0.navigationDelegate = self
                $0.uiDelegate = self
                $0.scrollView.contentInsetAdjustmentBehavior = .never
            }
    }()

    /// 进度条
    lazy var progressView: UIProgressView = {
        return UIProgressView(progressViewStyle: .default).then {
            $0.trackTintColor = UIColor.clear
            $0.progressTintColor = UIColor.blue
            $0.isHidden = true
            $0.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        }
    }()
    
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
    

}

extension BaseWebController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    /// web开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Logger.debug("\(#function)")
    }

    /// web加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Logger.debug("\(#function)")
        
        self.progressView.isHidden = true
        self.view.hideHud()
        
        //尝试取消webview的长按
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
    }
    
    /// web加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Logger.debug("\(#function)")
        self.view.hideHud()
        self.progressView.progress = 0
        self.progressView.isHidden = true
    
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Logger.debug("\(#function)")
        self.view.hideHud()
        self.progressView.progress = 0
        self.progressView.isHidden = true
        
    }
    /// wkwebview白屏是会调用这个方法,但是也有可能不调用
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        Logger.debug("\(#function)")
        
    }
    
    /// 交互方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
       
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
class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    
    weak var scriptmsgdelegate: WKScriptMessageHandler?
    
    init(_ delegate: WKScriptMessageHandler) {
        super.init()
        scriptmsgdelegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptmsgdelegate?.userContentController(userContentController, didReceive: message)
    }
}




