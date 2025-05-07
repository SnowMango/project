class UpgradeModel {
    ///升级标题
    var appTitle: String?
    ///APP 版本号
    var appVersionCode: Int?
    ///APP版本号 字符串
    var appVersionDesc: String?
    ///APP 版本升级介绍
    var appDesc: String?
    ///升级_方式：1-建议升级|2-强制升级
    var upgradeWay: Int?
    ///升级弹框是否每次都弹出：0-否|1-是
    var dialogRepeat: Int?
    ///升级链接
    var url: String?
    var channel: String?
    
    ///如果，dialogRepeat=0，用于判断是否弹出过
    var showed: Bool?
    
    
    required init() {}
}
