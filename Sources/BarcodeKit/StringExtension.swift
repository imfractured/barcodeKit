import Foundation

extension String {
    
    public var toDigits: String {
        return replacingOccurrences(of: "[^\\d]", with: "", options: .regularExpression, range: startIndex..<endIndex)
    }
    
    public subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: (range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
}
