//
//  ContentView.swift
//  SUILesson2
//
//  Created by Григоренко Александр Игоревич on 17.01.2023.
//

import SwiftUI

/// Представление с контентом приложения пикера
struct ContentView: View {

    // MARK: - private constants

    private enum Constants {
        static let timeText = "Время"
        static let airModeText = "Авиарежим"
        static let displayLightModeText = "Подсветка"
        static let increaseBalanceText = "Пополнить баланс на: "
        static let balanceIncreaseFor = "Ваш баланс пополнен на "
        static let goodText = "Хорошо"
        static let openBillText = "Открыть счет"
        static let userfirstAndLastNameText = "ФИО держателя"
        static let sendMoneyText = "Перевести деньги со счета на счет"
        static let ketText = "Key"
        static let alertMoneyTransitionText = "Какую сумму перевести?"
        static let valueOfTransition = "Какую сумму перевести?"
        static let alertMoneyTransitionQuestenTest = "Вы уверенны что хотите перевести: "
        static let yesText = "Да"
        static let debetBillText = "Дебетовый счет: "
        static let creditBillText = "Кредитный счет: "
        static let billsText = "Счета"
        static let navigationTitleText = "Настройки"
        static let fixedInputValue = 1000
    }

    // MARK: - private properties

    @State private var section = 0
    @State private var cardsSection = 2
    @State private var isOn = false
    @State private var text = ""
    @State private var isPresentedFirst = false
    @State private var isPresentedSecond = false
    @State private var isPresentedThree = false
    @State private var isPresentedFour = false
    @State private var debetCardBalance = 0
    @State private var creditCardBalance = 50000
    @State private var fixInputValue = 100
    @State private var valueOfTransition = "0.00"

    private var settingsTime = ["5 min", "10 min", "15 min"]
    private var procents = ["5 процентов", "10 процентов", "15 процентов"]

    // MARK: - public methods

    var body: some View {
        NavigationStack {
            Form {
                makeTimePicker()
                makeAviaModePicker()
                makeLightModePicker()
                makeIncreaseDebetValuePicker()
                makeOpenBillButton()
                makeMoneyTransitionButton()
                makeBillsButton()
            }
        }.navigationBarTitle(Constants.navigationTitleText)
    }

    // MARK: - private methods

    private func makeTimePicker() -> some View {
        Picker(selection: $section) {
            ForEach(0..<settingsTime.count) {
                Text(self.settingsTime[$0])
            }
        } label: {
            Text(Constants.timeText)
        }.pickerStyle(.navigationLink)
    }

    private func makeAviaModePicker() -> some View {
        Toggle(isOn: $isOn) {
            Text(Constants.airModeText).foregroundColor(isOn ? Color.red : Color.gray)
        }
    }

    private func makeLightModePicker() -> some View {
        Picker(selection: $section) {
            ForEach(0..<procents.count) {
                Text(self.procents[$0])
            }
        } label: {
            Text(Constants.displayLightModeText)
        }
    }

    private func makeIncreaseDebetValuePicker() -> some View {
        Button(action: {
            self.debetCardBalance += Constants.fixedInputValue
            self.isPresentedFirst = true
        }, label: {
            Text("\(Constants.increaseBalanceText)\(fixInputValue)")
        }).confirmationDialog(Constants.ketText, isPresented: $isPresentedFirst) {
            Button(Constants.goodText) {
                print("\(Constants.increaseBalanceText)\(fixInputValue)")
            }
        } message: {
            Text("\(Constants.balanceIncreaseFor)\(fixInputValue) и составляет \(debetCardBalance)")
        }
    }

    private func makeOpenBillButton() -> some View {
        Button(Constants.openBillText) {
            self.isPresentedSecond = true
        }.alert(Text(Constants.openBillText), isPresented: $isPresentedSecond) {
            TextField(Constants.userfirstAndLastNameText, text: $text)
        }
    }

    private func makeMoneyTransitionButton() -> some View {
        Button(Constants.sendMoneyText) {
            self.isPresentedThree = true
        }.alert(Text(Constants.alertMoneyTransitionText), isPresented: $isPresentedThree) {
            TextField(Constants.valueOfTransition, text: $valueOfTransition).keyboardType(.numberPad).alert(Text("\(Constants.alertMoneyTransitionQuestenTest)\(valueOfTransition)"), isPresented: $isPresentedFour) {
                Button(Constants.yesText) {
                    guard
                        let value = Int(valueOfTransition)
                    else {
                        return
                    }
                    debetCardBalance += value
                    creditCardBalance -= value
                }
            }
        }
    }

    private func makeBillsButton() -> some View {
        Picker(selection: $cardsSection) {
            Text("\(Constants.debetBillText)\(debetCardBalance)")
            Text("\(Constants.creditBillText)\(creditCardBalance)")
        } label: {
            Text(Constants.billsText)
        }.pickerStyle(.navigationLink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
