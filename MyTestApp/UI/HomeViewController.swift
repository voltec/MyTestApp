//
//  ViewController.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import UIKit

final class HomeViewController: UIViewController {
  var viewModel: HomeViewModel

  private let urlTextField = UITextField()
  private let filterTextField = UITextField()
  private let downloadButton = UIButton(type: .system)
  private let loadingView = UIActivityIndicatorView()
  private let resultTableView = UITableView()

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupSubviews()
    prefillSampleData()
    bindViewModel()
  }

  private func prefillSampleData() {
    urlTextField.text = "https://raw.githubusercontent.com/dscape/spell/master/test/resources/big.txt"
    filterTextField.text = "\"Oh, dear! *"
  }

  private func bindViewModel() {
    viewModel.updateUI = { [unowned self] in
      resultTableView.reloadData()
    }

    viewModel.showError = { [unowned self] message in
      showError(message: message)
    }

    viewModel.showLoading = { [unowned self] isLoading in
      if isLoading {
        loadingView.startAnimating()
      } else {
        loadingView.stopAnimating()
      }
    }
  }
}

extension HomeViewController {
  func showError(message: String) {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alertController.addAction(okAction)
    present(alertController, animated: true)
  }

  func reloadData() {
    resultTableView.reloadData()
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfLines
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.cellReuseIdentifier, for: indexPath)
    if let cell = cell as? HomeTableViewCell,
       let item = viewModel.line(at: indexPath.row) {
      cell.configure(with: item)
    }
    return cell
  }
}

// Layouts
private extension HomeViewController {
  func setupSubviews() {
    setupUrlTextField()
    setupFilterTextField()
    setupDownloadButton()
    setupLoadingView()
    setupResultTableView()
  }

  func setupUrlTextField() {
    view.addSubview(urlTextField)
    urlTextField.translatesAutoresizingMaskIntoConstraints = false
    urlTextField.placeholder = "Enter URL"
    urlTextField.borderStyle = .roundedRect

    NSLayoutConstraint.activate([
      urlTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }

  func setupFilterTextField() {
    view.addSubview(filterTextField)
    filterTextField.translatesAutoresizingMaskIntoConstraints = false
    filterTextField.placeholder = "Enter filter"
    filterTextField.borderStyle = .roundedRect

    NSLayoutConstraint.activate([
      filterTextField.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 20),
      filterTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      filterTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }

  func setupDownloadButton() {
    view.addSubview(downloadButton)
    downloadButton.translatesAutoresizingMaskIntoConstraints = false
    downloadButton.setTitle("Download", for: .normal)
    downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)

    NSLayoutConstraint.activate([
      downloadButton.topAnchor.constraint(equalTo: filterTextField.bottomAnchor, constant: 20),
      downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  func setupLoadingView() {
    view.addSubview(loadingView)
    loadingView.hidesWhenStopped = true
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 13.0, *) {
      loadingView.style = .medium
      loadingView.tintColor = .gray
    } else {
      loadingView.style = .gray
    }
    NSLayoutConstraint.activate([
      loadingView.centerYAnchor.constraint(equalTo: downloadButton.centerYAnchor),
      loadingView.leadingAnchor.constraint(equalTo: downloadButton.trailingAnchor, constant: 20)
    ])
  }

  @objc func downloadButtonTapped() {
    guard let urlText = urlTextField.text, let filterText = filterTextField.text else {
      showError(message: "Empty fields")
      return
    }
    viewModel.downloadClick(with: urlText, with: filterText)
  }

  func setupResultTableView() {
    resultTableView.dataSource = self
    resultTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.cellReuseIdentifier)
    view.addSubview(resultTableView)
    resultTableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      resultTableView.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 20),
      resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
