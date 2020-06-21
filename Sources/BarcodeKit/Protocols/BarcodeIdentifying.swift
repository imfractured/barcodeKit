import Foundation

public protocol BarcodeIdentifying {
    static var type: BarcodeType { get }
}

public extension BarcodeIdentifying {
    
    static var type: BarcodeType {
        return .none;
    }
}
