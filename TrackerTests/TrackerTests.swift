//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Николай Жирнов on 24.05.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testTrackersViewControllerSnapshot() {
        let vc = TrackersViewController()
        let nc = UINavigationController(rootViewController: vc)
        assertSnapshot(of: nc, as: .image)
    }
}
