//
//  SwiftReplace.swift
//
//  Created by Brian Floersch on 12/7/18.
//  Copyright © 2018 Brian Floersch. All rights reserved.
//

import Foundation

extension String {
    func replace(_ pattern: String, options: NSRegularExpression.Options = [], collector: ([String]) -> String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return self }
        let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count))
        guard matches.count > 0 else { return self }
        var splitStart = startIndex
        
        return matches.map { (match) -> (String, [String]) in
            let split = String(self[splitStart ..< (index(startIndex, offsetBy: match.range.location))])
            splitStart = index(splitStart, offsetBy: split.count + match.range.length)
            return (split, (0 ..< match.numberOfRanges).map { String(self[Range(match.range(at: $0), in: self)!]) })
        }.reduce("") { "\($0)\($1.0)\(collector($1.1))" } + self[index(startIndex, offsetBy: matches.last!.range.location + matches.last!.range.length) ..< endIndex]
    }
    func replace(_ regexPattern: String, options: NSRegularExpression.Options = [], collector: @escaping () -> String) -> String {
        return replace(regexPattern, options: options) { (_: [String]) in collector() }
    }
}
