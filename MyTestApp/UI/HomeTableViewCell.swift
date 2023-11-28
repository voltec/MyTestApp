//
//  HomeTableViewCell.swift
//  MyTestApp Test
//
//  Created by Mikhail Mukminov on 02.11.2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  class var cellReuseIdentifier: String {
    "HomeTableViewCell"
  }

  private let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with text: String) {
    label.text = text
  }
}
