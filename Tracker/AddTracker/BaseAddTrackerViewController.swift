//
//  BaseAddTrackerViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 15.04.2025.
//

import UIKit

class BaseAddTrackerViewController: UIViewController {
    
    // MARK: - Protected properties
    
    let store = TrackerStore()
    
    let allEmojis = [
        "😊", // улыбающееся лицо
        "😻", // кот с сердечками в глазах
        "🌺", // цветок гибискуса
        "🐶", // собака
        "❤️", // красное сердце
        "😱", // испуганное лицо
        "😇", // улыбающееся лицо с нимбом
        "😠", // злое лицо
        "😬", // гримасничающее лицо/широкая улыбка
        "🤔", // задумчивое лицо
        "🙌", // поднятые руки
        "🍔", // гамбургер
        "🥦", // брокколи
        "🏓", // настольный теннис/пинг-понг
        "🥇", // золотая медаль
        "🎸", // электрогитара
        "🏝️", // остров с пальмой
        "😪"  // сонное лицо
    ]
    
    let allColors: [UIColor] = [
        UIColor(resource: ColorResource(name: "TrackerRed", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerOrange", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerLightBlue", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerPurple", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerGreen", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerPinkPurple", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerLightPink", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerSkyBlue", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerMintGreen", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerNavyBlue", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerSalmon", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerPink", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerSand", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerLavender", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerViolet", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerPlum", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerLilac", bundle: .main)),
        UIColor(resource: ColorResource(name: "TrackerLightGreen", bundle: .main)),
        ]
    
    var trackerName: String?
    var trackerCategory: String? {
        didSet {
            checkStateButton()
            tableView.reloadData()
        }
    }
    var trackerSchedule: Set<WeekDay> = []
    var trackerEmoji: String?
    var trackerColor: UIColor?
    
    let maxTrackerNameLength: Int = 38
    
    // MARK: - UI properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "TrackerWhite")
        scrollView.showsVerticalScrollIndicator = true // Показывать индикатор прокрутки
        scrollView.alwaysBounceVertical = true // Дать возможность "отпружинивать" при прокрутке
        scrollView.contentInsetAdjustmentBehavior = .always // Автоматически настраивать отступы
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = NSLocalizedString("enterTrackerName", comment: "enterTrackerName")
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
    
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Емоji"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor(named: "TrackerBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("color", comment: "color")
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIColor(named: "TrackerBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emojiCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCollectionViewCell")
        collection.backgroundColor = UIColor(named: "TrackerWhite")
        collection.allowsMultipleSelection = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var colorCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: "TrackerWhite")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor(named: "TrackerWhite")
        collection.allowsMultipleSelection = false
        return collection
    }()
    
    lazy var tableView: UITableView = {
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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var addTrackerButton = createAddTrackerButton()
    
    lazy var cancelButton = createCancelButton()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "TrackerWhite")
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup methods
    
    func setupNavigationBar() {
        navigationItem.title = getNavigationTitle()
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(nameTrackerTextField)
        scrollView.addSubview(tableView)
        scrollView.addSubview(emojiLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorLabel)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(addTrackerButton)
    }
    
    func setupConstraints() {
        let tableViewHeight = CGFloat(getTableData().count * 75) + 32
        
        NSLayoutConstraint.activate([
            // Ограничения для scrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Ограничения для nameTrackerTextField
            nameTrackerTextField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            
            // Ограничения для tableView
            tableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight),
            
            // Ограничения для emojiLabel
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 28),
            
            // Ограничения для emojiCollectionView
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -18),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156),
            
            // Ограничения для colorLabel
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
            colorLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 28),
            
            // Ограничения для colorCollectionView
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -18),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 156), 
            
            // Ограничения для stackView
            stackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    // MARK: - Button creators
    
    func createAddTrackerButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("create", comment: "create"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "TrackerWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "TrackerGray")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.isEnabled = false
        return button
    }
    
    func createCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("cancel", comment: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "RedForCancelButton"), for: .normal)
        button.layer.borderColor = UIColor(named: "RedForCancelButton")?.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
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
        guard let trackerCategory else { return }
        store.addTrackers(tracker: tracker, for: trackerCategory)
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let name = textField.text else { return }
        trackerName = name.isEmpty ? nil : name
        checkStateButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Скрываем клавиатуру
        return true
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

// MARK: - UICollectionViewDelegateFlowLayout

extension BaseAddTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.selectionView.backgroundColor = UIColor(named: "TrackerLightGray")
            trackerEmoji = cell?.emojiLabel.text ?? ""
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.selectionView.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            trackerColor = allColors[indexPath.row]
        }
        checkStateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
            cell?.selectionView.backgroundColor = UIColor(named: "TrackerWhite")
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
            cell?.selectionView.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0).cgColor
        }
    }
}

extension BaseAddTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == emojiCollectionView ? allEmojis.count  : allColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath) as? EmojiCollectionViewCell
            cell?.emojiLabel.text = allEmojis[indexPath.row]
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell
            cell?.colorView.backgroundColor = allColors[indexPath.row]
            cell?.selectionView.layer.borderColor = allColors[indexPath.row].cgColor
            cell?.selectionView.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0).cgColor
            return cell ?? UICollectionViewCell()
        }
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
