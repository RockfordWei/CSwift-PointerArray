import XCTest
@testable import CSwift
import CoreFoundation

class CSwiftTests: XCTestCase {
    func testExample() {
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: 8192)
      memset(buffer, 0, 8192)
      let r = selfTest(buffer)

      XCTAssertEqual(r, 0)
      let sa = String(cString: buffer)
      print(sa)

      var b1 = berval(bv_len: 5, bv_val: strdup("12345"))
      var b2 = berval(bv_len: 6, bv_val: strdup("123456"))
      var b3 = berval(bv_len: 4, bv_val: strdup("abcd"))
      var b4 = berval(bv_len: 3, bv_val: strdup("ABC"))
      let bx = UnsafeMutablePointer<UnsafeMutablePointer<berval>?>.allocate(capacity: 3)
      bx.advanced(by: 0).pointee = withUnsafeMutablePointer(to: &b1) { $0 }
      bx.advanced(by: 1).pointee = withUnsafeMutablePointer(to: &b2) { $0 }
      bx.advanced(by: 2).pointee = UnsafeMutablePointer<berval>(bitPattern: 0)

      let by = UnsafeMutablePointer<UnsafeMutablePointer<berval>?>.allocate(capacity: 3)
      by.advanced(by: 0).pointee = withUnsafeMutablePointer(to: &b3) { $0 }
      by.advanced(by: 1).pointee = withUnsafeMutablePointer(to: &b4) { $0 }
      by.advanced(by: 2).pointee = UnsafeMutablePointer<berval>(bitPattern: 0)

      var m0 = LDAPMod(mod_op: 1, mod_type: strdup("hello"), modv_bvals: bx)
      var m1 = LDAPMod(mod_op: 2, mod_type: strdup("world"), modv_bvals: by)
      let m = UnsafeMutablePointer<UnsafeMutablePointer<LDAPMod>?>.allocate(capacity: 3)
      m.advanced(by: 0).pointee = withUnsafeMutablePointer(to: &m0) { $0 }
      m.advanced(by: 1).pointee = withUnsafeMutablePointer(to: &m1) { $0 }
      m.advanced(by: 2).pointee = UnsafeMutablePointer<LDAPMod>(bitPattern: 0)

      memset(buffer, 0, 8192)
      modIter(m, buffer)
      let sb = String(cString: buffer)
      print(sb)

      buffer.deallocate(capacity: 8192)
      free(m0.mod_type)
      free(m1.mod_type)
      m.deallocate(capacity:3)
      free(b1.bv_val)
      free(b2.bv_val)
      free(b3.bv_val)
      free(b4.bv_val)
      bx.deallocate(capacity: 3)
      by.deallocate(capacity: 3)
      XCTAssertEqual(sa, sb)
    }


    static var allTests : [(String, (CSwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
