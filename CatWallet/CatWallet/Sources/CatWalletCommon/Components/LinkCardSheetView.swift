//
//  LinkCardSheetView.swift
//  CatWallet
//
//  Created by Andres Perdomo on 01/02/26.
//

import SwiftUI

struct LinkCardSheetView: View {
    let isLoading: Bool
    let errorMessage: String?
    let onClose: () -> Void
    let onSubmit: (PaymentMethod) -> Void

    @State private var name: String = ""
    @State private var number: String = "4242 4242 4242 4242"
    @State private var month: String = "12"
    @State private var year: String = "\(Calendar.current.component(.year, from: Date()) + 1)"
    @State private var cvc: String = "123"

    var body: some View {
        ZStack {
            PastelBackground()
                .opacity(0.25)

            VStack(spacing: 14) {
                header

                VStack(spacing: 12) {
                    field(title: "Nombre", text: $name, placeholder: "Como aparece en la tarjeta")
                    field(title: "Número", text: $number, placeholder: "4242 4242 4242 4242", keyboard: .numberPad)

                    HStack(spacing: 12) {
                        field(title: "Mes", text: $month, placeholder: "MM", keyboard: .numberPad)
                        field(title: "Año", text: $year, placeholder: "YYYY", keyboard: .numberPad)
                        field(title: "CVC", text: $cvc, placeholder: "***", keyboard: .numberPad)
                    }

                    if let errorMessage, !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red.opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button(action: submit) {
                        HStack(spacing: 10) {
                            Image(systemName: "lock.shield")
                            Text(isLoading ? "Vinculando..." : "Vincular tarjeta")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(roundedBorder(cornerRadius: 14, lineWidth: 2))
                    }
                    .disabled(isLoading)
                }
                .padding(14)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(roundedBorder(cornerRadius: 18, lineWidth: 2))

                Text("Tarjeta de prueba: 4242 4242 4242 4242")
                    .font(.caption)
                    .opacity(0.75)

                Spacer(minLength: 0)
            }
            .padding(16)
        }
        .presentationDetents([.medium])
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Vincula una tarjeta")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Para guardar más de 3 favoritos, necesitamos tokenizar tu método de pago (simulado).")
                    .font(.caption)
                    .opacity(0.8)
            }

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
    }

    private func field(
        title: String,
        text: Binding<String>,
        placeholder: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .opacity(0.75)

            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(roundedBorder(cornerRadius: 12, lineWidth: 1))
        }
    }

    private var borderStyle: some ShapeStyle {
        LinearGradient(
            colors: [
                Color.pink.opacity(0.45),
                Color.purple.opacity(0.35),
                Color.blue.opacity(0.35)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func roundedBorder(cornerRadius: CGFloat, lineWidth: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(borderStyle, lineWidth: lineWidth)
            .allowsHitTesting(false)
    }

    private func submit() {
        let paymentMethod = PaymentMethod(
            cardholderName: name.trimmingCharacters(in: .whitespacesAndNewlines),
            cardNumber: number,
            expMonth: Int(month) ?? 0,
            expYear: Int(year) ?? 0,
            cvc: cvc
        )
        onSubmit(paymentMethod)
    }
}
