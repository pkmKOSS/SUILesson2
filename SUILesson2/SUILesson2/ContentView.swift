//
//  ContentView.swift
//  SUILesson2
//
//  Created by Григоренко Александр Игоревич on 17.01.2023.
//

import SwiftUI

struct Bill {
    let name: String
    var value: Int
}

/// Представление с контентом приложения пикера
struct ContentView: View {

    // Constants
    private enum Constants {
        static let debetCardIDName = "1234 4321 1423 2314"
        static let creditCardIDName = "2314 4222 1423 4321"
        static let emptyString = ""
        static let showSettingsName = "Показать настройки"
        static let addBillName = "arrowshape.turn.up.right"
        static let walletName = "Кошелек"
        static let wellcomeName = "Добро пожаловать!"
        static let plusImageName = "plus"
        static let debetCardName = "Дебетовая карта"
        static let balanceName = "Баланс: "
        static let rublesName = "руб."
        static let addMoneyName = "Пополнить баланс"
        static let valueOfMoneyName = "Сумма пополнения"
        static let sendMoneyName = "Перевести деньги"
        static let sendValueName = "Сумма перевода"
        static let transferSuccessName = "Деньги переведены"
        static let addingSuccessName = "Баланс успешно пополнен"
        static let transferAlertName = "Вы уверенны что хотите перевести деньги?"
        static let yesName = "Да"
        static let noName = "Нет"
        static let creditCardName = "Кредитная карта"
        static let payCreditCardName = "Погасить долг"
        static let payCreditCardValueName = "Сумма погашения"
        static let payCreditCardAlertName = "Вы уверенны что хотите перевести деньги?"
        static let verticalSpacing = 15
    }

    // MARK: - private properties

    @State var isOnToggle = false
    @State var isAddMoneyAlertShown = false
    @State var isAddMoneySuccessfullyAlertShown = false
    @State var isAddMoneyToCreditCardShown = false
    @State var isSendMoneyToCreditShown = false
    @State var isSendMoneyToDebetShown = false
    @State var isSendMoneyAlertShown = false
    @State var addMoneyText = ""
    @State var sendToCreditMoneyText = ""
    @State var sendToDebetMoneyText = ""
    @State static var debetCardBalance = 37000
    @State static var creditCardBalance = -50000
    @State var debetCard = Bill(name: Constants.debetCardIDName, value: debetCardBalance)
    @State var creditCard = Bill(name: Constants.creditCardIDName, value: creditCardBalance)

