import XCTest
@testable import CSwift
import CoreFoundation

extension Array {
  public func withUnsafeNullTerminatedPointers<R>(_ body: (UnsafeMutablePointer<UnsafeMutablePointer<Element>?>) throws -> R) rethrows -> R {

  var pArray = self.map { value -> UnsafeMutablePointer<Element>? in
    var pValue = value
    let p = UnsafeMutablePointer<Element>.allocate(capacity: 1)
    memcpy(p, UnsafeMutablePointer(mutating: &pValue), MemoryLayout<Element>.size)
    return p
  }//end map

  pArray.append(UnsafeMutablePointer<Element>(bitPattern: 0))

  let result = try body(UnsafeMutablePointer(mutating: pArray))

  pArray.forEach { pointer in
    guard let p = pointer else {
      return
    }//end p
    p.deallocate(capacity: 1)
  }//end
  return result
  }//func
}//end array


class CSwiftTests: XCTestCase {
    func testExample() {
      let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: 8192)
      memset(buffer, 0, 8192)
      let r = selfTest(buffer)

      XCTAssertEqual(r, 0)
      let sa = String(cString: buffer)
      print(sa)

      let b1 = berval(bv_len: 5, bv_val: strdup("12345"))
      let b2 = berval(bv_len: 6, bv_val: strdup("123456"))

      let bx = [b1, b2]

      memset(buffer, 0, 8192)

      let sb = bx.withUnsafeNullTerminatedPointers { pbx -> String in
        let b3 = berval(bv_len: 4, bv_val: strdup("abcd"))
        let b4 = berval(bv_len: 3, bv_val: strdup("ABC"))
        let by = [b3, b4]
        return by.withUnsafeNullTerminatedPointers { pby -> String in
          let m0 = LDAPMod(mod_op: 1, mod_type: strdup("hello"), modv_bvals: pbx)
          let m1 = LDAPMod(mod_op: 2, mod_type: strdup("world"), modv_bvals: pby)
          let m = [m0, m1]
          return m.withUnsafeNullTerminatedPointers { mptr -> String in
            modIter(mptr, buffer)
            return String(cString: buffer)
          }
        }
      }

      buffer.deallocate(capacity: 8192)
      print(sb)
      XCTAssertEqual(sa, sb)
    }


    static var allTests : [(String, (CSwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
