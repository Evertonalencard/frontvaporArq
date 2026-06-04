//
//  ContaStore.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import Foundation
import Combine

@MainActor
class ContaStore: ObservableObject {
    @Published var contas: [ContaRegistrada] = []
    @Published var contaSelecionadaId: UUID?

    init() {
        Task {
            await carregarContas()
        }
    }

    var contaSelecionada: ContaRegistrada? {
        contas.first { $0.id == contaSelecionadaId }
    }

    func contasDestino(excluindo id: UUID) -> [ContaRegistrada] {
        contas.filter { $0.podeTransferir && $0.id != id }
    }

    func adicionar(nome: String, tipo: TipoConta) {
        Task {
            do {
                let dto = try await BancoAPIClient.shared.criarConta(nome: nome, tipo: tipo)
                guard let id = dto.id else { return }

                let nova = ContaRegistrada(id: id, nome: nome, tipo: tipo)
                nova.atualizarSaldo(dto.novoValor ?? 0)

                contas.append(nova)
                if contaSelecionadaId == nil {
                    contaSelecionadaId = nova.id
                }
            } catch {
                print("Erro ao criar conta: \(error)")
            }
        }
    }

    func carregarContas() async {
        do {
            let contasDTO = try await BancoAPIClient.shared.listarContas()

            let contasCarregadas = contasDTO.map { dto in
                var tipoConta = TipoConta(rawValue: dto.tipo) ?? .corrente

                switch dto.tipo {
                case "corrente":
                    tipoConta = .corrente
                case "poupanca":
                    tipoConta = .poupanca
                case "internacional":
                    tipoConta = .internacional
                default:
                    tipoConta = .corrente
                }

                let conta = ContaRegistrada(
                    id: dto.id,
                    nome: dto.nome,
                    tipo: tipoConta
                )
                conta.atualizarSaldo(dto.saldo)
                return conta
            }

            contas = contasCarregadas

            if contaSelecionadaId == nil {
                contaSelecionadaId = contas.first?.id
            }
        } catch {
            print("Erro ao carregar contas: \(error)")
        }
    }
}
