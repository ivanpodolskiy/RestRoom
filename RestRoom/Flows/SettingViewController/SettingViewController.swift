//
//  SettingViewController.swift
//  RestRoom
//
//  Created by user on 23.09.2024.
//

import Foundation
import UIKit


class SettingViewController: UIViewController {
    weak var delegate: SettingViewControllerDelegate? 
    private var selectedRoomType: RoomType?
    private var sNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setData()
        setSubviews()
        activateLayout()
    }
    
    private func setData() {
        let info = InfoStorage.shared.getInfo()
        selectedRoomType = info.roomType
        sNumber = info.serialNumber
    }
    
  
    private let screenLabel: UILabel = {
        let label = UILabel()
        label.text = "Меню настроек"
        label.font = UIFont(name: Fonts.init().tinkoffSans, size: 45)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private let snFiledLabel: UILabel = {
        let label = UILabel()
        label.text = "s/n устройства"
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var snDeviceField: UITextField = {
        let textField = UITextField()
        textField.text = sNumber ?? ""
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let locationTableLabel: UILabel = {
        let label = UILabel()
        label.text = "Место установки"
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RoomCell")
        return tableView
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.specialPaleWhite
        button.layer.cornerRadius = 12
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.init().neuehaasunicaw1g, size: 20)
        
        button.addTarget(nil, action: #selector(tapAction), for: .allTouchEvents)
        return button
    }()
    
    private func setSubviews() {
        view.addSubview(screenLabel)
        view.addSubview(snFiledLabel)
        view.addSubview(locationTableLabel)
        
        view.addSubview(snDeviceField)
        view.addSubview(locationTableView)
        view.addSubview(actionButton)
    }
    
    private func activateLayout() {
        NSLayoutConstraint.activate([
            screenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            screenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            snFiledLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -175),
            snFiledLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            snDeviceField.topAnchor.constraint(equalTo: snFiledLabel.bottomAnchor, constant: 15),
            snDeviceField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            snDeviceField.widthAnchor.constraint(equalToConstant: 350),
            snDeviceField.heightAnchor.constraint(equalToConstant: 45),
            
            locationTableLabel.topAnchor.constraint(equalTo: snDeviceField.bottomAnchor, constant: 30),
            locationTableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            locationTableView.topAnchor.constraint(equalTo: locationTableLabel.bottomAnchor, constant: 15),
            locationTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationTableView.widthAnchor.constraint(equalToConstant: 350),
            locationTableView.heightAnchor.constraint(equalToConstant: 220),
            
            actionButton.topAnchor.constraint(equalTo: locationTableView.bottomAnchor, constant: 30),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 150),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func tapAction(_ sender: UIButton) {
        guard let selectedRoomType = selectedRoomType else { return }
        InfoStorage.shared.saveInfo(roomType: selectedRoomType, serialNumber: snDeviceField.text)
        delegate?.didUpdateSettings(selectedRoomType: selectedRoomType, serialNumber: sNumber)
        self.dismiss(animated: true)
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)

        let cellRoomType = RoomType.allCases[indexPath.row]
        if cellRoomType == selectedRoomType  {
            print (cellRoomType.rawValue)
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = cellRoomType.rawValue
        cell.textLabel?.textColor = .systemGray
    
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectedRoomType = RoomType.allCases[indexPath.row]
        self.selectedRoomType = newSelectedRoomType
        tableView.reloadData()
    }
}
