//
//  PostController.swift
//  WebServiceController
//
//  Created by Sean on 5/22/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

class PostController: NSObject {
    struct Endpoints {
        static let posts = "posts"
        static let postsWithId = "posts/%ld"
    }

    func getPosts(completion: @escaping ([Post]?, Error?) -> ()) {
        WebServiceController.sharedInstance.get(Endpoints.posts) { (objects, response, error) in
            guard let objects = objects as? [[String : Any]] else {
                completion(nil, error)
                return
            }

            let posts = objects.map { Post(dictionary: $0) }
            completion(posts, error)
        }
    }

    func update(_ post: Post, completion: @escaping (Error?) -> ()) {
        guard let postId = post.id else {
            return
        }

        let endpoint = String(format: Endpoints.postsWithId, postId)

        WebServiceController.sharedInstance.put(endpoint, parameters: nil, json: post.toJSON()) { (objects, response, error) in
            completion(error)
        }
    }

    func uploadNew(_ post: Post, completion: @escaping (Error?) -> ()) {
        WebServiceController.sharedInstance.post(Endpoints.posts, json: post.toJSON()) { (objects, response, error) in
            completion(error)
        }
    }
}
