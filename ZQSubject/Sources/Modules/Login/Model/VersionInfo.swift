
struct VersionInfo: Decodable {
    // 是否强制升级标记 0不强制升级 1强制升级
    var isForceUpgrade: Int = 0
    // 操作系统 0安卓 1ios
    var type: Int = 1
    // 版本号
    let versionName:String
    // 升级描述
    let upgradeMessage:String?
    
    let versionCode: Int?
    // 下载地址
    let downloadAddressUrl:String?
    
}
