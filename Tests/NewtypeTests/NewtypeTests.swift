import XCTest
import Newtype

struct Label: Newtype {
    var value: String
}

struct UppercaseLabel: Newtype {
    var value: String
}

func uppercase(_ s: String) -> String {
    return s.uppercased()
}

struct Meter: Newtype {
    var value : Int
}

struct SquareMeter: Newtype {
    var value: Int
}

func multiply(_ x: Int) -> (_ y: Int) -> Int {
    return { y in
        return x * y
    }
}

class NewtypeTests: XCTestCase {
    func testWrapUnwrap() {
        let text = "Hello, World!"
        let wrapped: Label = wrap(text)
        let unwrapped = unwrap(wrapped)
        XCTAssertEqual(unwrapped, text)
    }

    func testUnwrapWrap() {
        let label = Label("Hello, World!")
        let unwrapped = unwrap(label)
        let wrapped: Label = wrap(unwrapped)
        XCTAssertEqual(wrapped, label)
    }

    func testOver() {
        let uppercaseLabel: (Label) -> Label = over(uppercase)
        let label = Label("Hello, World!")
        let uppercased = uppercaseLabel(label)
        XCTAssertEqual(uppercased, Label("HELLO, WORLD!"))
    }

    func testOverPolymorphicReturnType() {
        let uppercaseLabel: (Label) -> UppercaseLabel = over(uppercase)
        let label = Label("Hello, World!")
        let uppercased = uppercaseLabel(label)
        XCTAssertEqual(uppercased, UppercaseLabel("HELLO, WORLD!"))
    }

    func testOver2() {
        let length = Meter(2)
        let breadth = Meter(3)
        let area: (Meter) -> (Meter) -> SquareMeter = over2(multiply)
        XCTAssertEqual(area(length)(breadth), SquareMeter(6))
    }

    static var allTests = [
        ("unwrap <<< wrap = id", testWrapUnwrap),
        ("wrap <<< unwrap = id", testUnwrapWrap),
        ("over", testOver),
        ("over (polymorphic return type)", testOverPolymorphicReturnType),
        ("over2", testOver2),
    ]
}
