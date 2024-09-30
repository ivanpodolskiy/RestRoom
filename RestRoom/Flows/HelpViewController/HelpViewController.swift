//
//  HelpViewController.swift
//  RestRoom
//
//  Created by user on 15.08.2024.
//

import UIKit

class HelpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .specialPaleWhite
        setSubviews()
        activateLayout()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Обратись в поддержку Майти"
        label.font = UIFont(name: Fonts.init().tinkoffSans, size: 52)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let subTittleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Постараемся помочь как можно скорее"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let qrCodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.qrCode
        return imageView
    }()
    
    private let subView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Понятно", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.init().neuehaasunicaw1g, size: 40)
        button.backgroundColor = UIColor.specialGray
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(backTap), for: .touchUpInside)

        return button
    }()
    
    @objc func backTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func setSubviews() {
        view.addSubview(subView)
        subView.addSubview(backButton)
        subView.addSubview(titleLabel)
        subView.addSubview(subTittleLabel)
        subView.addSubview(qrCodeImage)
        
    }
   
    
    private func activateLayout() {
        NSLayoutConstraint.activate([
            
            qrCodeImage.topAnchor.constraint(equalTo: subView.topAnchor, constant: 90),
            qrCodeImage.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            qrCodeImage.widthAnchor.constraint(equalToConstant: 260),
            qrCodeImage.heightAnchor.constraint(equalToConstant: 260),

            titleLabel.topAnchor.constraint(equalTo: qrCodeImage.bottomAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            
            subTittleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTittleLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor),

            backButton.topAnchor.constraint(equalTo: subTittleLabel.bottomAnchor, constant: 30),
            backButton.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 120),
            backButton.heightAnchor.constraint(equalToConstant: 50),

            subView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            subView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            subView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
        ])
    }
    
}
