//
//  CartaoSaldoView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

struct CartaoSaldoView: View {
    @ObservedObject var conta: ContaRegistrada

    var body: some View {
        VStack(spacing: 6) {

            // Badge tipo
            HStack(spacing: 5) {
                Image(systemName: conta.tipo.icone)
                    .font(.caption.weight(.bold))
                Text(conta.tipo.titulo.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.5)
            }
            .foregroundStyle(.branco.opacity(0.55))
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(.branco.opacity(0.1), in: Capsule())

            Text(conta.nome)
                .font(.title3.weight(.medium))
                .foregroundStyle(.branco.opacity(0.85))
                .padding(.top, 4)

            Spacer().frame(height: 8)

            Text(formatarMoeda(conta.saldo))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(conta.negativado ? Color.red : Color.branco)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: conta.saldo)

            Text("Saldo disponível")
                .font(.caption)
                .foregroundStyle(.branco.opacity(0.45))

            if conta.negativado {
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Conta negativada")
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.red)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(.red.opacity(0.18), in: Capsule())
                .transition(.scale(scale: 0.85).combined(with: .opacity))
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .glassEffect()
        .animation(.spring(response: 0.35), value: conta.negativado)
    }
}
