//
//  HomeModuleBuilder.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import Foundation

class HomeModuleBuilder {
  class func build() -> HomeViewController {
    let fileDownloader = FileDownloader(stringFilter: RegExpStringFilter())
    let viewModel = HomeViewModel(fileDownloader: fileDownloader)
    let viewController = HomeViewController(viewModel: viewModel)
    return viewController
  }
}
