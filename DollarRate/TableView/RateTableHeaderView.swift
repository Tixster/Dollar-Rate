//
//  RateTableHeaderView.swift
//  DollarRate
//
//  Created by Кирилл Тила on 24.06.2021.
//

import Foundation
import UIKit

class RateTableHeaderView: UITableViewHeaderFooterView {
    
    private var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Курс доллара на сегодня (\(FetchDate.shared.currentDate()))"
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels() {
        contentView.addSubview(todayLabel)
        contentView.addSubview(rateLabel)
        
        NSLayoutConstraint.activate([
            todayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            todayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            rateLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 10),
            rateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            rateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            

        
        ])
    }
    
    func configure(rate: String) {
        rateLabel.text = rate
    }
}
