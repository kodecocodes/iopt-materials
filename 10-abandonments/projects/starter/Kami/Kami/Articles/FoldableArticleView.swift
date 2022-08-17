/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import WebKit

/*
 
 On this view, there are a couple things going on.
 
 1) There's a fixed menu bar that has the Friend Requests, Messenger, and Notifications buttons.
 2) There's a big background image view that has the Title and Subtitle for that section on it
    2a) This is a big page view controller and the bottom collection view animates with it.
    2b) There's a fixed Page Indicator showing which section you're on currently.
 3) There's a collection view at the bottom with the stories for this section.
 
 Big UI Ideas:
 1) Shimmering loading titles
 2) Fades between story headlines
 3) Bouncy UI elements
 4) Foldable articles
 
 Data models:
 
 Section {
    Title: String
    Stories: [Story]
 }
 
 Story {
    Source: String
    Headline: String
    HeaderImage: UIImage
    ContentLinkURL: NSURL
 }
 
  *** Idea for the shadow ***
 
 I think what I need to do, is track the angle of the rotation of the view at each frame.
 The size of the shadow is a bell curve where on both ends, its basically a flat line, and in the middle its a
 
 TODO: This currently uses a web view, but I'm pretty sure they design their own article views so they can format things the way they want to this way, my trick will actually work better because the regular web view and the full size version will always line up perfectly instead of the ads possibly being inconsistent.
 
 */

protocol FoldableArticleViewDelegate {
    func foldableArticleDidOpen()
    func willBeginAnimatingArticleDidOpen()
    func startedAnimating()
    func stoppedAnimating()
}

// TODO: Start this view at its full size and then scale it down. That way we can easily animate to the final state.

class FoldableArticleView: UIView, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, CAAnimationDelegate {
    let transformView = UITransformView()
    
    let shadowView = UIView()

    let fullWebViewClippingView = UIView()
    //    let fullWebView = WKWebView()
    let fullWebView = UIView() // WKWebView()

//    let webView = WKWebView()
    let webView = UIView() //WKWebView()

    let imageContainerView = UIView()
    let sheenOfLight = UIView()
    let imageView = UIImageView(image: UIImage(named: "fakeArticle"))
    
    let imageViewStartingTransformXRotation = 0.0
    let imageViewDestinationTransformXRotation = Double.pi
    
    let webViewStartingTransformXRotation = -Double.pi
    let webViewDestinationTransformXRotation =  0.0
    
    let article: Article
    
    let totalAnimationTime = 2.0
    var startTime = 0.0
    
    var isOpen = false
    var isBeingManipulatedByTheUser = false
    
    var delegate: FoldableArticleViewDelegate?
    
    var startingWidth = 0.0
    
    required init?(coder: NSCoder) {
        self.article = Article(url: nil, previewImage: nil)
        super.init(coder: coder)
    }
    
    init(article: Article) {
        self.article = article
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = .clear
        
        transformView.backgroundColor = .clear
        transformView.clipsToBounds = true
        var t = CATransform3DIdentity
        t.m34 = -1.0/2500
        transformView.layer.transform = t

        // Try with Web Views!!!
//        let myRequest = URLRequest(url: article.url!)
//
//        fullWebView.uiDelegate = self
//        fullWebView.load(myRequest)
//
//        fullWebView.scrollView.delegate = self
//        fullWebView.navigationDelegate = self
        fullWebView.backgroundColor = .blue

        // Prepare the image and the sheen of light to go in the same container
        imageView.clipsToBounds = true
        imageView.layer.isDoubleSided = false
        imageView.layer.cornerRadius = 3.0
        imageView.contentMode = .scaleAspectFill

        sheenOfLight.backgroundColor = .white
        sheenOfLight.alpha = 0.5
//        sheenOfLight.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        
        imageContainerView.clipsToBounds = true
        imageContainerView.layer.isDoubleSided = false
        imageContainerView.layer.cornerRadius = 3.0

        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(sheenOfLight)
        
        // Start loading the web page
//        webView.load(myRequest)
        webView.backgroundColor = .red
        webView.layer.cornerRadius = 3.0
        webView.layer.isDoubleSided = false

//        webView.uiDelegate = self
//        webView.scrollView.delegate = self
//        webView.navigationDelegate = self
        webView.clipsToBounds = true
        
        // Use containing view to clip the top half of the fake webview
        fullWebViewClippingView.clipsToBounds = true
        fullWebViewClippingView.addSubview(fullWebView)

        // Add a shadow below everything.
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 50)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 50.0
        shadowView.layer.shadowOpacity = 0.7
        shadowView.backgroundColor = .white

        transformView.addSubview(shadowView)
        transformView.addSubview(fullWebViewClippingView)
        transformView.addSubview(webView)
        transformView.addSubview(imageContainerView)
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(gesture:)))
        addGestureRecognizer(dragGesture)
        dragGesture.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        addGestureRecognizer(tapGesture)
        tapGesture.delegate = self

        addSubview(transformView)
    }
    
    let downscaleTransform = CATransform3DMakeScale(0.8, 0.8, 1.0)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Lay out differently depending on open, closed, or animating
        
        if isBeingManipulatedByTheUser {
            return
        }
        
        if isOpen {
            applyLayoutForOpenState()
            return
        }
        
