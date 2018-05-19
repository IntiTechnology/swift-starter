//
//  AppServerClient.swift
//  Users
//

import Alamofire
 
// MARK: - AppServerClient
class AppServerClient {
 
    // MARK: - GetFriends
    enum GetUsersFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
 
    typealias GetUsersResult = Result&lt;[User], GetUsersFailureReason&gt;
    typealias GetUsersCompletion = (_ result: GetUsersResult) -&gt; Void
 
    func getUsers(completion: @escaping GetUsersCompletion) {
        Alamofire.request("http://tasteitbeanstalk-env.vpxfmvg3pe.us-east-1.elasticbeanstalk.com:/api/users")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let jsonArray = response.result.value as? [JSON] else {
                        completion(.failure(nil))
                        return
                    }
                    completion(.success(payload: jsonArray.flatMap { User(json: $0 ) }))
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetUsersFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
}