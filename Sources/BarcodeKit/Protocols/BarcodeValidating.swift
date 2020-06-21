import Foundation

public protocol BarcodeValidating {
    static func validate(forBarcode barcode: String?) -> Bool
}
