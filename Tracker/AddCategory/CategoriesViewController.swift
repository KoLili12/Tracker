//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 10.05.2025.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    var viewModel: CategoriesViewModel?
    
    private lazy var addCategoryButton = createAddCategoryButton()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = UIColor(named: "TrackerWhite")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var plugImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starRing))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return imageView
        
    }()
    
    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("categoriesHint", comment: "Habits and events can be grouped by meaning")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("category", comment: "Category")
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        view.backgroundColor = .trackerWhite
        
        
        view.addSubview(addCategoryButton)
        view.addSubview(tableView)
        view.addSubview(plugImageView)
        view.addSubview(plugLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -10),
            
            plugImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugLabel.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        checkStatus()
        
        viewModel?.allCategoriesBinding = { [weak self] _ in
            guard let self = self else { return }
            checkStatus()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Internal functions
    
    private func checkStatus() {
        let flag = viewModel?.fetchAllCategories().count == 0
        tableView.isHidden = flag
        plugImageView.isHidden = !flag
        plugLabel.isHidden = !flag
    }
    
    // MARK: - Button creators
    
    private func createAddCategoryButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("addCategory", comment: "Add category"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TrackerBlack")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }
    
    // MARK: - Button actions
    
    @objc private func didTapAddCategoryButton() {
        let vc = AddCategoryViewController()
        vc.viewModel = viewModel
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.fetchAllCategories().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        cell.selectionStyle = .none
        
        let header = viewModel?.fetchAllCategories()[indexPath.row].header
        if header == viewModel?.delegate?.trackerCategory {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = header
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        viewModel?.delegate?.trackerCategory = viewModel?.fetchAllCategories()[indexPath.row].header
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}


