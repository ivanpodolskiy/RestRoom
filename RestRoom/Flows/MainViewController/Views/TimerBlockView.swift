//
//  TimerView.swift
//  RestRoom
//
//  Created by user on 14.08.2024.
//

import UIKit

class TimerBlockView: UIView {
    
    var buttoncClouser: (() -> Void)?
    
    private var seatNumber: Int = 0
    private var roomInfo: RoomInfo!
    private let seconds: Int = 1800
    private var timerManager: TimerManager!
    
    init(number: Int, roomInfo: RoomInfo) {
        self.roomInfo = roomInfo
        seatNumber = number

        super.init(frame: .zero)
        self.backgroundColor = .white
        setTimerManagerConfigure()

        updateTimerLabel(with: timerManager.seconds)
        
        updateButton()
        setSubviews()
        activateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTimerManagerConfigure() {
        timerManager = TimerManager(with: seconds)
        timerManager.onTick = { [weak self] seconds in
            guard let self = self else { return }
            self.updateTimerLabel(with: seconds)
        }
        
        timerManager.onTimerFinish = { [weak self] in
            guard let self = self else { return }
            self.updateButton()
            self.updateTimerLabel(with: seconds)
        }
    }

    
    private func updateTimerLabel(with seconds: Int) {
        let timeString = timeString(time: TimeInterval(seconds))
        timerLabel.text = timeString
    }
    
    private func updateButton() {
        UIView.animate(withDuration: 0.3) {
            let title = self.timerManager.isTimerRunning ? "Забронировано" : "Забронировать"
            self.buttonAction.setTitle(title, for: .normal)
            
            if self.timerManager.isTimerRunning {
                self.buttonAction.backgroundColor = UIColor.specialPaleWhite
                self.buttonAction.titleLabel?.textColor = UIColor.specialTextAction
                self.statusImageView.image = UIImage(named: self.roomInfo.bookedImageName)
                self.buttonAction.setTitleColor(.systemGray, for: .normal)
                
            } else {
                self.buttonAction.backgroundColor = UIColor.specialYellow
                self.statusImageView.image = UIImage(named: self.roomInfo.freeImageName)
                self.buttonAction.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
 
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .specialPaleWhite
        return view
    }()
    
    private lazy var seatNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text =  "№ \(seatNumber)"
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.init().tinkoffSans, size: 50)
        label.textColor = .black
        label.layer.cornerRadius = 5
        return label
        
    }()
    private lazy var statusImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.freeChair)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private  var buttonAction: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.specialPaleWhite
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()
    
    private func setSubviews() {
        addSubview(containerView)
        containerView.addSubview(seatNumberLabel)
        addSubview(statusImageView)
        addSubview(timerLabel)
        addSubview(buttonAction)
    }
    
    private func activateLayout() {
        var spaceAnchorW: CGFloat = 18
        var spaceAnchorH: CGFloat = 11
        var spaceButton: CGFloat = 30
        
        if roomInfo?.seatsCount == 4 {
            spaceAnchorW = 9
            spaceAnchorH = 34
            spaceButton = 15
        }
        
        NSLayoutConstraint.activate([
            seatNumberLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            seatNumberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 38),
            containerView.widthAnchor.constraint(equalToConstant: 68),
            
            statusImageView.topAnchor.constraint(equalTo:seatNumberLabel.bottomAnchor, constant: spaceAnchorH + 6),
            statusImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: spaceAnchorW),
            statusImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -spaceAnchorW),
            
            timerLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: spaceAnchorH - 6),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: 60),
            timerLabel.bottomAnchor.constraint(equalTo: buttonAction.topAnchor, constant: -11),
            
            buttonAction.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonAction.leftAnchor.constraint(equalTo: leftAnchor, constant: spaceButton),
            buttonAction.rightAnchor.constraint(equalTo: rightAnchor, constant: -spaceButton),
            buttonAction.heightAnchor.constraint(equalToConstant: 56),
            buttonAction.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func tapButton(_ sender: UIButton) {
        timerManager.isTimerRunning ?   timerManager.reset() :  timerManager.start()
        updateButton()
        updateTimerLabel(with: timerManager.seconds)
        
        if timerManager.isTimerRunning { buttoncClouser?() }
    }
}
