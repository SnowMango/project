
class FeedbackReq: Encodable {
    var contactMobile: String?
    var feedbackMessage: String = ""
    var feedbackScreenshotUrls: [String] = []
}
