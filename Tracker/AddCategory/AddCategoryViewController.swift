//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 10.05.2025.
//

import UIKit


final class AddCategoryViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var nameCategory: String?
    
    // MARK: - Internal properties
    
    weak var viewModel: CategoriesViewModel?
    
    lazy var nameCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Введите название категории"
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
    
    lazy var doneButton: UIButton = createDoneButton()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "Новая категория"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        view.addSubview(nameCategoryTextField)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            nameCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            nameCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        checkStateButton()
    }
    
    // MARK: - Internal functions
    
    func checkStateButton() {
        if nameCategory != nil  {
            doneButton.backgroundColor = UIColor(named: "TrackerBlack")
            doneButton.isEnabled = true
        } else {
            doneButton.backgroundColor = UIColor(named: "TrackerGray")
            doneButton.isEnabled = false
        }
    }
    
    // MARK: - Button creators
    
    func createDoneButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TrackerBlack")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }
    
    // MARK: - Button actions
    
    @objc func didTapDoneButton() {
        guard let nameCategory else {
            print("Ошибка ввода")
            return
        }
        viewModel?.addCategory(header: nameCategory)
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension AddCategoryViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text else { return }
        nameCategory = name.isEmpty ? nil : name
        checkStateButton()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let name = textField.text else { return }
        nameCategory = name.isEmpty ? nil : name
        checkStateButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Скрываем клавиатуру
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
