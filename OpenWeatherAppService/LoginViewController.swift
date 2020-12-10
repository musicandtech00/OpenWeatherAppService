//
//  ViewController.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 11/30/20.
//

import UIKit
import AuthenticationServices
import KeychainAccess

class LoginViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button.setTitle("SIGN IN WITH FACEBOOK", for: .normal)
        return button
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Umbrella")
        
        return imageView
    }()
    
    private let backgroundImageCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.65)
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .white
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Open Weather."
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dataManager = {
       return DataManager(baseURL: URL(string: "https://api.openweathermap.org/data/2.5/onecall")!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        constructSubviewHierarchy()
        constructSubviewConstraints()
    }
    
    private func constructSubviewHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(backgroundImageCoverView)
        view.addSubview(button)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
    }

    private func constructSubviewConstraints() {
        backgroundImage.activateConstraints([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        backgroundImageCoverView.activateConstraints([
            backgroundImageCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageCoverView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        titleLabel.activateConstraints([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        subtitleLabel.activateConstraints([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    @objc private func didTapLogin() {
        let facebookAppID = API.faceBookID
        let permissionScopes = ["email"]
        let state = UUID().uuidString
        let callbackScheme = "fb" + facebookAppID
        let baseURLString = API.facebookBaseURL
        let urlString = "\(baseURLString)"
          + "?client_id=\(facebookAppID)"
          + "&redirect_uri=\(callbackScheme)://authorize"
          + "&scope=\(permissionScopes.joined(separator: ","))"
          + "&response_type=token%20granted_scopes"
          + "&state=\(state)"
        let url = URL(string: urlString)!

        let session = ASWebAuthenticationSession(
          url: url, callbackURLScheme: callbackScheme) {
          [weak self] (url, error) in

          guard error == nil else {
            print(error!)
            return
          }

          guard
            let receivedURL = url,
            let response = self?.response(from: receivedURL) else {
            print("Invalid url: \(String(describing: url))")
            return
          }

          guard response.state == state else {
            print("State changed during login! Possible security breach.")
            return
          }

            print(response)
            self?.presetAddLocationViewController()
            KeyChainManager.shared.store(token: response.acessToken)
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
    private func response(from url: URL) -> FacebookLoginResponse? {

        var urlComponent = URLComponents()
        urlComponent.query = url.fragment
        

        guard
            let items = urlComponent.queryItems,
            let scope = getComponent(named: "granted_scopes", in: items),
          let state = getComponent(named: "state", in: items),
        let accessToken = getComponent(named: "access_token", in: items)
        else {
          return nil
        }
        // 3

      let grantedPermissions = scope
        .split(separator: ",")
        .map(String.init)

        return FacebookLoginResponse(
            grantedPermissionScopes: grantedPermissions,
            state: state,
            acessToken: accessToken)
    }
    
    private func presetAddLocationViewController() {
        let vc = AddLocationViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(
    for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return view.window!
  }
}

public struct FacebookLoginResponse {
  let grantedPermissionScopes: [String]
  let state: String
  let acessToken: String
}

func getComponent(
  named name: String,
  in items: [URLQueryItem]) -> String? {

  items.first(where: { $0.name == name })?.value
}

