public protocol Newtype: Equatable where UnderlyingType: Equatable {
    associatedtype UnderlyingType
    var value: UnderlyingType { get }
    init(value: UnderlyingType)
    init(_ value: UnderlyingType)
    static func wrap(_ x: UnderlyingType) -> Self
    func unwrap() -> UnderlyingType
}

public extension Newtype {
    init(_ value: UnderlyingType) {
        self.init(value: value)
    }

    static func wrap(_ x: UnderlyingType) -> Self {
        return self.init(x)
    }

    func unwrap() -> UnderlyingType {
        return self.value
    }
}

public func == <T: Newtype>(lhs: T, rhs: T) -> Bool {
    return lhs.value == rhs.value
}

public func wrap<T: Newtype>(_ x: T.UnderlyingType) -> T {
    return T.wrap(x)
}

public func unwrap<T: Newtype>(_ x: T) -> T.UnderlyingType {
    return x.unwrap()
}

// Lifts a function operate over newtypes. This can be used to lift a
// function to manipulate the contents of a single newtype, somewhat like
// `map` does for a `Functor`:
//
// ```swift
// struct Label: Newtype {
//     var value: String
// }
//
// func uppercase(_ s: String) -> String {
//     return s.uppercased()
// }
//
// let uppercaseLabel: (Label) -> Label = over(uppercase)
// ```
//
// But the result newtype is polymorphic, meaning the result can be returned
// as an alternative newtype:
//
// ```swift
// struct UppercaseLabel: Newtype {
//     var value: String
// }
//
// let uppercasedLabel: (Label) -> UppercaseLabel = over(uppercase)
// ```
public func over<T: Newtype, S: Newtype>(_ f: @escaping (T.UnderlyingType) -> S.UnderlyingType) -> ((T) -> S) {
    return { x in
        return wrap(f(unwrap(x)))
    }
}

// Lifts a binary function to operate over newtypes.
//
// ```swift
// struct Meter: Newtype { value: Int }
// struct SquareMeter: Newtype { value: Int }
//
// let area: (Meter) -> (Meter) -> SquareMeter = over2(multiply)
// ```
//
// The above example also demonstrates that the return type is polymorphic
// here too.
public func over2<T: Newtype, S: Newtype>(_ f: @escaping (T.UnderlyingType) -> (T.UnderlyingType) -> S.UnderlyingType) -> ((T) -> (T) -> S) {
    return { x in
        return { y in
            return wrap(f(unwrap(x))(unwrap(y)))
        }
    }
}
