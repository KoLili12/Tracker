//
//  BaseAddTrackerViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 15.04.2025.
//

import UIKit

class BaseAddTrackerViewController: UIViewController {
    
    // MARK: - Protected properties
    
    weak var delegate: CreateTrackerDelegate?
    
    var trackerName: String?
    var trackerCategory: String? = "Важное"
    var trackerSchedule: Set<WeekDay> = []
    var trackerEmoji: String? = "🎸"
    var trackerColor: UIColor? = .red
    
    let maxTrackerNameLength: Int = 38
    
    // MARK: - UI properties
    
    private lazy var nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.layer.cornerRadius = 16
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.textColor = UIColor(named: "TrackerBlack")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "TrackerWhite")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var addTrackerButton = createAddTrackerButton()
    
    private lazy var cancelButton = createCancelButton()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "TrackerWhite")
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup methods
    
    private func setupNavigationBar() {
        navigationItem.title = getNavigationTitle()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
    
    private func setupViews() {
        view.addSubview(nameTrackerTextField)
        view.addSubview(tableView)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(addTrackerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTrackerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -8),
            
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Button creators
    
    private func createAddTrackerButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "TrackerWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "TrackerGray")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalToConstant: 161)
        ])
        button.isEnabled = false
        return button
    }
    
    private func createCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "RedForCancelButton"), for: .normal)
        button.layer.borderColor = UIColor(named: "RedForCancelButton")?.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalToConstant: 161)
        ])
        
        return button
    }
    
    // MARK: - Button actions
    
    @objc func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        let tracker = Tracker(
            name: trackerName ?? "",
            color: trackerColor ?? UIColor(),
            emoji: trackerEmoji ?? "",
            schedule: trackerSchedule
        )
        delegate?.createTracker(tracker: tracker, categoryName: trackerCategory ?? "")
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper methods
    
    func checkStateButton() {
        if trackerName != nil && trackerCategory != nil && trackerSchedule.count > 0 && trackerEmoji != nil && trackerColor != nil {
            addTrackerButton.backgroundColor = UIColor(named: "TrackerBlack")
            addTrackerButton.isEnabled = true
        } else {
            addTrackerButton.backgroundColor = UIColor(named: "TrackerGray")
            addTrackerButton.isEnabled = false
        }
    }
    
    // MARK: - Methods to override in subclasses
    
    func getNavigationTitle() -> String {
        return "Новый трекер"
    }
    
    func getTableData() -> [String] {
        return ["Категория"]
    }
    
    // Override in subclasses to configure cell details
    func configureCellDetails(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.detailTextLabel?.text = "Важное"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = UIColor(named: "TrackerGray")
    }
}

// MARK: - UITextFieldDelegate

extension BaseAddTrackerViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text else { return }
        trackerName = name.isEmpty ? nil : name
        checkStateButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxTrackerNameLength
    }
}

// MARK: - UITableViewDelegate

extension BaseAddTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // To be implemented in subclasses
    }
}

// MARK: - UITableViewDataSource

extension BaseAddTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getTableData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        let tableData = getTableData()
        if indexPath.row < tableData.count {
            cell.textLabel?.text = tableData[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            
            configureCellDetails(cell, at: indexPath)
        }
        
        return cell
    }
}
