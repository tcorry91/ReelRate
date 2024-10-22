//
//  ViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 22/10/2024.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        APIManager.shared.makeRequest(endpoint: APIEndpoint.popularMovies.rawValue) { result in
            switch result {
            case .success(let data):
                print(String(decoding: data, as: UTF8.self))
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
}



