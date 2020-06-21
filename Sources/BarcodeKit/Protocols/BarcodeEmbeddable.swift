import Foundation

public protocol BarcodeEmbeddable {
    static func embeddedType(forBarcode barcode: String?) -> BarcodeEmbeddedType
    static func embeddedValue(forBarcode barcode: String?, forType type: BarcodeEmbeddedType) -> Float
}
