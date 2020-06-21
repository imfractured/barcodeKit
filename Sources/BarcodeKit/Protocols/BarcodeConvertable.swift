import Foundation

public protocol BarcodeConvertable {
    static func convert(_ barcode: String?, toType type:BarcodeType) -> String?
}
