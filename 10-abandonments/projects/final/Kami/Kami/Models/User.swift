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

class User: NSObject {
    let username: String!
    let tagline: String!
    let birthdayString: String!
    let id: Int!
    
    var coverPhotoImage: UIImage {
        get {
            if let cachedPhoto = globalCache.object(forKey: imageCacheKey)?.object(forKey: self.coverPhotoCacheKey) as? UIImage {
                return cachedPhoto
            }
            let coverPhotoImage = KamiNetworking.coverPhotoForUser(user: self)
            globalCache.object(forKey: imageCacheKey)?.setObject(coverPhotoImage, forKey: self.coverPhotoCacheKey)
            return coverPhotoImage
        }
    }
    
    var profilePictureImage: UIImage {
        get {
            if let cachedPhoto = globalCache.object(forKey: imageCacheKey)?.object(forKey: self.profileImageCacheKey) as? UIImage {
                return cachedPhoto
            }
            let profilePictureImage = KamiNetworking.profilePictureImageForUser(user: self)
            globalCache.object(forKey: imageCacheKey)?.setObject(profilePictureImage, forKey: self.profileImageCacheKey)
            return profilePictureImage
        }
    }
    
    var sessionID: SessionID!
    
    var profileImageCacheKey: NSString {
        get {
            return "ProfilePicture-\(String(describing: username))\(String(describing: id))" as NSString
        }
    }
    
    var coverPhotoCacheKey: NSString {
        get {
            return "CoverPhoto-\(String(describing: username))\(String(describing: id))" as NSString
        }
    }
    
    init(username: String, tagline: String, birthdayString: String, id: Int) {
        self.username = username
        self.tagline = tagline
        self.birthdayString = birthdayString
        
        self.id = id
        self.sessionID = Session.generateSessionID()
        super.init()
    }
    
    static func currentUser() -> User {
        return KamiNetworking.currentUser()
    }
    
    func updateSession() {
        Session.logMetrics(user: self)
        self.sessionID = Session.generateSessionID()
    }
    
}
