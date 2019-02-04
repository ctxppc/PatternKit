# The *PatternKit* library
**PatternKit** is a Swift-based nondeterministic automaton parser and regular expression engine.

+ Fully designed for and written in Swift
+ Supports arbitrary `Sequence`s with `Equatable` elements (`String`, `[Int]`, and so on)
+ Batteries included — including full support for matching over Unicode extended grapheme clusters
+ Type-safe — syntax checked at build time by the compiler
+ No parsing/building overhead
+ Value semantics
+ Extensible architecture
+ Backreferences
+ Backtracking
+ Shorthand and longhand notation

PatternKit is still a pre-1.0 project — please use with care. :-)

## Usage
(Author's note: Some examples in this document might become outdated as PatternKit evolves.)

The following matches very simple e-mail addresses.

    import PatternKit
	
    let alphanumeric = ("A"..."Z") | ("a"..."z") | ("0"..."9")
    let part = alphanumeric+ • "." • alphanumeric+
    
    let userToken = Token(part)
    let hostToken = Token(part)
    
    let emailAddress = userToken • ("@" as Literal) • hostToken
    
    if let match = emailAddress.matches(over: "johnny.appleseed@example.com").first {
        let userPart = match.captures(for: userToken)[0]
        let hostPart = match.captures(for: hostToken)[0]
        print("User \(userPart) at \(hostPart)")		// Prints "User johnny.appleseed at example.com"
    }

Note that the `Match.captures(for:)` method returns an array of captured strings instead of a single string. Like in other regex engines, a token can be used within a repeating pattern. However, unlike most engines, every new capture by that token is appended to the array instead of discarded.

The following matches the request line of a simple HTTP request.

    import PatternKit
    
    let verb = "GET" | "POST" | "PUT" | "HEAD" | "DELETE" | "OPTIONS" | "TRACE"
    let version = "0"..."9" • ("." • "0"..."9")+
    
    let pathComponent = "A"..."Z" | "a"..."z" | "0"..."9" | "_" | "+"
    let path = ("/" • pathComponent*)+
    let pathToken = Token(path)
    
    let requestLine = Anchor.leading • "GET" • CharacterSet.whitespace+ • pathToken • "HTTP/" • version • "\x10\x13"

The following matches subsequences of three or more 6s, followed by two rolls greater than or equal to 3, and followed by three or more 6s again.

    let snakes = 6.repeated(min: 3)
    let pattern = snakes • (3...6).repeated(exactly: 2) • snakes
    let diceRolls = [1, 5, 2, 6, 6, 6, 4, 4, 6, 6, 6, 4, 3, 6, 6, 6, 3, 5, 6, 6, 6, 6]
    
    for match in pattern.matches(in: diceRolls) {
        let diceRollsNumber = match.startIndex + 1
        let foundPattern = match.subsequence.joined(separator: " ,")
        print("Pattern \(foundPattern) found at roll (diceRollsNumber)")
    }
    
    // Prints "Pattern 6, 6, 6, 4, 4, 6, 6, 6 found at roll 4" and "Pattern 6, 6, 6, 3, 5, 6, 6, 6, 6 found at roll 14"

The following matches any subsequence of a's, followed by b's, and followed by the same number of a's.

    let firstPart = Token("a"+)
    let secondPart = "b"+
    let thirdPart = Referencing(firstPart)
    let pattern = firstPart • secondPart • thirdPart
    
    print(pattern.hasMatches(in: "aaaabbbaaaa"))		// Prints "true"

PatternKit supports all target `Sequence`s with `Equatable` elements. Non-`Comparable` elements which are `Equatable` are also supported, but without support of ranges (`...` and `..<`).

## Available patterns & extensibility
PatternKit is designed from the ground up to be extensible with more patterns. Patterns are values that conform to the `Pattern` protocol. PatternKit provides the following pattern types, and clients can implement more themselves as needed.

* A literal pattern (`Literal`) matches an exact sequence. PatternKit includes literal-convertible conformances so that string, character, and integer literals can be used directly within pattern expressions, without having to resort to the `Literal` initialiser.

* A repeating pattern (`EagerlyRepeating` and `LazilyRepeating`) matches a subpattern consecutively, with an optional minimum and maximum. PatternKit extends `Equatable` and `Pattern` with the `repeated(min:)`, `repeated(min:max:)`, and `repeated(exactly:)` methods as well as the `*`, `+`, and `¿` postfix operators which form a repeating pattern on the element, sequence, or subpattern it's called on.

* An anchor (`Anchor`) matches a boundary or position, such as a word boundary or the beginning of the sequence. By default, pattern matching begins and ends anywhere in a sequence, so leading and trailing anchors are required if a pattern must match the whole sequence at once.

* A token (`Token`) matches what its subpattern matches, but also captures it. The captured subsequences can be retrieved using `match.captures(for: token)`.

* A referencing pattern (`Referencing`) matches a subsequence previously captured by a token.

In addition, PatternKit adds conformance to Swift's range types and Foundation's `CharacterSet` so that they can be used readily in patterns.