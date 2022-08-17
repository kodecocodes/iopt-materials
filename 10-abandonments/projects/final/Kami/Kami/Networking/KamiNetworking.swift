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

class KamiNetworking: NSObject {
    // TODO: Maybe part of the processing is that we should downsize this big image as a speed improvement for getting the image
    //       to show up. First have the push be slow, fix that, by putting the image on the background thread.
    //       Then, make it show up faster later by downsizing and caching that version.
    
    // TODO: For tomorrow, having it so that this image is re-generated many times will make the memory grow a bunch.
    class func currentUser() -> User {
        // Fake network code that returns the same user all the time for now.
        // but soon, add code to get their actual facebook info?
        // Or fake stuff if they would rather have that.
        
        return User(username: "Luke Parham", tagline: "Something funny. Something Smart", birthdayString: "Apri 6, 1990", id: 1337)
    }
    
    class func coverPhotoForUser(user: User) -> UIImage {
        return UIImage(contentsOfFile: Bundle.main.path(forResource: "farmland", ofType: "jpg")!)!
    }

    class func profilePictureImageForUser(user: User) -> UIImage {
        return UIImage(contentsOfFile: Bundle.main.path(forResource: "profilePic", ofType: "jpg")!)!
    }
}
