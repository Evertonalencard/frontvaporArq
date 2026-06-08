//
//  DashboardContaView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI


struct DashboardContaView: View {
    @ObservedObject var conta: ContaRegistrada
    @EnvironmentObject private var store: ContaStore

    @State private var acaoAtiva: AcaoBancaria?
    @State private var feedback:  FeedbackBancario?

    private var acoesGrid: [AcaoBancaria] {
        conta.acoesDisponiveis.filter { $0 != .dadosCadastrais }
    }

    private let colunas = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            BackgorundFile()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Cartão de saldo
                    CartaoSaldoView(conta: conta)

                    // Banner de resultado
                    if let fb = feedback {
                        BannerFeedbackView(feedback: fb)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .id(fb.id)
                    }

                    // Grade de ações
                    VStack(spacing: 12) {
                        LazyVGrid(columns: colunas, spacing: 12) {
                            ForEach(acoesGrid) { acao in
                                CardAcaoView(acao: acao) { acaoAtiva = acao }
                                    .frame(height: 110)
                            }
                        }

                        if conta.acoesDisponiveis.contains(.dadosCadastrais) {
                            CardAcaoView(acao: .dadosCadastrais) { acaoAtiva = .dadosCadastrais }
                                .frame(height: 80)
                        }
                    }
                }
                .padding(24)
            }
        }
        .sheet(item: $acaoAtiva) { acao in
            FolhaAcaoView(
                acao: acao,
                conta: conta,
                contasDestino: store.contasDestino(excluindo: conta.id),
                aoFinalizar: { resultado in
                    acaoAtiva = nil
                    processarResultado(resultado)
                },
                aoFechar: { acaoAtiva = nil }
            )
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: feedback?.id)
    }

    private func processarResultado(_ resultado: Resultado) {
        switch resultado {
        case .sucesso:
            feedback = FeedbackBancario(mensagem: "Operação realizada! Atualizando saldo...", sucesso: true)
            Task {
                if let dto = try? await BancoAPIClient.shared.saldo(contaId: conta.id),
                   let novoSaldo = dto.novoValor {
                    await MainActor.run {
                        conta.atualizarSaldo(novoSaldo)
                        feedback = FeedbackBancario(mensagem: "Operação realizada! Saldo \(formatarMoeda(novoSaldo))", sucesso: true)
                    }
                }
            }
        case .falha(let erro):
            feedback = FeedbackBancario(mensagem: erro, sucesso: false)
        }
        Task {
            try? await Task.sleep(for: .seconds(4))
            withAnimation { feedback = nil }
        }
    }
}
