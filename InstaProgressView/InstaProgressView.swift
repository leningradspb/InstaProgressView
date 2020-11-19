//
//  InstaProgressView.swift
//  InstaProgressView
//
//  Created by Eduard Sinyakov on 11/19/20.
//

import UIKit

public class InstaProgressView: UIStackView {
    private var currentAnimationIndex = 0
    private var animator = UIViewPropertyAnimator()
    private var duration: TimeInterval!
    
    weak var delegate: InstaProgressViewDelegate?

    private var isValid: Bool {
        currentAnimationIndex < arrangedSubviews.count
    }

   public init(progressTintColor: UIColor, trackTintColor: UIColor, segmentsCount: Int, spaceBetweenSegments: CGFloat, duration: TimeInterval) {
        super.init(frame: CGRect.zero)
        self.duration = duration
        axis = NSLayoutConstraint.Axis.horizontal
        distribution = UIStackView.Distribution.fillEqually
        alignment = UIStackView.Alignment.fill
        spacing = spaceBetweenSegments

        for _ in segmentsCount {
            addArrangedSubview(createProgressView(progressTintColor, trackTintColor))
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startAnimation() {
        next()
    }

    public func pauseAnimation() {
        animator.pauseAnimation()
    }

    public func continueAnimation() {
        animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }

    public func skip() {
        if currentAnimationIndex <= arrangedSubviews.count && currentAnimationIndex > 0 {
            if let currentSegment = arrangedSubviews[currentAnimationIndex - 1] as? UIProgressView {
                animator.stopAnimation(true)
                currentSegment.setProgress(1, animated: false)
                currentSegment.layer.removeAllAnimations()
                next()
            }
        } else {
            next()
        }
    }

    public func back() {
        if currentAnimationIndex > 0 {
            currentAnimationIndex -= 1

            if let currentSegment = arrangedSubviews[currentAnimationIndex] as? UIProgressView {
                animator.stopAnimation(true)
                currentSegment.setProgress(0, animated: false)
                currentSegment.layer.removeAllAnimations()
            }
        }

        if currentAnimationIndex > 0 {
            currentAnimationIndex -= 1

            if let currentSegment = arrangedSubviews[currentAnimationIndex] as? UIProgressView {
                animator.stopAnimation(true)
                currentSegment.setProgress(0, animated: false)
                currentSegment.layer.removeAllAnimations()
            }
        }

        let catchedIndex = currentAnimationIndex
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            if catchedIndex == self.currentAnimationIndex {
                self.next()
            }
        }
    }

    /// Show progress and when load finished show next load progressView (white string)
    /// - Parameter progressView: current progressView gets from currentAnimationIndex
    private func handleProgress(_ progressView: UIProgressView) {
        let catchedIndex = currentAnimationIndex
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if catchedIndex == self.currentAnimationIndex {
                self.currentAnimationIndex += 1
                self.animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: self.duration, delay: 0, options: .curveEaseInOut) {
                    progressView.setProgress(1, animated: true)
                } completion: { [weak self] _ in
                    self?.next()
                }
                self.animator.startAnimation()
            }
        }
    }

    private func next() {
        if isValid {
            if let v = arrangedSubviews[currentAnimationIndex] as? UIProgressView {
                delegate?.instaProgressViewChangedIndex(index: currentAnimationIndex)
                handleProgress(v)
            }
        } else {
            delegate?.instaProgressViewFinished()
        }
    }

    private func createProgressView(_ progressTintColor: UIColor, _ trackTintColor: UIColor) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.progressTintColor = progressTintColor
        progressView.trackTintColor = trackTintColor
        progressView.setProgress(0, animated: true)
        return progressView
    }
}
