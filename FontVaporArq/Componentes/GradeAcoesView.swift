//
//  GradeAcoesView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI
// MARK: - Grade de Ações

struct GradeAcoesView: View {
    @Binding var acaoAtiva: AcaoBancaria?
    
    private let acoesGrid: [AcaoBancaria] = [
        .depositar, .sacar, .pix, .pagEspecie, .transferencia, .salario
    ]
    private let colunas = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            LazyVGrid(columns: colunas, spacing: 12) {
                ForEach(acoesGrid) { acao in
                    CardAcaoView(acao: acao) { acaoAtiva = acao }
                        .frame(height: 110)
                }
            }
            // Card de dados cadastrais ocupa a linha inteira
            CardAcaoView(acao: .dadosCadastrais) { acaoAtiva = .dadosCadastrais }
                .frame(height: 80)
        }
    }
}
