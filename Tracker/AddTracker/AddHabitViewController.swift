//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 09.04.2025.
//

import UIKit

class AddHabitViewController: UIViewController {
    
    let tableViewCategory: [String] = ["Категория", "Расписание"]
    
    weak var delegate: CreateTrackerDelegate?
    
    var trackerName: String?
    var trackerCategory: String? = "Важное"
    var trackerSchedule: Set<WeekDay> = []
    var trackerEmoji: String? = "🎸"
    var trackerColor: UIColor? = .red
    
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
        textField.rightView = paddingView
        textField.rightViewMode = .always
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
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "TrackerWhite")

        navigationItem.title = "Новая привычка"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        view.addSubview(nameTrackerTextField)
        view.addSubview(tableView)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(addTrackerButton)
        
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
    
    @objc private func cancelButtonTapped() {
        print("Добавить привычку")
    }
    
    @objc private func addButtonTapped() {
        print("Добавить привычку")
        let tracker = Tracker(
            name: trackerName ?? "",
            color: trackerColor ?? UIColor(), emoji: trackerEmoji ?? "", schedule: trackerSchedule)
        delegate?.createTracker(tracker: tracker, categoryName: trackerCategory ?? "")
        print(trackerSchedule)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func createShScheduleText() -> String {
        var resultText = ""
        
        if trackerSchedule.count == 7 {
            resultText = "Каждый день"
            return resultText
        }
        var flagSunday = false // включенно ли воскресенье?
        
        trackerSchedule.sorted { $0.rawValue < $1.rawValue }.forEach { (element) in
            switch element {
            case .monday:
                resultText += "Пн, "
            case .tuesday:
                resultText += "Вт, "
            case .wednesday:
                resultText += "Ср, "
            case .thursday:
                resultText += "Чт, "
            case .friday:
                resultText += "Пт, "
            case .saturday:
                resultText += "Сб, "
            case .sunday:
                flagSunday = true
            }
        }
        if flagSunday {
            resultText += "Вс, "
        }
        if !resultText.isEmpty {
            resultText.removeLast(2)
        }
        return resultText
    }
    
    private func checkStateButton() {
        if trackerName != nil && trackerCategory != nil && trackerSchedule.count > 0 && trackerEmoji != nil && trackerColor != nil {
            addTrackerButton.backgroundColor = UIColor(named: "TrackerBlack")
            addTrackerButton.isEnabled = true
        } else {
            addTrackerButton.backgroundColor = UIColor(named: "TrackerGray")
            addTrackerButton.isEnabled = false
        }
    }
}

extension AddHabitViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Редактирование завершено, текст: \(textField.text ?? "")")
        guard let name = textField.text else { return }
        trackerName = name
        if trackerName == "" {
            trackerName = nil
        }
        checkStateButton()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 38
    }
}

extension AddHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75 // Высота ячейки
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 != 0 {
            let vc = ScheduleViewController(schedule: trackerSchedule)
            vc.delegate = self
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: true)
        } else {
            print()
        }
    }
}

extension AddHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = tableViewCategory[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = "Важное"
        } else {
            cell.detailTextLabel?.text = createShScheduleText()
        }
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = UIColor(named: "TrackerGray")
        return cell
    }
}


extension AddHabitViewController: AddHabitViewControllerDelegate {
    func reloadData(newSchedule: Set<WeekDay>) {
        trackerSchedule = newSchedule
        checkStateButton()
        tableView.reloadData()
        print(trackerSchedule)
    }
}