//        return
        // The old closed version
        transformView.frame = bounds
        
//        let cardWidthAndHeight = self.bounds.size.width// - 40.0
        let cardHeight = self.bounds.width//(self.bounds.height * 1.2)/2.0
        let cardWidth = self.bounds.width
        let yCenter = self.bounds.size.height/2.0// * 0.4 + cardWidthAndHeight/2.0
        
        imageContainerView.bounds = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        imageContainerView.center = CGPoint(x: bounds.width/2.0, y: yCenter - 75) // whatever, fix this later
        imageContainerView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        imageContainerView.layer.transform = downscaleTransform //CATransform3DMakeScale(0.5, 0.5, 1.0)

        imageView.bounds = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        imageView.center = CGPoint(x: imageContainerView.bounds.width/2.0, y: imageContainerView.bounds.height/2.0)

//        let diagonalDistanceOfImage = sqrt(pow(cardWidthAndHeight, 2)*2)
//        sheenOfLight.bounds = CGRect(x: 0, y: 0, width: diagonalDistanceOfImage, height: 100)
//        sheenOfLight.center = CGPoint(x: imageContainerView.bounds.width, y: 0.0)
//        sheenOfLight.layer.transform = CATransform3DMakeRotation(.pi/4, 0, 0, 1)
        
        // Full web view is inside the clipping view
        fullWebViewClippingView.frame = imageContainerView.frame
        fullWebView.frame = CGRect(x: 0, y: -imageContainerView.bounds.height, width: cardWidth, height: cardHeight*2.0)
        
        webView.bounds = fullWebView.bounds //CGRect(x: 0, y: 0, width: fullWebView.bounds.width, height: fullWebView.bounds.height)
        webView.center = CGPoint(x: imageContainerView.center.x, y: imageContainerView.center.y)
        webView.layer.transform = CATransform3DRotate(CATransform3DIdentity, -Double.pi, 1, 0, 0)
        
        shadowView.frame = fullWebViewClippingView.frame
    }
    
    func applyLayoutForOpenState() {
        // When open,
        // 1) The full webview should be rotated back to 0.0 rotation
        // 2) The image container view should be rotated to .pi
        // 3) The
        
        imageContainerView.layer.transform = CATransform3DRotate(downscaleTransform, imageViewDestinationTransformXRotation, 1, 0, 0)
        webView.layer.transform = CATransform3DRotate(downscaleTransform, webViewDestinationTransformXRotation, 1, 0, 0)
        
        sheenOfLight.layer.transform = CATransform3DTranslate(sheenOfLight.layer.transform, 0, 5, 0)

        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (scrollView.contentOffset.y < 0.0) {
//            scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
//        }
//        if scrollView == webView.scrollView {
//            fullWebView.scrollView.contentOffset = webView.scrollView.contentOffset
//        }
//        if scrollView == fullWebView.scrollView {
//            webView.scrollView.contentOffset = fullWebView.scrollView.contentOffset
//        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var isPanning = false
    
    let totalFingerTravelAmountToOpen = UIScreen.main.bounds.height * 0.6
    var startingDragLocation = CGPoint.zero
    var endingYLocationToFullyOpen = 0.0
    var lastLocation = CGPoint.zero

    var lastAppliedPercentage = 0.0
    
    @objc func didTap(gesture: UIPanGestureRecognizer) {
        animateToOpen()
    }
    
    @objc func didPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.delegate?.startedAnimating()
            isPanning = true
            startingDragLocation = gesture.location(in: self)
            lastLocation = startingDragLocation
            endingYLocationToFullyOpen = startingDragLocation.y - totalFingerTravelAmountToOpen
            print("began location: \(startingDragLocation) velocity: \(gesture.velocity(in: self))")
        case .cancelled:
            resetAnimationState()
            print("cancelled  \(gesture.location(in: self)) velocity: \(gesture.velocity(in: self))")
            self.delegate?.stoppedAnimating()
        case .changed:
            let newLocation = gesture.location(in: self)
            let xMovementAmount = lastLocation.x - newLocation.x

            // We have starting point (a), current point (x), and endingY (b), calculate the percent of the way we are
            // Percent = (x - a)/(b - a)
            // TODO: Slow down the opening as you get past the halfway point
            var percentThroughOpening = max(0.0, min(1.5, (newLocation.y - startingDragLocation.y)/(endingYLocationToFullyOpen - startingDragLocation.y)))
            
            if percentThroughOpening > 0.5 {
                let originalPercent = percentThroughOpening
                let amountPastFifty = percentThroughOpening - 0.5
                percentThroughOpening = min(1.0, 0.5 + amountPastFifty/2.0)
                print("should have been \(originalPercent) but was \(percentThroughOpening)")
            }
            
            moveAllRelevantViews(by: xMovementAmount)
            openArticleTo(percent: percentThroughOpening)
            applySheen(percent: percentThroughOpening)
            
            lastAppliedPercentage = percentThroughOpening
            
            print("changed  location: \(gesture.location(in: self)) velocity: \(gesture.velocity(in: self)) percent through is \(percentThroughOpening)")
            lastLocation = newLocation
        case .failed:
            resetAnimationState()
            print("failed  \(gesture.location(in: self)) velocity: \(gesture.velocity(in: self))")
            self.delegate?.stoppedAnimating()
        case .possible:
            print("possible")
        case .ended:
            print("ended location: \(gesture.location(in: self)) velocity: \(gesture.velocity(in: self))")
            
            // if past .5 percent done, then animate to final state, other wise go to starting state
            if lastAppliedPercentage > 0.5 {
                animateToOpen()
            } else {
                animateToClosed()
            }
            
            resetAnimationState()
            self.delegate?.stoppedAnimating()
        default:
            print("hit default case somehow")
        }
    }
    
    func resetAnimationState() {
        isPanning = false
        startingDragLocation = .zero
        lastLocation = .zero
        endingYLocationToFullyOpen = 0.0
        lastAppliedPercentage = 0.0
    }
    
    func animateToOpen() {
        isOpen = true
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut]) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
//            self.setNeedsLayout()
//            self.applyLayoutForOpenState()
        } completion: { complete in
            
        }
    }
    
    func animateToClosed() {
        isOpen = false
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut]) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
//            self.applyLayoutForOpenState()
//            self.layoutSubviews()
        } completion: { complete in
            
        }
    }
    
    func applySheen(percent: CGFloat) {
        // The x value goes from imageContainerView.bounds.width to 0.0 over the course of 0.2 to 0.5 percent of the animation
        // The y value goes from 0.0 to imageContainerView.bounds.height
        let startingPercentForShowingSheen = 0.25
        let endingPercentForShowingSheen = 0.5
        
        if percent >= startingPercentForShowingSheen && percent < endingPercentForShowingSheen {
            // ex) 0.3 is what percent of the way between 0.2 and 0.5
            // P = (x -a)/(b-a)
            let percentOfTheWayThroughSheenSection = (percent - startingPercentForShowingSheen)/(endingPercentForShowingSheen-startingPercentForShowingSheen)
            let oppositePercentForX = (1-percentOfTheWayThroughSheenSection)
            
            // X = pb - pa + a
            let currentXForSheen = (oppositePercentForX * imageContainerView.bounds.width) - (oppositePercentForX * 0.1) - 0.1
            let currentYForSheen = (percentOfTheWayThroughSheenSection * imageContainerView.bounds.height) - (percentOfTheWayThroughSheenSection * 0.1) - 0.1
            
            // do we have to just translate it then??
            sheenOfLight.layer.transform = CATransform3DTranslate(sheenOfLight.layer.transform, 0, 5, 0)
            
//            print("The x is \(currentXForSheen) y is \(currentYForSheen) and percent through animation is \(percentOfTheWayThroughSheenSection)")

//            sheenOfLight.layer.transform = CATransform3DIdentity //CATransform3DMakeRotation(.pi/4, 0, 0, 1)
//            sheenOfLight.center = CGPoint(x: -currentXForSheen, y: currentYForSheen)
//            sheenOfLight.layer.transform = CATransform3DMakeRotation(.pi/4, 0, 0, 1)

//            sheenOfLight.isHidden = false
        } else {
//            sheenOfLight.isHidden = true
        }
    }
    
    func moveAllRelevantViews(by xMovementAmount: CGFloat) {
        imageContainerView.center = CGPoint(x: imageContainerView.center.x - xMovementAmount, y: imageContainerView.center.y)
        webView.center = CGPoint(x: webView.center.x - xMovementAmount, y: webView.center.y)
        fullWebViewClippingView.center = CGPoint(x: fullWebViewClippingView.center.x - xMovementAmount, y: fullWebViewClippingView.center.y)
        shadowView.center = CGPoint(x: shadowView.center.x - xMovementAmount, y: shadowView.center.y)
    }
    
    func openArticleTo(percent: CGFloat) {
        let currentXRotationForImage = (percent * imageViewDestinationTransformXRotation) - (percent * imageViewStartingTransformXRotation) - imageViewStartingTransformXRotation
        let currentXRotationForWeb = (percent * webViewDestinationTransformXRotation) - (percent * webViewStartingTransformXRotation) - webViewStartingTransformXRotation
        
        imageContainerView.layer.transform = CATransform3DRotate(downscaleTransform, currentXRotationForImage, 1, 0, 0)
        webView.layer.transform = CATransform3DRotate(downscaleTransform, currentXRotationForWeb, 1, 0, 0)
        
        sheenOfLight.layer.transform = CATransform3DTranslate(sheenOfLight.layer.transform, 0, 5, 0)
    }
}
