//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 20.03.2025.
//

import UIKit

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
    
    // MARK: - Private view properties
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(HeaderTrackersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderTrackersView")

        collection.translatesAutoresizingMaskIntoConstraints = false
            
        collection.backgroundColor = .trackerWhite
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
        label.textColor = UIColor(resource: .trackerBlack) // .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "TrackerWhite")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        service.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createPlusButton())
        
        view.addSubview(trackerLabel)
        view.addSubview(searchTrackers)
        view.addSubview(collectionView)
        view.addSubview(plugImageView)
        view.addSubview(plugLabel)
        
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
            plugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
            completed: nil
        )
    }
    
    // MARK: - Private functions
    
    private func setDate(date: Date) {
        currentDate = date
        
        // вызываем фильтрацию в хранилище
        // service.filterTrackers(for: date)
        service.filterTrackers(
            for: date,
            searchText: nil,
            category: nil,
            completed: nil
        )
        checkStatusPlugViews()
    }
    
    private func checkStatusPlugViews() {
        let hasTrackers = service.countCategory > 0
        collectionView.isHidden = !hasTrackers
        plugImageView.isHidden = hasTrackers
        plugLabel.isHidden = hasTrackers
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
        collectionView.reloadData()
    }
    
    func updateCollection(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        checkStatusPlugViews()
        collectionView.performBatchUpdates {
            collectionView.deleteSections(update.deletedSections)
            collectionView.deleteItems(at: update.deletedIndexes)
            collectionView.insertSections(update.insertedSections)
            collectionView.insertItems(at: update.insertedIndexes)
            
            collectionView.reloadSections(update.updatedSections)
            collectionView.reloadItems(at: update.updatedIndexes)
        }
    }
}
