# InstaProgressView
It's awesome and useful control looks like Snapchat, Instagram or other apps that have progress views (loading white strips).

Down below you can read details about implementation and see screenshot of example project🧐

![Image of animation](https://scontent.fhel3-1.fna.fbcdn.net/v/t1.0-9/126138214_3612263292163676_4787320952628979909_o.jpg?_nc_cat=109&ccb=2&_nc_sid=730e14&_nc_ohc=wiAmBuKIzq8AX_dgrv5&_nc_ht=scontent.fhel3-1.fna&oh=4ad2ad2a196d57d8130b185736f71915&oe=5FDA0F5B)


## How to use this cool boy? Pretty simple! 🥳
First of all add new pod in your podfile. Dont't forget do pod install or pod update 😏
```swift
pod 'InstaProgressView'
```

And then just import framework in controller.
```swift
import InstaProgressView
```
Unfortunately is't not end. You should add some code 🤓

In your ViewController just initialize InstaProgressView. You need something like that.

```swift
let progressView = InstaProgressView(progressTintColor: .white, trackTintColor: UIColor.white.withAlphaComponent(0.5), segmentsCount: 5, spaceBetweenSegments: 8, duration: 10)
```
progressTintColor - top color, trackTintColor - bottom color of progress view, segmentsCount - it's segmentsCount 😄, spaceBetweenSegments - it's spaceBetweenSegments 😄, and duration - it's time 
for loading one progress view in control.

When progress view will be added on view just call

```swift
progressView.startAnimation()
```
Really often you need pause animation when user hold finger on screen and continue animation when finger put off.
```swift
progressView.pauseAnimation()
progressView.continueAnimation()
```
By the way you can need show next info (for example image or video like in Instagram) on screen by left swipe or previous for right swipe. 
```swift
progressView.skip()
progressView.back()
```
Of course don't forget about delegate to handle next, skip, back or end of all loadings.
```swift
progressView.delegate = self
```
You can use extension for required delegate methods.
```swift
extension ViewController: InstaProgressViewDelegate {
    func instaProgressViewChangedIndex(index: Int) {
        // here you can show new image or video in controller
        // something like that
        //imageView.image = UIImage(named: imageNames[index])
    }

    func instaProgressViewFinished() {
        print("Finished")
        // Here you can hadle end loading of last element in control
    }
}
```
That's all! Enjoy useful control.

## If you still nothing understand this example special for you 🤪
```swift
//
//  ViewController.swift
//  Created by Eduard Sinyakov on 11/19/20.
//

import UIKit
import InstaProgressView

class ViewController: UIViewController {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    // image can gets from back-end or dont forget add images in Assets.xcassets
    // and just add image names in array
    let imageNames = ["0", "1", "2", "3", "4"]

    let progressView = InstaProgressView(progressTintColor: .white, trackTintColor: UIColor.white.withAlphaComponent(0.5), segmentsCount: 5, spaceBetweenSegments: 8, duration: 10)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesturesRecognizers()
        setupImageView()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressViewSetup()
    }

    private func setupImageView() {
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func progressViewSetup() {
        view.backgroundColor = .black
        imageView.addSubview(progressView)
        progressView.delegate = self
        progressView.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        progressView.leadingAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        progressView.trailingAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        progressView.translatesAutoresizingMaskIntoConstraints = false

        progressView.startAnimation()

    }

    private func setupGesturesRecognizers() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        view.addGestureRecognizer(longPressRecognizer)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            progressView.back()
        } else if gesture.direction == .left {
            progressView.skip()
        }
    }

    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("pause")
            progressView.pauseAnimation()
        }

        if sender.state == .ended {
            print("continueLoading")
            progressView.continueAnimation()
        }
    }
}

extension ViewController: InstaProgressViewDelegate {
    func instaProgressViewChangedIndex(index: Int) {
        imageView.image = UIImage(named: imageNames[index])
    }

    func instaProgressViewFinished() {
        print("Finished")
    }
}
```
