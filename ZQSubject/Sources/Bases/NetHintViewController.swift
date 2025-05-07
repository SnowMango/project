import UIKit
import SnapKit

class NetHintVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.navigationItem.title = "未能连接到互联网"
    
        let backButtonImage = UIImage(named: "as_back_bar")
        let backButton =  UIButton.init(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.setImage(backButtonImage, for: .highlighted)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let label1 = UILabel()
        label1.text = "建议按照以下方法检查网络连接"
        label1.font = .boldSystemFont(ofSize: 16)
        view.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(wScale(15))
            make.top.equalToSuperview().offset(wScale(30))
        }
        
        let label2 = UILabel()
        label2.numberOfLines = 0
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.attributedText = attributedString("1.打开手机“设置”并把“无线局域网”保持开启状态。")
        view.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.left.equalTo(label1)
            make.top.equalTo(label1.snp.bottom).offset(wScale(30))
            make.right.equalToSuperview().offset(-wScale(15))
        }
        
        let label3 = UILabel()
        label3.numberOfLines = 0
        label3.font = UIFont.systemFont(ofSize: 14)
        label3.attributedText = attributedString("2.打开手机“设置”-“蜂窝网络”-“蜂窝数据”，并在下方“使用无线局域网与蜂窝网络的APP中”将“\(kAppName)”的权限设置为“WLAN与蜂窝网络”")
        view.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.left.right.equalTo(label2)
            make.top.equalTo(label2.snp.bottom).offset(wScale(30))
        }
        
        let label4 = UILabel()
        label4.numberOfLines = 0
        label4.font = UIFont.systemFont(ofSize: 14)
        label4.attributedText = attributedString("3.如果仍然无法连接网络，请检查手机是否接入互联网或咨询运营商。")
        view.addSubview(label4)
        label4.snp.makeConstraints { (make) in
            make.left.right.equalTo(label3)
            make.top.equalTo(label3.snp.bottom).offset(wScale(30))
        }
        
        let label5 = UILabel()
        label5.numberOfLines = 0
        label5.font = UIFont.systemFont(ofSize: 14)
        label5.attributedText = attributedString("4.重启APP或者手机")
        view.addSubview(label5)
        label5.snp.makeConstraints { (make) in
            make.left.right.equalTo(label4)
            make.top.equalTo(label4.snp.bottom).offset(wScale(30))
        }
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func attributedString(_ str: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attr = NSMutableAttributedString(string: str)
        attr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: str.count))
        return attr
    }
    
}
