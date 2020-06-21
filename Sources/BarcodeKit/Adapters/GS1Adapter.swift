import Foundation

struct GS1Adapter: BarcodeAdapter {
    
    fileprivate static let sample = "01xxxxxxxxxPPPPxCCCCVVVVVVCCCCVVVVVV"
    fileprivate static let firstCodeRange   = sample.index(sample.startIndex, offsetBy: 16)..<sample.index(sample.startIndex, offsetBy: 19)
    fileprivate static let firstValueRange  = sample.index(sample.startIndex, offsetBy: 20)..<sample.index(sample.startIndex, offsetBy: 26)
    fileprivate static let secondCodeRange  = sample.index(sample.startIndex, offsetBy: 26)..<sample.index(sample.startIndex, offsetBy: 29)
    fileprivate static let secondValueRange = sample.index(sample.startIndex, offsetBy: 30)..<sample.index(sample.startIndex, offsetBy: 36)
    fileprivate static let pluRange = sample.index(sample.startIndex, offsetBy: 11)..<sample.index(sample.startIndex, offsetBy: 15)
    fileprivate static let priceCode = "392"
    fileprivate static let weightCode = "310"

    
    static var type: BarcodeType {
        return .gs1
    }
    
    
    static func validate(forBarcode barcode: String?) -> Bool {
        
        guard let barcode = barcode else { return false }
        return (barcode.hasPrefix("(01)") || barcode.hasPrefix("01")) && (barcode.count >= 26 && barcode.count <= 36)
    }
    
    
    static func embeddedType(forBarcode barcode: String?) -> BarcodeEmbeddedType {
        guard let barcode = barcode else { return .none }
        
        // one embedded type
        if barcode.count == 26 {
            let embedTypeCode = barcode[firstCodeRange]
            if embedTypeCode == priceCode {
                return .price
            } else if embedTypeCode == weightCode {
                return .weight
            } else {
                return .none
            }
        }
            // two embedded types
        else if barcode.count == 36 {

            let firstEmbedTypeCode = barcode[firstCodeRange]
            let secondEmbedTypeCode = barcode[secondCodeRange]
            
            if (firstEmbedTypeCode == priceCode && secondEmbedTypeCode == weightCode) || (secondEmbedTypeCode == priceCode && firstEmbedTypeCode == weightCode){
                return .priceWeight
            } else {
                return .none
            }
        }
            // no embedded types
        else {
            return .none
        }
    }
    
    
    static func embeddedValue(forBarcode barcode: String?, forType type: BarcodeEmbeddedType) -> Float {
        
        guard type != .priceWeight else { return 0 }
        let currentType = embeddedType(forBarcode: barcode)
        guard currentType == type || currentType == .priceWeight, let barcode = barcode else { return 0 }
        switch type {
        case .price:
            if currentType == .priceWeight {
                let firstEmbedTypeCode = barcode[firstCodeRange]
                if (firstEmbedTypeCode == priceCode){
                    let valueCode = barcode[firstValueRange]
                    let centValue: Float = Float(valueCode) ?? 0
                    return centValue / 100.0
                } else {
                    let valueCode = barcode[secondValueRange]
                    let centValue: Float = Float(valueCode) ?? 0
                    return centValue / 100.0
                }
            } else {
                let valueCode = barcode[firstValueRange]
                let centValue: Float = Float(valueCode) ?? 0
                return centValue / 100.0
            }
        case .weight:
            if currentType == .priceWeight {
                let firstEmbedTypeCode = barcode[firstCodeRange]
                if (firstEmbedTypeCode == weightCode){
                    let valueCode = barcode[firstValueRange]
                    let centValue: Float = Float(valueCode) ?? 0
                    return centValue / 1000.0
                } else {
                    let valueCode = barcode[secondValueRange]
                    let centValue: Float = Float(valueCode) ?? 0
                    return centValue / 1000.0
                }
            } else {
                let valueCode = barcode[firstValueRange]
                let centValue: Float = Float(valueCode) ?? 0
                return centValue / 1000.0
            }
        default:
            return 0
        }
    }
    
    
    static func convert(_ barcode: String?, toType type: BarcodeType) -> String? {
        
        guard let barcode = barcode else { return nil }
        switch type {
        case .plu:
            if barcode.count >= 15 {
                return String(barcode[pluRange])
            }
            return nil
        case .gs1:
            return barcode
        default:
            return nil
        }
    }
}
