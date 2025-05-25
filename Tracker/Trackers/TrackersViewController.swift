//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 20.03.2025.
//

import UIKit
import YandexMobileMetrica

final class TrackersViewController: UIViewController {
    
    // MARK: - Private properties
    
    var service: TrackersServiceProtocol = TrackersService()
    
    private let widthCell = UIScreen.main.bounds.width / 2  - (32 - 9)
    private let heightCell: CGFloat = 148
    
    private var currentDate: Date = {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }()
    
    private let calendar = Calendar.current
    
    // MARK: - Internal functions
    
    var categories: [TrackerCategory] = []
    
    var isCompleted: Bool?
    
    // MARK: - Private view properties
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(HeaderTrackersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderTrackersView")

        collection.translatesAutoresizingMaskIntoConstraints = false
            
        collection.backgroundColor = .trackerWhite
        
        collection.alwaysBounceVertical = true
        
        // Вычисляем размер отступа снизу (равен высоте кнопки фильтра + отступ)
        let filterButtonHeight: CGFloat = 50
        let safeAreaBottom = view.safeAreaInsets.bottom
        let bottomInset = filterButtonHeight + 8
        
        collection.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: bottomInset,
            right: 0
        )
        
        // Обновляем отступы для индикатора прокрутки, чтобы он тоже не перекрывался кнопкой
        collection.scrollIndicatorInsets = collection.contentInset
        return collection
    }()
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackers", comment: "trackers")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchTrackers: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.addTarget(self, action: #selector(searchDidChange), for: .editingChanged)
        searchField.placeholder = NSLocalizedString("search", comment: "search")
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var plugImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "StarRingImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return imageView
        
    }()
    
    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("noTrackers", comment: "search")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(resource: .trackerBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plugSearchImageView: UIImageView = {
        let imageView = UIImageView(image: .plugSearch)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return imageView
        
    }()
    
    private lazy var plugSearchLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("plugSearchText", comment: "plugSearchText")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(resource: .trackerBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filterButton = createFilterButton()
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "TrackerWhite")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        service.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createPlusButton())
        
        plugSearchImageView.isHidden = true
        plugSearchLabel.isHidden = true
        
        view.addSubview(trackerLabel)
        view.addSubview(searchTrackers)
        view.addSubview(collectionView)
        view.addSubview(plugImageView)
        view.addSubview(plugLabel)
        view.addSubview(plugSearchImageView)
        view.addSubview(plugSearchLabel)
        collectionView.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTrackers.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 10),
            searchTrackers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTrackers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTrackers.heightAnchor.constraint(equalToConstant: 36),
            collectionView.topAnchor.constraint(equalTo: searchTrackers.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            plugImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugLabel.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            plugSearchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugSearchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugSearchLabel.topAnchor.constraint(equalTo: plugSearchImageView.bottomAnchor, constant: 8),
            plugSearchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        if FilterStorage.shared.getSelectedFilter() == "Completed" {
            isCompleted = true
        } else if FilterStorage.shared.getSelectedFilter() == "Uncompleted"{
            isCompleted = false
        }
        setDate(date: currentDate)
        collectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    // MARK: - Private create buttons functions
    
    private func createPlusButton() -> UIButton {
        
        let button = UIButton.systemButton(
            with: UIImage(named: "TrackerPlus") ?? UIImage(),
            target: self,
            action: #selector(self.didTapPlusButton)
        )
        
        button.tintColor = UIColor(named: "TrackerBlack")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 19),
            button.heightAnchor.constraint(equalToConstant: 19)
        ])
        
        return button
    }
    
    private func createFilterButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        button.setTitle(NSLocalizedString("filters", comment: "filters"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 114),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        return button
    }
    
    // MARK: - @objc private functions
    
    @objc private func didTapPlusButton() {
        let params : [AnyHashable : Any] = ["screen": "Main", "item": "add_track"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        let vc = ChooseTrackerTypeViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = calendar.startOfDay(for: sender.date)
        currentDate = selectedDate
        setDate(date: selectedDate)
        collectionView.reloadData()
    }
    
    @objc private func searchDidChange(_ searchField: UISearchTextField) {
        service.filterTrackers(
            for: currentDate,
            searchText: searchField.text ?? "",
            category: nil,
            completed: isCompleted
        )
    }
    
    @objc private func didTapFilterButton() {
        let params : [AnyHashable : Any] = ["screen": "Main", "item": "filter"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        let vc = FiltersViewController()
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
    
    // MARK: - Private functions
    
    private func setDate(date: Date) {
        currentDate = date
        service.filterTrackers(
            for: date,
            searchText: nil,
            category: nil,
            completed: isCompleted
        )
        // Если фильтр был "Трекеры на сегодня", то сбрасываем
        if FilterStorage.shared.getSelectedFilter() == TrackerFilter.today.rawValue {
            FilterStorage.shared.resetSelectedFilter()
        }
        checkStatusPlugViews()
    }
    
    private func checkStatusPlugViews() {
        let hasTrackers = service.countCategory > 0
        let hasActiveSearch = !(searchTrackers.text?.isEmpty ?? true)
        let hasActiveFilter = FilterStorage.shared.getSelectedFilter() != nil &&
        FilterStorage.shared.getSelectedFilter() != "All trackers"
        
        let shouldShowMainPlug = !hasTrackers && !hasActiveSearch && !hasActiveFilter
        
        plugImageView.isHidden = !shouldShowMainPlug
        plugLabel.isHidden = !shouldShowMainPlug
    }
    
    private func checkStatusPlugSearchViews() {
        let hasActiveSearch = !(searchTrackers.text?.isEmpty ?? true)
        let hasActiveFilter = FilterStorage.shared.getSelectedFilter() != nil &&
        FilterStorage.shared.getSelectedFilter() != "All trackers"
        let hasResults = service.countCategory > 0
        
        let shouldShowSearchPlug = (hasActiveSearch || hasActiveFilter) && !hasResults
        
        plugSearchImageView.isHidden = !shouldShowSearchPlug
        plugSearchLabel.isHidden = !shouldShowSearchPlug
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        service.countCategory
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        service.countTrackerInCategory(index: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        guard let tracker = service.findTracker(at: indexPath) else { return UICollectionViewCell() }
        
        cell.prepareForReuse()
        
        cell.delegate = self
        cell.emojiLabel.text = tracker.emoji
        cell.descriptionLabel.text = tracker.name
        cell.cardView.backgroundColor = tracker.color
        cell.markTrackerButton?.backgroundColor = tracker.color
        cell.indexPath = indexPath
        
        cell.checkPinLabel(isPinned: tracker.isPinned)
        
        let isSelected = service.isTrackerCompleted(tracker: tracker, date: currentDate)
        let count = service.countTrackerCompletedTrackers(tracker: tracker)
        
        cell.changeMarkTrackerButton(isSelectedButton: isSelected, countDays: count)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard service.countCategory > 0 else { return UICollectionReusableView() }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderTrackersView", for: indexPath) as? HeaderTrackersView
        guard let category = service.findCategory(at: indexPath.section) else { return UICollectionReusableView() }
        view?.prepareForReuse()
        if category.header == "pinned" {
            view?.headerTitle.text = "Закрепленные"
        } else {
            view?.headerTitle.text = category.header
        }
        return view ?? UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] actions in
            
            let tracker = self?.service.findTracker(at: indexPath)
            let category = self?.service.findCategory(at: indexPath.section)
            
            return UIMenu(children: [
                UIAction(title: (tracker?.isPinned ?? false) ? NSLocalizedString("unpin", comment: "unpin") : NSLocalizedString("pin", comment: "pin")) { [weak self] _ in
                    guard let tracker else { return }
                    self?.service.pinUnpinTracker(id: tracker.id)
                },
                UIAction(title: NSLocalizedString("edit", comment: "edit")) { [weak self] _ in
                    let params : [AnyHashable : Any] = ["screen": "Main", "item": "edit"]
                    YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
                        print("REPORT ERROR: %@", error.localizedDescription)
                    })
                    
                    let viewController: BaseAddTrackerViewController
                    
                    if tracker?.schedule.count == 7 {
                        let vc = AddIrregularEventViewController()
                        viewController = vc
                    } else {
                        let vc = AddHabitViewController()
                        viewController = vc
                    }
                    
                    guard let tracker else { return }
                    guard let category else { return }
                    
                    viewController.trackerID = tracker.id
                    viewController.trackerName = tracker.name
                    viewController.trackerCategory = category.header
                    viewController.trackerSchedule = tracker.schedule
                    viewController.trackerEmoji = tracker.emoji
                    viewController.trackerColor = tracker.color
                    
                    viewController.nameTrackerTextField.text = tracker.name
                    
                    // Устанавливаем режим редактирования и количество дней
                    viewController.isEditMode = true
                    viewController.daysCount = self?.service.countTrackerCompletedTrackers(tracker: tracker) ?? 0
                    
                    viewController.addTrackerButton.setTitle("Сохранить", for: .normal)
                    
                    let navigationController = UINavigationController(rootViewController: viewController)
                    self?.present(navigationController, animated: true)
                },
                UIAction(title: NSLocalizedString("delete", comment: "delete"), attributes: .destructive) { [weak self] _ in
                    let params : [AnyHashable : Any] = ["screen": "Main", "item": "delete"]
                    YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
                        print("REPORT ERROR: %@", error.localizedDescription)
                    })
                    self?.service.deleteTracker(index: indexPath)
                },
            ])
        })
    }
}

