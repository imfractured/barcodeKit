import Foundation

struct PLUAdapter: BarcodeAdapter {
    
    static var type: BarcodeType {
        return .plu
    }
    
    static func validate(forBarcode barcode: String?) -> Bool {
        guard let barcode = barcode else { return false }
        return 1 <= barcode.count && barcode.count <= 5
    }
    
    static func embeddedType(forBarcode barcode: String?) -> BarcodeEmbeddedType {
        return .none
    }
    
    static func embeddedValue(forBarcode barcode: String?, forType type: BarcodeEmbeddedType) -> Float {
        return 0
    }
    
    static func convert(_ barcode: String?, toType type: BarcodeType) -> String? {
        switch type {
        case .plu:
            return barcode
        default:
            return nil
        }
    }
}
