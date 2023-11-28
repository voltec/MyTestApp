//
//  HomeViewModel.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import Foundation

class HomeViewModel {
  // Main thread output
  var updateUI: (() -> Void)?
  var showError: ((String) -> Void)?
  var showLoading: ((Bool) -> Void)?

  var numberOfLines: Int {
    return lines.count
  }

  func line(at index: Int) -> String? {
    guard index < lines.count else { return nil }
    return lines[index]
  }

  private let fileDownloader: FileDownloading
  private let logger: FileLogging
  private var lines: [String] = []

  init(fileDownloader: FileDownloading, logger: FileLogging = FileLogger(fileName: "results.log")) {
    self.fileDownloader = fileDownloader
    self.logger = logger
  }

  func downloadClick(with urlString: String, with pattern: String) {
    guard let url = URL(string: urlString) else {
      showError?("Incorrect URL")
      return
    }
    showLoading(isLoading: true)
    lines.removeAll()
    updateUI?()
    fileDownloader
      .downloadFile(from: url, withFilterPattern: pattern) { [weak self] result in
        guard let self else { return }
        switch result {
        case let .success(strings):
          self.append(strings: strings)
        case let .failure(error):
          self.showError(error: error)
        }
      } completion: { [weak self] in
        guard let self else { return }
        showLoading(isLoading: false)
      }
  }

  private func showLoading(isLoading: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      showLoading?(isLoading)
    }
  }

  private func showError(error: Error) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      showError?(error.localizedDescription)
    }
  }

  private func append(strings: [String]) {
    logger.log(strings)
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      lines.append(contentsOf: strings)
      updateUI?()
    }
  }
}
