import Foundation

struct UPCEAdapter: BarcodeAdapter {
    
    static var type: BarcodeType {
        return .upce
    }
    
    static func validate(forBarcode barcode: String?) -> Bool {
        guard let barcode = barcode else { return false }
        return barcode.count == 8
    }
    
    static func embeddedType(forBarcode barcode: String?) -> BarcodeEmbeddedType {
        return .none
    }
    
    static func embeddedValue(forBarcode barcode: String?, forType type: BarcodeEmbeddedType) -> Float {
        return 0
    }
    
    static func convert(_ barcode: String?, toType type:BarcodeType) -> String? {
        guard let barcode = barcode else { return nil }
        switch type {
        case .plu:
            return convertToUPCA(barcode)
        case .upca:
            return convertToUPCA(barcode)
        case .upce:
            return barcode
        default:
            return nil
        }
    }
    
    fileprivate static func convertToUPCA(_ barcode: String) -> String? {
        guard barcode.count >= 8 else { return nil }

        if (barcode[0] == "0" || barcode[0] == "1") {
            
            if (barcode[6] == "0" || barcode[6] == "1" || barcode[6] == "2") {
                
                return barcode[0..<3].appending(barcode[6]).appending("0000").appending(barcode[3..<6]).appending(barcode[7])
                
            } else if barcode[6] == "3" {
                
                return barcode[0..<4].appending("00000").appending(barcode[4..<6]).appending(barcode[7])
                
            } else if barcode[6] == "4" {
                
                return barcode[0..<5].appending("00000").appending(barcode[5]).appending(barcode[7])
                
            } else if barcode[6] == "5" || barcode[6] == "6" || barcode[6] == "7" || barcode[6] == "8" || barcode[6] == "9" {
                
                return barcode[0..<6].appending("0000").appending(barcode[6]).appending(barcode[7])
            }
        }
        return nil
    }
}
