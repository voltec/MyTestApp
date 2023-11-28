//
//  StringFilter.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import Foundation

protocol StringFilter {
  func filter(strings: [String], withPattern pattern: String) -> [String]
}

class DynamicStringFilter: StringFilter {
  func filter(strings: [String], withPattern pattern: String) -> [String] {
    return strings.filter { string in
      matchDynamicProgramming(string, pattern)
    }
  }

  private func matchDynamicProgramming(_ string: String, _ pattern: String) -> Bool {
    var dp = Array(repeating: Array(repeating: false, count: pattern.count + 1), count: string.count + 1)
    dp[0][0] = true

    let patternArray = Array(pattern)
    for j in 1...pattern.count {
      if patternArray[j - 1] == "*" {
        dp[0][j] = dp[0][j - 1]
      }
    }

    let stringArray = Array(string)
    for i in 1...string.count {
      for j in 1...pattern.count {
        if patternArray[j - 1] == "*" {
          dp[i][j] = dp[i - 1][j] || dp[i][j - 1]
        } else if patternArray[j - 1] == "?" || stringArray[i - 1] == patternArray[j - 1] {
          dp[i][j] = dp[i - 1][j - 1]
        }
      }
    }

    return dp[string.count][pattern.count]
  }
}

class RegExpStringFilter: StringFilter {
  func filter(strings: [String], withPattern pattern: String) -> [String] {
    return strings.filter { string in
      matchRegExp(string, pattern)
    }
  }
  private func matchRegExp(_ string: String, _ pattern: String) -> Bool {
      let pattern = "^" + pattern.replacingOccurrences(of: "*", with: ".*")
                                   .replacingOccurrences(of: "?", with: ".") + "$"
      return string.range(of: pattern, options: .regularExpression) != nil
  }
}
