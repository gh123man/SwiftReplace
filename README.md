# SwiftReplace
A better, swifty interface for NSRegularExpression.
This is an extension to the string class. As a result you can call this on any string in your package. Here is an example:

```swift
> "I like apples".replace("apples") { "oranges" }
I like oranges
```


This is just a simple word for word replace. Where this gets more powerful is when you want to use capture groups. Lets try to swap two words:

```swift
> "apples oranges apples oranges".replace("(\\w*) (\\w*)\\s*") { return "\($0[2]) \($0[1]) " }
oranges apples oranges apples 
```

This is functionally equivalent to `%s/(\w*) (\w*)\s*/\2 \1 /g` in Vim.

What is happening here is the closure collector gets called for every match of the pattern. 
This closure's arguments are an array of the capture group results. So `$0[0]` contains the full pattern match. 
`$0[1]` contains the first capture group and `$0[n]` can address the rest of the capture groups.

## Taking it further 
This has other advantages since you are not limited to working with strings, and because you can alter the string in the closure you can add more complex logic to rewrite your input. Lets increment numbers:
```swift
> Nums: 1 2 3 4 5 6 7 8 9 10".replace("(\\d+)") { String(Int($0[1])! + 1) }
Nums: 2 3 4 5 6 7 8 9 10 11
```
By casting the matched number into an Int we can perform other operations on it. Another example could be rewriting a timestamp:
```swift
> "Log date: 1413937910 ....".replace("(\\d+)") { return Date(timeIntervalSince1970: TimeInterval($0[1])!).description }
Log date: 2014-10-22 00:31:50 +0000 ....
```
