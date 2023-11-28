//
//  MyTestApp_TestTests.swift
//  MyTestApp TestTests
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import XCTest
@testable import MyTestApp

final class StringFilterTests: XCTestCase {
  var stringFilter: StringFilter!

  override func setUp() {
    super.setUp()
    stringFilter = RegExpStringFilter()
  }

  override func tearDown() {
    stringFilter = nil
    super.tearDown()
  }

  func testFilter1() {
    let mask = "*abc*"
    let testCases = [
      "abc",
      "xabcx",
      "abcx",
      "xabc",
      "bca"
      ]
    let expected = [
      "abc",
      "xabcx",
      "abcx",
      "xabc"
      ]
    let result = stringFilter.filter(strings: testCases, withPattern: mask)
    XCTAssertEqual(result, expected)
  }

  func testFilter2() {
    let mask = "abc*"
    let testCases = [
      "abc",
      "abcdscndskjncjskdnc",
      "abcdsdsdssdd",
      "asxasxaabc"
      ]
    let expected = [
      "abc",
      "abcdscndskjncjskdnc",
      "abcdsdsdssdd"
      ]
    let result = stringFilter.filter(strings: testCases, withPattern: mask)
    XCTAssertEqual(result, expected)
  }

  func testFilter3() {
    let mask = "*abc"
    let testCases = [
      "abc",
      "abcdscndskjncjskdnc",
      "asdasdaabc",
      "asxasxaabc"
      ]
    let expected = [
      "abc",
      "asdasdaabc",
      "asxasxaabc"
      ]
    let result = stringFilter.filter(strings: testCases, withPattern: mask)
    XCTAssertEqual(result, expected)
  }

  func testFilter4() {
    let mask = "abc?"
    let testCases = [
      "abc",
      "abc1",
      "abc123",
      "123abc"
      ]
    let expected = [
      "abc1"
      ]
    let result = stringFilter.filter(strings: testCases, withPattern: mask)
    XCTAssertEqual(result, expected)
  }

  func testFilter5() {
    let mask = "?abc"
    let testCases = [
      "1abc",
      "12abc",
      "12abc1"
      ]
    let expected = [
      "1abc"
      ]
    let result = stringFilter.filter(strings: testCases, withPattern: mask)
    XCTAssertEqual(result, expected)
  }

  func testFilter6() {
    let mask = "abc"
    let testCases = [
      "abc",
      "12abc",
      "abc",
      "abc222",
      "111 abc 222"
      ]
    let expected = [
      "abc",
      "abc"
      ]
    let result = stringFilter.filter(strings: testCases, withPattern: mask)
    XCTAssertEqual(result, expected)
  }

  func testFilter7() {
      let mask = "*a?b*c*d?e*"
      let testCases = [
          "a*bcccd*e",
          "aebcdfa",
          "a?bcccdeee",
          "abcccde",
          "axbcccdde",
          "axbccccde",
          "axbccccdfe"
      ]
      let expected = [
          "a*bcccd*e",
          "a?bcccdeee",
          "axbcccdde",
          "axbccccdfe"
      ]
      let result = stringFilter.filter(strings: testCases, withPattern: mask)
      XCTAssertEqual(result, expected)
  }
}
