import XCTest
@testable import BarcodeKit

final class BarcodeKitTests: XCTestCase {
    
    // Testing BarCodeKit methods
    
    func test_embeddedValue() {
        
        // Weight Embedded Barcodes
        XCTAssertTrue(BarcodeKit.embeddedValue(forBarcode: "2157263004707", forType: BarcodeEmbeddedType.weight) == 0.47, "Test weight for weight embedded barcode for Almonds");
        XCTAssertTrue(BarcodeKit.embeddedValue(forBarcode: "2102323005309", forType: BarcodeEmbeddedType.weight) == 0.530, "Test weight for weight embedded barcode for Assorted Fruit");
        XCTAssertTrue(BarcodeKit.embeddedValue(forBarcode: "2100434005300", forType: BarcodeEmbeddedType.weight) == 0.530, "Test weight for weight embedded barcode for Jamaican Pumpkin");
        
        // Price Embedded Barcodes
        XCTAssertTrue(BarcodeKit.embeddedValue(forBarcode: "257742611999", forType: BarcodeEmbeddedType.price) == 11.99, "Test price for price embedded barcode");
        XCTAssertTrue(BarcodeKit.embeddedValue(forBarcode: "0204011012495", forType: BarcodeEmbeddedType.price) == 12.49, "Test price for price embedded barcode");
        XCTAssertTrue(BarcodeKit.embeddedValue(forBarcode: "0270687210911", forType: BarcodeEmbeddedType.price) == 10.91, "Test price for price embedded barcode");
        XCTAssertTrue(BarcodeKit.embeddedValue(forBarcode: "0200302000009", forType: BarcodeEmbeddedType.price) == 0.00, "Test price for price embedded barcode");
        
        
    }
    
    
    func test_barcodeType() {
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "4011") == BarcodeType.plu);
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "2157263004707") == BarcodeType.upca);
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "257742611999") == BarcodeType.upca);
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "12345678") == BarcodeType.upce);
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "2107480") == BarcodeType.none);
        
        // GS1
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "(01)00000000040112(3103)001035(3922)001199") == BarcodeType.gs1, "Must begin with '(01)' and have a length of minimum 26 and maximum 36");
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "(01)01234567890128(3103)051231(1500)001199") == BarcodeType.gs1, "Must begin with '(01)' and have a length of minimum 26 and maximum 36");
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "(01)01234567890128(1500)051231") == BarcodeType.gs1, "Must begin with '(01)' and have a length of minimum 26 and maximum 36");
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "(01)00000000040112(3922)001199") == BarcodeType.gs1, "Must begin with '(01)' and have a length of minimum 26 and maximum 36");
    }
    
    func test_convert() {
        
        // Weight Embedded Barcodes
        XCTAssertTrue(BarcodeKit.convert("2157263004707", toType: BarcodeType.plu) == "57263")
        XCTAssertTrue(BarcodeKit.convert("2194036026603", toType: BarcodeType.plu) == "94036")
        XCTAssertTrue(BarcodeKit.convert("2102323005309", toType: BarcodeType.plu) == "2323")
        XCTAssertTrue(BarcodeKit.convert("2100434005300", toType: BarcodeType.plu) == "434")
        
        // Price Embedded Barcodes
        XCTAssertTrue(BarcodeKit.convert("257742611999", toType: BarcodeType.plu) == "2577420")
        XCTAssertTrue(BarcodeKit.convert("0204011012495", toType: BarcodeType.plu) == "2040110")
        XCTAssertTrue(BarcodeKit.convert("0270687210911", toType: BarcodeType.plu) == "2706870")
        XCTAssertTrue(BarcodeKit.convert("0200302000009", toType: BarcodeType.plu) == "2003020")
        
        // GS1 Barcodes
        XCTAssertTrue(BarcodeKit.convert("(01)00000000040112(3103)001035(3922)001199", toType: BarcodeType.plu) == "4011")
        XCTAssertTrue(BarcodeKit.convert("(01)00000000040112(3922)001199", toType: BarcodeType.plu) == "4011")
        XCTAssertTrue(BarcodeKit.convert("(01)00000000040082(3103)021135(3922)001199", toType: BarcodeType.plu) == "4008")
        
        // Normal Barcodes
        XCTAssertTrue(BarcodeKit.convert("058496701246", toType: BarcodeType.plu) == "058496701246")
        XCTAssertTrue(BarcodeKit.convert("063723120035", toType: BarcodeType.plu) == "063723120035")
        
        XCTAssertTrue(BarcodeKit.convert("13215460", toType: BarcodeType.upca) == "132154000060")
        XCTAssertTrue(BarcodeKit.convert("05947708", toType: BarcodeType.upca) == "059000004778")
        XCTAssertTrue(BarcodeKit.convert("13215440", toType: BarcodeType.upca) == "132150000040")
        XCTAssertTrue(BarcodeKit.convert("13215430", toType: BarcodeType.upca) == "132100000540")
        
        XCTAssertTrue(BarcodeKit.convert("", toType: BarcodeType.plu) == nil, "Should be equal to NIL")
        XCTAssertTrue(BarcodeKit.convert("1234500006", toType: BarcodeType.plu) == nil, "Should be equal to NIL")
        XCTAssertTrue(BarcodeKit.convert("1234567", toType: BarcodeType.plu) == nil, "Should be equal to NIL")
        XCTAssertTrue(BarcodeKit.convert("12345678901", toType: BarcodeType.plu) == nil, "Should be equal to NIL")
        XCTAssertTrue(BarcodeKit.convert("(010)00000000040112", toType: BarcodeType.plu) == nil, "Should be equal to NIL")
        XCTAssertTrue(BarcodeKit.convert("", toType: BarcodeType.plu) == nil, "Should be equal to NIL")
        
        // PLU Formatting
        XCTAssertTrue(BarcodeKit.convert("1234", toType: BarcodeType.plu) == "1234", "Should return the same if Code length between 1 and 5")
        XCTAssertTrue(BarcodeKit.convert("134", toType: BarcodeType.plu) == "134", "Should return the same if Code length between 1 and 5")
        
    }
    
    func test_validate() {
        XCTAssertFalse(BarcodeKit.validate(forBarcode: ""), "Should return false for empty strings.");
        XCTAssertFalse(BarcodeKit.validate(forBarcode: "abc"), "Should return false for non-numeric values.");
        XCTAssertTrue(BarcodeKit.validate(forBarcode: "acd4"), "Non-numeric values will be stripped and a value should be returned.");
        XCTAssertTrue(BarcodeKit.validate(forBarcode: "2100434005300"), "Should return true for any numeric value.");
    }
    
    func test_toDigits() {
        XCTAssertTrue("12345rf".toDigits == "12345");
        XCTAssertFalse("12345".toDigits == "123456");
    }
    
    
    func test_embeddedType() {
        XCTAssertTrue(BarcodeKit.embeddedType(forBarcode: "060383094348") == .none);
        
        XCTAssertTrue(BarcodeKit.embeddedType(forBarcode: "2102323005309") == .weight, "Must begin with '21' OR '02' and have a length of 13");
        
        
        XCTAssertTrue(BarcodeKit.embeddedType(forBarcode: "0212345678901") == .price, "Must have length of 13 and begin with 02");
        XCTAssertTrue(BarcodeKit.embeddedType(forBarcode: "212345678901") == .price, "Must have length of 12 and begin with 2");
        
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "12345678") == .upce, "Must have a length of 8");
        
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "123456789012") == .upca, "Must have a length between 12 and 14");
        XCTAssertTrue(BarcodeKit.barcodeType(forBarcode: "12345678") == .upce, "Must have a length of 8");
    }
    
    // Failures - Testing invalid embeddedTypes
    
    func testIsWeightEmbeddedFails() {
        var barcode = ""
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .weight, "Cannot be an empty string");
        barcode = "1234567890123"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .weight, "Must begin with '21'");
        barcode = "210000"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .weight, "Must have a length of 13");
        barcode = "12345"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .weight, "Must have a length of 13 and begin with '02'");
    }
    
    func testIsPriceEmbeddedFails() {
        var barcode = ""
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .price, "Cannot be an empty string");
        barcode = "1234567890123"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .price, "Must begin with '02'");
        barcode = "02111"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .price, "Must have a length of 13");
        barcode = "123456789012"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .price, "Must begin with '02'");
        barcode = "21111"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .price, "Must have a length of 12");
        barcode = "12345"
        XCTAssertFalse(BarcodeKit.embeddedType(forBarcode: barcode) == .price, "Must have a length of 13 and begin with '02' or have a length of 12 and begin with '2'");
    }
    
    func testIsValidUPCEFails() {
        var barcode = ""
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .upce, "Cannot be an empty string");
        barcode = "12345"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .upce, "Must have a length of 8");
        barcode = "123456789012345"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .upce, "Must have a length of 8");
    }
    
    func testIsValidUPCAFails() {
        var barcode = ""
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .upca, "Cannot be an empty string");
        barcode = "12345"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .upca, "Must have a length between 12 and 14");
        barcode = "123456789012345"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .upca, "Must have a length between 12 and 14");
    }
    
    func testIsGS1Fails() {
        var barcode = ""
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .gs1, "Cannot be an empty string");
        barcode = "000000000000123123123"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .gs1, "Must begin with '(01)'");
        barcode = "(01)0040112"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .gs1, "Must have a length of at least 26");
        barcode = "0040112"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .gs1, "Must begin with '(01)' and have a length of at least 26");
        barcode = "(01)00000000040112(3103)001035(3922)001199123456"
        XCTAssertFalse(BarcodeKit.barcodeType(forBarcode: barcode) == .gs1, "Must begin with '(01)' and have a length of maximum 36");
    }
    
    
}


