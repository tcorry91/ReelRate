//
//  ViewController.swift
//  ReelRate
//
//  Created by Corry Timothy on 22/10/2024.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let topSectionView = TopSectionView()
    
    private let viewModel = MoviesViewModel()
      private var movies: [Movie] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Right Now"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private let collectionView: UICollectionView = {
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .vertical
          layout.minimumLineSpacing = 10
          layout.minimumInteritemSpacing = 10
          let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionView.backgroundColor = .white
          collectionView.translatesAutoresizingMaskIntoConstraints = false
          return collectionView
      }()
    
       private var popularMovies: [String] = ["Movie 1", "Movie 2", "Movie 3", "Movie 4", "Movie 5"]

       override func viewDidLoad() {
           super.viewDidLoad()
           view.backgroundColor = .white
           title = "Popular Right Now"
           view.addSubview(topSectionView)
           view.addSubview(collectionView)
           
           collectionView.dataSource = self
           collectionView.delegate = self
           
           collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
           
           setupConstraints()
           
//           APIManager.shared.makeRequest(endpoint: APIEndpoint.popularMovies.rawValue) { result in
//               switch result {
//               case .success(let data):
//                   print(String(decoding: data, as: UTF8.self))
//               case .failure(let error):
//                   print("Error:", error.localizedDescription)
//               }
//           }
           
           viewModel.onMoviesUpdated = { [weak self] movies in
                     self?.movies = movies
                     self?.collectionView.reloadData()
                 }
           
           viewModel.fetchPopularMovies()
           
       }
       
       private func setupConstraints() {
           topSectionView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            topSectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                      topSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                      topSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                      topSectionView.heightAnchor.constraint(equalToConstant: 120),
            
            collectionView.topAnchor.constraint(equalTo: topSectionView.bottomAnchor, constant: 0),
               collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }
              
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return movies.count
       }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
            let movie = movies[indexPath.item]
            
          
            cell.configure(
                with: movie.title,
                image: nil,
                genres: ["Genre1", "Genre2"]
            )
            
        
            if let posterURL = viewModel.posterURL(for: movie) {
             
            }

            return cell
        }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: view.frame.width - 32, height: 150)
       }
    
}



