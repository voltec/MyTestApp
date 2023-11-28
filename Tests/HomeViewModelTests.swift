//
//  HomeViewModelTests.swift
//  MyTestApp TestTests
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import XCTest
@testable import MyTestApp

class HomeViewModelTests: XCTestCase {
  var viewModel: HomeViewModel!
  var mockFileDownloader: MockFileDownloader!

  override func setUp() {
    mockFileDownloader = MockFileDownloader()
    viewModel = HomeViewModel(fileDownloader: mockFileDownloader)
  }

  override func tearDown() {
    viewModel = nil
    mockFileDownloader = nil
  }

  func testInitialState() {
    XCTAssertEqual(viewModel.numberOfLines, 0)
    XCTAssertNil(viewModel.line(at: 0))
  }

  func testDownloadDataSuccess() {
    let expectation = XCTestExpectation(description: "Download data")
    let expected = ["Test1", "Test2"]
    mockFileDownloader.resultToReturn = .success(expected)

    viewModel.downloadClick(with: "TestURL", with: "TestPattern")
    viewModel.showLoading = { value in
      if !value {
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(viewModel.numberOfLines, expected.count)
    XCTAssertEqual(viewModel.line(at: 0), expected[0])
    XCTAssertEqual(viewModel.line(at: 1), expected[1])
  }

  func testDownloadDataFailure() {
    let expectation = XCTestExpectation(description: "Download data")
    mockFileDownloader.resultToReturn = .failure(MockError.testError)

    viewModel.downloadClick(with: "TestURL", with: "TestPattern")
    viewModel.showError = { error in
      if !error.isEmpty {
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 1.0)
  }

  class MockFileDownloader: FileDownloading {
    var resultToReturn: Result<[String], Error>!
    func downloadFile(from url: URL, withFilterPattern pattern: String, onReceive: @escaping FileDownloadingResult, completion: @escaping () -> Void) {
      switch resultToReturn {
      case .success(let strings):
        onReceive(.success(strings))
        completion()
      case .failure(let error):
        onReceive(.failure(error))
        completion()
      case .none:
        break
      }
    }
  }

  enum MockError: Error {
    case testError
  }
}
