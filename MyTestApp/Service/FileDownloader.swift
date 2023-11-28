//
//  FileDownloader.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import Foundation

typealias FileDownloadingResult = (Result<[String], Error>) -> Void

protocol FileDownloading {
  func downloadFile(from url: URL, withFilterPattern pattern: String,
                    onReceive: @escaping FileDownloadingResult,
                    completion: @escaping () -> Void)
}

class FileDownloader: FileDownloading {
  private let stringFilter: StringFilter
  private var currentSession: URLSession?
  private var currentTask: URLSessionDataTask?
  private var downloadTask: FileDownloadTask?

  private let delegateQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.name = "FileDownloader.queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  init(stringFilter: StringFilter) {
    self.stringFilter = stringFilter
  }

  func downloadFile(from url: URL, withFilterPattern pattern: String,
                    onReceive: @escaping FileDownloadingResult,
                    completion: @escaping () -> Void) {
    currentTask?.cancel()
    currentSession?.invalidateAndCancel()
    downloadTask?.cancel()
    downloadTask = nil

    let downloadTask = FileDownloadTask(pattern: pattern,
                                        stringFilter: stringFilter,
                                        onReceive: onReceive,
                                        completion: completion)
    let session = URLSession(configuration: .default, delegate: downloadTask, delegateQueue: delegateQueue)
    let task = session.dataTask(with: url)

    self.downloadTask = downloadTask
    currentSession = session
    currentTask = task
    
    task.resume()
  }
}

private class FileDownloadTask: NSObject, URLSessionDataDelegate {
  private let pattern: String
  private let stringFilter: StringFilter
  private var onReceive: FileDownloadingResult?
  private var completion: (() -> Void)?
  private var cancelled = false

  private var buffer = Data()

  init(pattern: String,
       stringFilter: StringFilter,
       onReceive: @escaping FileDownloadingResult,
       completion: @escaping() -> Void) {
    self.pattern = pattern
    self.stringFilter = stringFilter
    self.onReceive = onReceive
    self.completion = completion
  }

  func cancel() {
    onReceive = nil
    completion = nil
  }

  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    guard !cancelled else { return }
    buffer.append(data)

    while let range = buffer.range(of: Data([0x0A])) { // 0x0A - ASCII symbol code of new line
      let lineData = buffer.subdata(in: 0..<range.lowerBound)
      if let line = String(data: lineData, encoding: .utf8) {
        appendLines(lines: [line])
      }
      buffer.removeSubrange(0..<range.upperBound)
    }
  }

  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    defer {
      completion?()
    }
    if let error = error as NSError?, error.code == NSURLErrorCancelled {
      return // Canceled
    } else if let error = error {
      onReceive?(.failure(error))
    } else if !buffer.isEmpty {
      if let line = String(data: buffer, encoding: .utf8) {
        appendLines(lines: [line])
      }
    }
  }
  
  private func appendLines(lines: [String]) {
    let filteredLines = stringFilter.filter(strings: lines, withPattern: pattern)
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
      .filter({ !$0.isEmpty })
    if !filteredLines.isEmpty {
      onReceive?(.success(filteredLines))
    }
  }
}
