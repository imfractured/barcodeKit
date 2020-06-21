import Foundation
import UIKit

@objc open class BarcodeKit: NSObject {
    
    fileprivate static var adaptors: [BarcodeAdapter.Type] {
        return [PLUAdapter.self,
                UPCAAdapter.self,
                UPCEAdapter.self,
                GS1Adapter.self]
    }
    
    fileprivate static func adaptor(forBarcode barcode: String?) -> BarcodeAdapter.Type? {
        guard let barcode = barcode else { return nil }
        var returnType: BarcodeAdapter.Type?
        adaptors.forEach({
            if $0.validate(forBarcode: barcode) {
                returnType = $0
                return
            }
        })
        return returnType
    }
}


// MARK: - Barcode Type
public extension BarcodeKit {
    
    static func barcodeType(forBarcode barcode: String?) -> BarcodeType {
        return adaptor(forBarcode: barcode?.toDigits)?.type ?? .none
    }
}


// MARK: - BarcodeEmbeddable
extension BarcodeKit: BarcodeEmbeddable {
    
    public static func embeddedType(forBarcode barcode: String?) -> BarcodeEmbeddedType {
        let onlyDigitsBarcode = barcode?.toDigits
        return adaptor(forBarcode: onlyDigitsBarcode)?.embeddedType(forBarcode: onlyDigitsBarcode) ?? .none
    }
    
    public static func embeddedValue(forBarcode barcode: String?, forType type: BarcodeEmbeddedType) -> Float {
        let onlyDigitsBarcode = barcode?.toDigits
        return adaptor(forBarcode: onlyDigitsBarcode)?.embeddedValue(forBarcode: onlyDigitsBarcode, forType: type) ?? 0
    }
}


// MARK: - BarcodeValidating
extension BarcodeKit: BarcodeValidating {
    
    public static func validate(forBarcode barcode: String?) -> Bool {
        let onlyDigitsBarcode = barcode?.toDigits
        return adaptor(forBarcode: onlyDigitsBarcode)?.validate(forBarcode: onlyDigitsBarcode) ?? false
    }
}


// MARK: - BarcodeConvertable
extension BarcodeKit: BarcodeConvertable {
    
    public static func convert(_ barcode: String?, toType type: BarcodeType) -> String? {
        let onlyDigitsBarcode = barcode?.toDigits
        return adaptor(forBarcode: onlyDigitsBarcode)?.convert(onlyDigitsBarcode, toType: type)
    }
}
