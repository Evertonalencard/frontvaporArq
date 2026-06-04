//
//  BannerFeedbackView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

struct BannerFeedbackView: View {
    let feedback: FeedbackBancario

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: feedback.sucesso ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(feedback.sucesso ? .green : .red)
                .font(.title3)

            Text(feedback.mensagem)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.branco)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .glassEffect()
    }
}
