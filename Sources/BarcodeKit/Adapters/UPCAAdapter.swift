import Foundation

struct UPCAAdapter: BarcodeAdapter {
    
    static var type: BarcodeType {
        return .upca
    }
    
    static func validate(forBarcode barcode: String?) -> Bool {
        guard let barcode = barcode else { return false }
        return 12 <= barcode.count && barcode.count <= 14
    }
    
    static func embeddedType(forBarcode barcode: String?) -> BarcodeEmbeddedType {
        guard let barcode = barcode else { return .none }
        if (barcode.count == 13 && barcode.hasPrefix("02")) || (barcode.count == 12 && barcode.hasPrefix("2")) {
            return .price
        } else if barcode.count == 13 && barcode.hasPrefix("21") {
            return .weight
        }
        return .none
    }
    
    static func embeddedValue(forBarcode barcode: String?, forType type: BarcodeEmbeddedType) -> Float {
        guard embeddedType(forBarcode: barcode) == type, let barcode = barcode else { return 0 }
        let isPriceEmbedded = embeddedType(forBarcode: barcode) == .price
        var priceInBarcode = barcode[barcode.index(barcode.endIndex, offsetBy: -(isPriceEmbedded ? 5 : 6))...]
        priceInBarcode = priceInBarcode.dropLast()
        let centValue: Float = Float(priceInBarcode) ?? 0
        return centValue / (isPriceEmbedded ? 100.0 : 1000.0);
    }
    
    static func convert(_ barcode: String?, toType type: BarcodeType) -> String? {
        guard let barcode = barcode else { return nil }
        switch type {
        case .plu:
            switch embeddedType(forBarcode: barcode) {
            case .price:
                if barcode.hasPrefix("0") {
                    let returnString = String(barcode.dropFirst())
                    return String(barcode.dropFirst())[..<returnString.index(returnString.startIndex, offsetBy: 6)] + "0"
                } else {
                    return barcode[..<barcode.index(barcode.startIndex, offsetBy: 6)] + "0"
                }
            case .weight:
                let pluString = barcode[barcode.index(barcode.startIndex, offsetBy: 2)..<barcode.index(barcode.startIndex, offsetBy: 7)]
                let removedLeadingZeros = pluString.replacingOccurrences(of: "^0+(?!$)", with: "", options: .regularExpression, range: pluString.startIndex..<pluString.endIndex)
                return removedLeadingZeros
            default:
                return barcode
            }
        case .upca:
            return barcode
        default:
            return nil
        }
    }
}
