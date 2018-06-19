# Newtype

**Consider using [pointfreeco/swift-tagged](https://github.com/pointfreeco/swift-tagged) instead.**

An approximation of newtypes in Swift. Inspired by [purescript-newtype](https://github.com/purescript/purescript-newtype).

The `Newtype` protocol provides default implementations to enable convenient wrapping and unwrapping, and the use of the other functions in this module.


## Usage

Borrowing from [the section on newtypes in PureScript by Example](https://leanpub.com/purescript/read#leanpub-auto-newtypes), we might want to define newtypes for `Int` to ascribe units like pixels and inches:

```swift
import Newtype

struct Pixels: Newtype { let value: Int }
struct Inches: Newtype { let value: Int }
```

This way, it is impossible to pass a value of type `Pixels` to a function which expects `Inches`.
