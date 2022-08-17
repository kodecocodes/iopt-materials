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

class PostUploadViewController: UIViewController {

    let userProfileImageView = UIImageView(image: nil, highlightedImage: nil)
    let userNameLabel = UILabel(frame: .zero)
    
    // Bottom Buttons
    let imagePickerButton = UIButton(frame: .zero)
    let userTaggingButton = UIButton(frame: .zero)
    let addLocationButton = UIButton(frame: .zero)
    
    let postButton = UIButton(frame: .zero)
    
//    required init?(coder: NSCoder) {
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeToUseLotsOfMemory()
        
        view.backgroundColor = .white
        
        view.addSubview(userProfileImageView)
        view.addSubview(userNameLabel)
        
        view.addSubview(imagePickerButton)
        view.addSubview(userTaggingButton)
        view.addSubview(addLocationButton)
        
        view.addSubview(postButton)
    }
    
    func placeToUseLotsOfMemory() {
        // Load some images into memory
        let image1 = UIImage(named: "largeScreenshot1")
        let image2 = UIImage(named: "largeScreenshot2")
        let image3 = UIImage(named: "largeScreenshot3")
        let image4 = UIImage(named: "largeScreenshot4")
        let image5 = UIImage(named: "farmland")
        // Do some filters and other image processing on them
        
        let imageView1 = UIImageView(image: image1, highlightedImage: nil)
        let imageView2 = UIImageView(image: image2, highlightedImage: nil)
        let imageView3 = UIImageView(image: image3, highlightedImage: nil)
        let imageView4 = UIImageView(image: image4, highlightedImage: nil)
        let imageView5 = UIImageView(image: image5, highlightedImage: nil)

        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        view.addSubview(imageView4)
        view.addSubview(imageView5)
        // Do them all async at the same time

    }
}
