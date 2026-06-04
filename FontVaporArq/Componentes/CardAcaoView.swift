//
//  CardAcaoView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

// MARK: - Card de Ação Individual

struct CardAcaoView: View {
    let acao: AcaoBancaria
    let aoTocar: () -> Void

    @State private var hovering = false

    var body: some View {
        Button(action: aoTocar) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(acao.corIcone.opacity(hovering ? 0.32 : 0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: acao.icone)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(acao.corIcone)
                }

                Text(acao.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.branco)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .glassEffect()
        }
        .buttonStyle(.plain)
        .scaleEffect(hovering ? 1.03 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.65), value: hovering)
        .onHover { hovering = $0 }
    }
}
