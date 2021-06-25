//
//  RateViewController.swift
//  DollarRate
//
//  Created by Кирилл Тила on 24.06.2021.
//

import UIKit

class RateViewController: UIViewController {
    
    private var rateItems: [Rate]?
    private var sortedItem: [Rate]?
    private var dataStack: CoreDataStack
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.register(RateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: RateTableHeaderView.self))
        table.refreshControl = refreshControl
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(stack: CoreDataStack) {
        self.dataStack = stack
        super.init(nibName: nil, bundle: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.dataStack.delegate = self
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func fetchData() {
        let rateParser = Parser()
        rateParser.parseRate { items in
            self.rateItems = items
            self.sortedArray()
            if let rate = self.rateItems?.last {
                self.dataStack.setRate(content: rate)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    
    private func sortedArray(){
        guard let convert = rateItems else { return }
        var sortedRate = Array(convert.reversed())
        sortedRate.removeFirst()
        sortedItem = sortedRate
    }
    
    @objc private func refreshData() {
        fetchData()
        refreshControl.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension RateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedItem?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let sortedItem = sortedItem {
            let date = sortedItem[indexPath.row].date
            let value = sortedItem[indexPath.row].value
            cell.textLabel?.text = "Курс: $1 = \(value)₽ на \(date)"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: RateTableHeaderView.self)) as! RateTableHeaderView
        if let currentRate = rateItems?.last {
            header.configure(rate: currentRate.value)
        }
        
        switch section {
        case 0:
            return header
        default:
            return nil
        }
        
        
    }
}

extension RateViewController: RateViewControllerDelegate {

    func updateValueAlert(oldValue: String,newValue: String) {
        let alert = UIAlertController(title: "Курс вырос", message: "Новый курс доллара: \(newValue)₽. Было:\(oldValue)₽", preferredStyle: .alert)
        let action = UIAlertAction(title: "Понятно", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
