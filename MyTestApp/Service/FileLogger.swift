//
//  FileLogger.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import Foundation

protocol FileLogging {
  func log(_ strings: [String])
}

class FileLogger: FileLogging {
  private let fileName: String
  private let fileManager: FileManager
  private var fileURL: URL? {
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("Could not find the documents directory")
      return nil
    }
    return documentsDirectory.appendingPathComponent(fileName)
  }

  init(fileName: String) {
    self.fileName = fileName
    self.fileManager = FileManager.default
  }

  func log(_ strings: [String]) {
    guard let fileURL = fileURL else { return }
    if !fileManager.fileExists(atPath: fileURL.path) {
      fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
    }

    let output = OutputStream(url: fileURL, append: true)
    output?.open()

    for string in strings {
      if let data = "\(string)\n".data(using: .utf8) {
        _ = data.withUnsafeBytes { output?.write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: data.count) }
      }
    }

    output?.close()
  }
}
