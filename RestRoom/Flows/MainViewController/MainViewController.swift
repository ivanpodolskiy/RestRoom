//
//  MainViewController.swift
//  RestRoom
//
//  Created by user on 14.08.2024.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func didUpdateSettings(selectedRoomType: RoomType, serialNumber: String?)
}

class MainViewController: UIViewController {
    
    private var spaceBetweenBlocks: CGFloat = 20
    private var roomInfo: RoomInfo
    private var dataBaseModel: DataBaseModel

    init(room: RoomInfo) {
        self.roomInfo = room
        dataBaseModel = DataBaseModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .specialPaleWhite
        NotificationCenter.default.addObserver(self, selector: #selector(guideAccessStatusChanged),
                                               name: UIAccessibility.guidedAccessStatusDidChangeNotification, 
                                               object: nil)
        
        setSubviews()
        activateLayout()
    }
    
    @objc private func guideAccessStatusChanged() {
        print ( UIAccessibility.isGuidedAccessEnabled )
        settingButton.isHidden = true ?  UIAccessibility.isGuidedAccessEnabled : false
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = roomInfo.type.rawValue
        label.font = UIFont(name: Fonts.init().tinkoffSans, size: 52)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let subTittleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пожалуйста, не превышай отведенное время"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var blockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis  = .horizontal
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.spacing = spaceBetweenBlocks
        return stackView
    }()
    
    private var settingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.titleLabel?.font = UIFont(name: Fonts.init().neuehaasunicaw1g, size: 10)
        return button
    }()
    
    private var helpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Помощь", for: .normal)
        button.backgroundColor = UIColor.specialGray
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapHelpButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: Fonts.init().neuehaasunicaw1g, size: 10)
        return button
    }()
    
    @objc private func tapSettingButton(_ sender: UIButton) {
        let vc = SettingViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func tapHelpButton(_ sender: UIButton) {
        let vc = HelpViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func setSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(subTittleLabel)
        view.addSubview(helpButton)
        view.addSubview(settingButton)
        view.addSubview(blockStackView)
        setBlocksToStack()
    }
    
    private func setBlocksToStack(){
        for i in 0..<roomInfo.seatsCount {
            let numberView = i + 1
            let timerView = getTimerBlockView(number: numberView)
            blockStackView.addArrangedSubview(timerView)
        }
    }
    
    private func getTimerBlockView(number: Int) -> TimerBlockView {
        let timerView = TimerBlockView(number: number, roomInfo: roomInfo)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        timerView.layer.cornerRadius = 32
        
        timerView.buttoncClouser = { [weak self] in
            guard let self = self else { return }
            self.dataBaseModel.pushNewValue(seatNumber: number, roomTypeString: self.roomInfo.type.rawValue)
        }
        return timerView
    }
    
    private func refrashSubviews() {
        blockStackView.subviews.forEach { $0.removeFromSuperview() }
        setBlocksToStack()
        titleLabel.text = roomInfo.type.rawValue
        activateLayout()
    }
    
    private func activateLayout() {
        NSLayoutConstraint.activate([
            helpButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            helpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            helpButton.widthAnchor.constraint(equalToConstant: 100),
            helpButton.heightAnchor.constraint(equalToConstant: 40),
            
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            settingButton.widthAnchor.constraint(equalToConstant: 40),
            settingButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subTittleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subTittleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            blockStackView.topAnchor.constraint(equalTo: subTittleLabel.bottomAnchor, constant: 50),
            blockStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 45),
            blockStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -45),
            blockStackView.heightAnchor.constraint(equalToConstant: 464)
        ])
    }
}

extension MainViewController: SettingViewControllerDelegate {
    func didUpdateSettings(selectedRoomType: RoomType, serialNumber: String?) {
        roomInfo = RoomInfo(type: selectedRoomType)
        refrashSubviews()
    }
}