    // MARK: - public properties

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    VStack {
                        walletView.frame(alignment: .center)
                    }
                    Spacer()
                }
                startScreenYellowView
                wellcomeTextView
            }
            showSettingsToggleView
        }.animation(.spring())
    }

    // MARK: - private properties

    private var startScreenYellowView: some View {
        RoundedRectangle(cornerRadius: 10).fill(Color.yellow).offset(x: isOnToggle ? 500 : 0)
    }

    private var showSettingsToggleView: some View {
        Toggle(isOn: $isOnToggle) {
            Text(Constants.showSettingsName)
        }.padding()
    }

    private var wellcomeTextView: some View {
        Text(Constants.wellcomeName)
            .offset(x: isOnToggle ? 500 : 0)
            .frame(width: 170, height: 30)
            .background(Color.white)
            .cornerRadius(10)
    }

    private var sendMoneyImage: some View {
        Image(systemName: Constants.addBillName)
            .frame(width: 40, height: 40)
            .background(Color.yellow)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
    }

    private var titleView: some View {
        HStack {
            Spacer(minLength: 125)

            Text(Constants.walletName)
                .cornerRadius(10)
                .padding()
                .font(.title)
                .italic()

            Spacer()

            Button {

            } label: {
                Image(systemName: Constants.plusImageName)
                    .frame(width: 30, height: 30)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding()
            }
        }
    }

    private var debetCardView: some View {
        VStack(spacing: 20) {
            Text(Constants.debetCardName)
            Text(debetCard.name)
            HStack() {
                Text(Constants.balanceName)
                Text("\(debetCard.value)")
                Text(Constants.rublesName)
            }
        }
    }

    private var addMoneyButtonView: some View {
        Button(Constants.addMoneyName) {
            self.isAddMoneyAlertShown = true
        }
        .alert(Constants.addMoneyName, isPresented: $isAddMoneyAlertShown, actions: {
            TextField(Constants.valueOfMoneyName, text: Binding(get: {
                self.addMoneyText
            }, set: { newValue in
                self.addMoneyText = newValue
            }), onEditingChanged: { isEditingEnd in
                guard
                    !isEditingEnd,
                    let money = Int(addMoneyText)
                else { return }
                self.debetCard.value += money
                self.isAddMoneySuccessfullyAlertShown = true
            })
            .foregroundColor(.black)
        })
        .buttonStyle(BorderlessButtonStyle())
        .padding()
        .frame(width: 200, height: 40)
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    private var sendMoneyToCreditCardButtonView: some View {
        Button {
            self.isSendMoneyToCreditShown = true
        } label: {
            sendMoneyImage
        }
        .alert(Constants.sendMoneyName, isPresented: $isSendMoneyToCreditShown, actions: {
            TextField(Constants.sendValueName, text: Binding(get: {
                self.sendToCreditMoneyText
            }, set: { newValue in
                self.sendToCreditMoneyText = newValue
            }), onEditingChanged: { isEditingEnd in
                guard
                    !isEditingEnd,
                    let money = Int(sendToCreditMoneyText)
                else { return }
                self.creditCard.value += money
                self.debetCard.value -= money
                self.isSendMoneyAlertShown = true
            }).foregroundColor(.black)
        })
        .alert(Text(Constants.transferSuccessName), isPresented: $isSendMoneyAlertShown, actions: {
            Text(Constants.transferSuccessName)
        })
        .padding()
        .buttonStyle(BorderlessButtonStyle())
    }

    private var creditCardVStack: some View {
        VStack(spacing: 20) {
            Text(Constants.creditCardName)
            Text(creditCard.name)
            HStack {
                Text(Constants.balanceName)
                Text("\(creditCard.value)")
                Text(Constants.rublesName)
            }
        }
    }

    private var payCreditCardButtonView: some View {
        Button(Constants.payCreditCardName) {
            self.isAddMoneyToCreditCardShown = true
        }.alert(Constants.payCreditCardName, isPresented: $isAddMoneyToCreditCardShown, actions: {
            TextField(Constants.payCreditCardValueName, text: Binding(get: {
                self.addMoneyText
            }, set: { newValue in
                self.addMoneyText = newValue
            }), onEditingChanged: { isEditingEnd in
                guard
                    !isEditingEnd,
                    let money = Int(addMoneyText),
                    money <= debetCard.value
                else { return }
                self.creditCard.value += money
                self.debetCard.value -= money
            })
            .foregroundColor(.black)

        })
        .frame(width: 200, height: 40)
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
    }


    private var sendToDebetCardButtonView: some View {
        Button {
            self.isSendMoneyToDebetShown = true
        } label: {
            sendMoneyImage
        }
        .alert(Constants.sendMoneyName, isPresented: $isSendMoneyToDebetShown, actions: {
            TextField(Constants.sendMoneyName, text: Binding(get: {
                self.sendToDebetMoneyText
            }, set: { newValue in
                self.sendToDebetMoneyText = newValue
            }), onEditingChanged: { isEditingEnd in
                guard
                    !isEditingEnd,
                    let money = Int(sendToDebetMoneyText)
                else { return }
                self.debetCard.value += money
                self.creditCard.value -= money
                self.isSendMoneyAlertShown = true
            })
            .foregroundColor(.black)
        }).alert(isPresented: $isSendMoneyAlertShown) {
            Alert(
                title: Text(Constants.transferAlertName),
                primaryButton: .default(Text(Constants.yesName)),
                secondaryButton: .default(Text(Constants.noName))
            )
        }
        .padding()
        .buttonStyle(BorderlessButtonStyle())
    }

    private var walletView: some View {
        VStack(alignment: .center) {
            titleView
            Form {
                debetCardView
                HStack {
                    addMoneyButtonView
                    sendMoneyToCreditCardButtonView

                }.alert(Text(Constants.addingSuccessName), isPresented: $isAddMoneySuccessfullyAlertShown) {
                    Text(Constants.addingSuccessName)
                }.alert(isPresented: $isSendMoneyAlertShown) {
                    Alert(
                        title: Text(Constants.transferAlertName),
                        primaryButton: .default(Text(Constants.yesName)),
                        secondaryButton: .default(Text(Constants.noName))
                    )
                }
            }

            Form {
                creditCardVStack

                HStack {
                    payCreditCardButtonView
                    sendToDebetCardButtonView
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
