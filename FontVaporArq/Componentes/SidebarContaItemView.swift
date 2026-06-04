//
//  SidebarContaItemView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

struct SidebarContaItemView: View {
    @ObservedObject var conta: ContaRegistrada

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(conta.tipo.cor.opacity(0.18))
                    .frame(width: 34, height: 34)
                Image(systemName: conta.tipo.icone)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(conta.tipo.cor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(conta.nome)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)

                Text(formatarMoeda(conta.saldo))
                    .font(.caption)
                    .foregroundStyle(conta.negativado ? .red : .secondary)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.4), value: conta.saldo)
            }
        }
        .padding(.vertical, 4)
    }
}
