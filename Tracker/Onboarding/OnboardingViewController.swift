//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Николай Жирнов on 09.05.2025.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        let firstPage = PageViewController()
        firstPage.imageView.image = UIImage(resource: .blueImageOnboarding)
        firstPage.label.text = "Отслеживайте только то, что хотите"
        
        let secondPage = PageViewController()
        secondPage.imageView.image = UIImage(resource: .redImageOnboarding)
        secondPage.label.text = "Даже если это не литры воды и йога"
        
        return [firstPage, secondPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = UIColor(resource: .trackerBlack)
        pageControl.pageIndicatorTintColor = UIColor(resource: .trackerGray)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var transitionButton = createTransitionButton()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pages.first {
            setViewControllers( [first], direction: .forward, animated: true, completion: nil)
        }
        
        dataSource = self
        delegate = self
        
        view.addSubview(transitionButton)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            transitionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            transitionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transitionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: transitionButton.topAnchor, constant: -24)
        ])
    }
    
    private func createTransitionButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TrackerBlack")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTaptransitionButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        return button
    }
    
    @objc private func didTaptransitionButton() {
        OnboardingManager.shared.setOnboardingShown()
        let vc = TabBarViewController()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = vc
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //возвращаем предыдущий (относительно переданного viewController) дочерний контроллер
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //возвращаем следующий (относительно переданного viewController) дочерний контроллер
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages[0]
        }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
