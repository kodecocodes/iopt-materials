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

class FullScreenArticlePreviewView: UIView, FoldableArticleViewDelegate {
    
    let article: Article
    let foldableArticleView: FoldableArticleView
    
    required init?(coder: NSCoder) {
        self.article = Article(url: nil, previewImage: nil)
        foldableArticleView = FoldableArticleView(article: self.article)
        
        super.init(coder: coder)
        backgroundColor = .green
    }
    
    init(frame: CGRect, article: Article) {
        self.article = article
        foldableArticleView = FoldableArticleView(article: article)
        
        super.init(frame: frame)
        
        backgroundColor = .green
        foldableArticleView.delegate = self
        addSubview(foldableArticleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 44.0

        foldableArticleView.frame = bounds
    }
    
    func foldableArticleDidOpen() {
//        self.setNeedsLayout()
    }
    func willBeginAnimatingArticleDidOpen() {
//        self.setNeedsLayout()
    }
    
    func startedAnimating() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        } completion: { complete in
            
        }
    }
    
    func stoppedAnimating() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut]) {
            self.transform = CGAffineTransform.identity
        } completion: { complete in
            
        }
    }
}
