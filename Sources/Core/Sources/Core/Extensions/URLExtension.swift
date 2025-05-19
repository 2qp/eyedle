import Foundation

extension URL {
    public var queryParameters: [String: String]? {
        var params = [String: String]()
        guard let query = self.query else { return nil }
        
        let pairs = query.split(separator: "&")
        for pair in pairs {
            let keyValue = pair.split(separator: "=")
            if keyValue.count == 2 {
                params[String(keyValue[0])] = String(keyValue[1])
            }
        }
        return params
    }
}