// MARK: - TrackersViewControllerDelegate

extension TrackersViewController: TrackersViewControllerDelegate {
    func updateDaysCount(cell: TrackerCollectionViewCell) {
        let params : [AnyHashable : Any] = ["screen": "Main", "item": "track"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        if Date() < currentDate {
            print("Нельзя отметить трекер на будущий день")
            return
        }
        guard let indexPath = cell.indexPath else { return }
        guard let tracker = service.findTracker(at: indexPath) else { return }
        if service.isTrackerCompleted(tracker: tracker, date: currentDate) {
            service.deleteCompletedTracker(tracker: tracker, date: currentDate)
        } else {
            service.addCompletedTracker(tracker: tracker, date: currentDate)
        }
        let isSelectedButton = service.isTrackerCompleted(tracker: tracker, date: currentDate)
        let countDays = service.countTrackerCompletedTrackers(tracker: tracker)
        cell.changeMarkTrackerButton(isSelectedButton: isSelectedButton, countDays: countDays)
    }
}

// MARK: - TrackerUpdateDelegate

extension TrackersViewController: TrackerUpdateDelegate {
    func updateFullCollection() {
        checkStatusPlugSearchViews()
        collectionView.reloadData()
    }
    
    func updateCollection(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        checkStatusPlugViews()
//        collectionView.performBatchUpdates {
//            collectionView.deleteSections(update.deletedSections)
//            collectionView.deleteItems(at: update.deletedIndexes)
//            collectionView.insertSections(update.insertedSections)
//            collectionView.insertItems(at: update.insertedIndexes)
//            
//            collectionView.reloadSections(update.updatedSections)
//            collectionView.reloadItems(at: update.updatedIndexes)
//        }
        collectionView.reloadData()
    }
}

// MARK: - FiltertsViewControllerDelegate

extension TrackersViewController: FiltersViewControllerDelegate {
    func filtersTrackersDidChange(filter: TrackerFilter?) {
        switch filter {
        case .all:
            isCompleted = nil
        case .completed:
            isCompleted = true
        case .today:
            isCompleted = nil
            currentDate = Calendar.current.startOfDay(for: Date())
            datePicker.date = currentDate
            datePicker.sendActions(for: .valueChanged)
        case .notCompleted:
            isCompleted = false
        default:
            print("filtersTrackersDidChange(filter: TrackerFilter?): Ошибка фильтра")
        }
        service.filterTrackers(for: currentDate, searchText: nil, category: nil, completed: isCompleted)
    }
}
