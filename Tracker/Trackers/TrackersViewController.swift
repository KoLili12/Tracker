//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 20.03.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let service: TrackersServiceProtocol = TrackersService()
    
    private let widthCell = UIScreen.main.bounds.width / 2  - (32 - 9)
    private let heightCell: CGFloat = 148
    
    private var currentDate = Date()
    private let calendar = Calendar.current
    
    // MARK: - Internal functions
    
    var categories: [TrackerCategory] = []
    
    // MARK: - Private view properties
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(HeaderTrackersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderTrackersView")
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchTrackers: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
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
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "TrackerWhite")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createPlusButon())
        
        view.addSubview(trackerLabel)
        view.addSubview(searchTrackers)
        view.addSubview(collectionView)
        view.addSubview(plugImageView)
        view.addSubview(plugLabel)
        
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTrackers.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor),
            searchTrackers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchTrackers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: searchTrackers.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            plugImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plugImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            plugLabel.topAnchor.constraint(equalTo: plugImageView.bottomAnchor, constant: 8),
            plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        setDate(date: currentDate)
    }
    
    // MARK: - Private create buttons functions
    
    private func createPlusButon() -> UIButton {
        
        let button = UIButton.systemButton(
            with: UIImage(named: "TrackerPlus") ?? UIImage(),
            target: self,
            action: #selector(self.didTabPlusButton)
        )
        
        button.tintColor = UIColor(named: "TrackerBlack")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 19),
            button.heightAnchor.constraint(equalToConstant: 19)
        ])
        
        return button
    }
    
    // MARK: - @objc private functions
    
    @objc private func didTabPlusButton() {
        let vc = ChooseTrackerTypeViewController()
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        setDate(date: selectedDate)
    }
    
    // MARK: - Private functions
    
    private func setDate(date: Date) {
        guard let weekday = WeekDay(rawValue: calendar.component(.weekday, from: date)) else { return }
        categories = []
        
        service.getCategories().forEach { category in
            var traсkers: [Tracker] = []
            category.trackers.forEach { tracker in
                if tracker.schedule.contains(weekday) {
                    traсkers.append(tracker)
                }
            }
            let newCategory = TrackerCategory(header: category.header, trackers: traсkers)
            categories.append(newCategory)
        }
        
        categories = categories.filter { $0.trackers.isEmpty == false }
        print(categories)
        
        if categories.isEmpty {
            collectionView.isHidden = true
            plugImageView.isHidden = false
            plugLabel.isHidden = false
        } else {
            plugImageView.isHidden = true
            plugLabel.isHidden = true
            collectionView.isHidden = false
        }
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        cell.emojiLabel.text = tracker.emoji
        cell.descriptionLabel.text = tracker.name
        cell.cardView.backgroundColor = tracker.color
        cell.markTrackerButton?.backgroundColor = tracker.color
        cell.indexPath = indexPath
        
        let isSelected = service.isTrackerCompleted(tracker: tracker, date: currentDate)
        let count = service.countTrackerCompletedTrackers(tracker: tracker)
        cell.changeMarkTrackerButton(isSelectedButton: isSelected, countDays: count)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard categories.count > 0 else { return UICollectionReusableView() }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderTrackersView", for: indexPath) as? HeaderTrackersView
        let category = categories[indexPath.section]
        view?.headerTitle.text = category.header
        
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
}

// MARK: - TrackersViewControllerDelegate

extension TrackersViewController: TrackersViewControllerDelegate {
    func updateDaysCount(cell: TrackerCollectionViewCell) {
        guard currentDate < Date() else {
            print("Нельзя отметить карточку для будущей даты")
            return
        }
        guard let indexPath = cell.indexPath else { return }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        if service.isTrackerCompleted(tracker: tracker, date: currentDate) {
            service.deleteCompletedTracker(tracker: tracker, date: currentDate)
        } else {
            service.addCompletedTracker(tracker: tracker, date: currentDate)
        }
        let isSelectedButton = service.isTrackerCompleted(tracker: tracker, date: currentDate)
        let countDays = service.countTrackerCompletedTrackers(tracker: tracker)
        cell.changeMarkTrackerButton(isSelectedButton: isSelectedButton, countDays: countDays)
    }
    
    func countDays(cell: TrackerCollectionViewCell) -> Int {
        guard let indexPath = cell.indexPath else { return 0 }
        let tracker = service.getTracker(in: indexPath.section, at: indexPath.row)
        return service.countTrackerCompletedTrackers(tracker: tracker)
    }
}

// MARK: - CreateTrackerDelegate

extension TrackersViewController: CreateTrackerDelegate {
    func createTracker(tracker: Tracker, categoryName: String) {
        service.addTrackers(tracker: tracker, for: categoryName)
        setDate(date: currentDate)
    }
}


//#Preview {
//    TrackersViewController()
//}
