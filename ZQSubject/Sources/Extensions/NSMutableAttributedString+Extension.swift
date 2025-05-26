

extension NSMutableAttributedString {
    
    func add(_ attribute: NSAttributedString.Key, value: Any, range: NSRange? = nil) -> Self {
        var new = NSRange(location: 0, length: self.string.count)
        if let range = range {
            new = range
        }
        addAttribute(attribute, value: value, range: new)
        return self
    }
    
    func add(_ attrs: [NSAttributedString.Key : Any] = [:], range: NSRange? = nil) -> Self {
        var new = NSRange(location: 0, length: self.string.count)
        if let range = range {
            new = range
        }
        addAttributes(attrs, range: new)
        return self
    }
    
}
