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

protocol ProfileNavigationBarDelegate {
    func backButtonWasTapped()
    func editButtonWasTapped()
    func searchButtonWasTapped()
}

class ProfileNavigationView: UIView {
    var nameString: String? {
        get {
            return nameLabel.text
        }
        
        set(newName) {
            nameLabel.text = newName
        }
    }
    
    let backButton   = UIButton(frame: .zero)
    
    let nameLabel    = UILabel()
    
    let editButton   = UIButton(frame: .zero)
    let searchButton = UIButton(frame: .zero)
    
    var edgePadding = 0.0
    
    var delegate: ProfileNavigationBarDelegate? = nil
    
    @objc func backButtonWasTapped() {
        self.delegate?.backButtonWasTapped()
    }
    @objc func editButtonWasTapped() {
        self.delegate?.editButtonWasTapped()
    }
    @objc func searchButtonWasTapped() {
        self.delegate?.searchButtonWasTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20.0, weight: .bold))?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        let editButtonImage = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20.0, weight: .bold))?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        let searchButtonImage = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20.0, weight: .bold))?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonWasTapped), for: .touchUpInside)
        
        editButton.setImage(editButtonImage, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonWasTapped), for: .touchUpInside)
        
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonWasTapped), for: .touchUpInside)
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = .darkGray
        
        addSubview(backButton)
        
        addSubview(nameLabel)
        
        addSubview(editButton)
        addSubview(searchButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backButton.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        editButton.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        searchButton.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        guard let backButtonImageViewWidth = backButton.imageView?.bounds.size.width,
              let editButtonImageViewWidth = editButton.imageView?.bounds.size.width,
              let searchButtonImageViewWidth = searchButton.imageView?.bounds.size.width else {
            return
        }
        
        backButton.center = CGPoint(x: self.edgePadding + backButtonImageViewWidth/2.0, y: self.bounds.height/2.0)
        
        nameLabel.sizeToFit()
        nameLabel.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        
        searchButton.center = CGPoint(x: self.bounds.width - self.edgePadding - searchButtonImageViewWidth/2.0, y: self.bounds.height/2.0)
        editButton.center = CGPoint(x: searchButton.center.x - searchButtonImageViewWidth/2.0 - editButtonImageViewWidth/2.0 - 8.0, y: self.bounds.height/2.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
