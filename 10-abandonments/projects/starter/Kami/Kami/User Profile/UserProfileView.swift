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

class UserProfileView: UIView {
    let user: User!
    
    let profileToolbarView = ProfileNavigationView()
    
    let divider = UIView()
    
    let userProfilePictureView = UIImageView()
    let userProfilePictureEditButton = UIButton()
    
    let usernameLabel = UILabel()
    let taglineLabel = UILabel()
    
    let coverPhotoImageView = UIImageView()
    let coverPhotoEditButton = UIButton()
    
    let imageView3 = UIImageView()
    
    init(user: User) {
        self.user = user

        super.init(frame: .zero)
        
        coverPhotoImageView.clipsToBounds = true
        
        profileToolbarView.nameString = user.username
        
        usernameLabel.text = user.username
        usernameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        usernameLabel.textColor = .black
        
        taglineLabel.text = user.tagline
        taglineLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        taglineLabel.textColor = .black
        
        loadImages()
        
        backgroundColor = .white
        
        addSubview(profileToolbarView)
        addSubview(divider)
        addSubview(coverPhotoImageView)
        addSubview(coverPhotoEditButton)
        addSubview(userProfilePictureView)
        addSubview(userProfilePictureEditButton)
        addSubview(usernameLabel)
        addSubview(taglineLabel)
    }
    
    func loadImages() {
        coverPhotoImageView.image = user.coverPhotoImage
        
        let coverEditConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let profileEditConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        
        let coverEditCameraImage = UIImage(systemName: "camera.fill", withConfiguration: coverEditConfig)?.withRenderingMode(.alwaysOriginal)
        let profileEditCameraImage = UIImage(systemName: "camera.fill", withConfiguration: profileEditConfig)?.withRenderingMode(.alwaysTemplate)
        
        coverPhotoEditButton.setImage(coverEditCameraImage, for: .normal)
        coverPhotoEditButton.imageView?.tintColor = .black
        
        userProfilePictureEditButton.setImage(profileEditCameraImage, for: .normal)
        userProfilePictureEditButton.imageView?.tintColor = .black
        
        let profilePictureImage = user.profilePictureImage
        userProfilePictureView.image = profilePictureImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topPadding = 10.0
        let profileToolbarHeight = self.bounds.height * 0.075
        let dividerHeight = 0.5
        let coverPhotoHeight = 200.0
        let profilePhotoWidthHeight = self.bounds.width/2.0
        
        let defaultSpacing = 8.0
        
        profileToolbarView.edgePadding = 20.0
        profileToolbarView.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: profileToolbarHeight/2.0)
        profileToolbarView.center = CGPoint(x: self.bounds.width/2.0, y: self.safeAreaInsets.top + profileToolbarView.bounds.height/2.0 + topPadding)
        
        divider.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: dividerHeight)
        divider.center = CGPoint(x: self.bounds.width/2.0, y: profileToolbarView.center.y + profileToolbarHeight/2.0 + dividerHeight/2.0)
        divider.backgroundColor = .systemGray6
        
        // Cover Photo
        coverPhotoImageView.bounds = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: coverPhotoHeight)
        coverPhotoImageView.center = CGPoint(x: self.bounds.size.width/2.0, y: divider.center.y + divider.bounds.height/2.0 + coverPhotoHeight/2.0 + defaultSpacing)
        
        if coverPhotoImageView.mask == nil {
            // Round cover photo top corners]
            let path = UIBezierPath(roundedRect:coverPhotoImageView.bounds,
                                    byRoundingCorners:[.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 20, height:  20))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            coverPhotoImageView.layer.mask = mask
        }
        
        // Cover Photo Edit Button
        coverPhotoEditButton.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        coverPhotoEditButton.center = CGPoint(x: coverPhotoImageView.center.x + coverPhotoImageView.bounds.width/2.0 - coverPhotoEditButton.bounds.width/2.0 - 8.0, y: coverPhotoImageView.center.y + coverPhotoImageView.bounds.height/2.0 - coverPhotoEditButton.bounds.height/2.0 - 8.0)
        
        coverPhotoEditButton.backgroundColor = .lightGray
        coverPhotoEditButton.layer.cornerRadius = coverPhotoEditButton.bounds.width/2.0
        coverPhotoEditButton.layer.borderWidth = 2.0
        coverPhotoEditButton.layer.borderColor = UIColor.white.cgColor
        
        // Profile Picture
        userProfilePictureView.bounds = CGRect(x: 0, y: 0, width: profilePhotoWidthHeight, height: profilePhotoWidthHeight)
        userProfilePictureView.center = CGPoint(x: coverPhotoImageView.center.x, y: coverPhotoImageView.center.y + coverPhotoHeight/2.0)
        
        userProfilePictureView.layer.borderWidth = 5.0
        userProfilePictureView.layer.borderColor = UIColor.white.cgColor
        userProfilePictureView.layer.cornerRadius = userProfilePictureView.bounds.width/2.0
        userProfilePictureView.clipsToBounds = true
        
        // Profile Picture Edit Button
        userProfilePictureEditButton.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        userProfilePictureEditButton.center = CGPoint(x: userProfilePictureView.frame.origin.x + userProfilePictureView.frame.width - userProfilePictureView.bounds.width/8.0, y: userProfilePictureView.frame.origin.y + userProfilePictureView.frame.height - userProfilePictureView.bounds.height/6.0)
        
        userProfilePictureEditButton.backgroundColor = .lightGray
        userProfilePictureEditButton.layer.cornerRadius = userProfilePictureEditButton.bounds.width/2.0
        userProfilePictureEditButton.layer.borderWidth = 2.0
        userProfilePictureEditButton.layer.borderColor = UIColor.white.cgColor
        
        usernameLabel.sizeToFit()
        usernameLabel.center = CGPoint(x: userProfilePictureView.center.x, y: userProfilePictureView.center.y + userProfilePictureView.bounds.height/2.0 + usernameLabel.bounds.height/2.0 + 20.0)
        
        taglineLabel.sizeToFit()
        taglineLabel.center = CGPoint(x: usernameLabel.center.x, y: usernameLabel.center.y + usernameLabel.bounds.height/2.0 + taglineLabel.bounds.height/2.0 + 8.0)
    }
}
