//
//  ContaRegistrada.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import Foundation
import Combine

class ContaRegistrada: ObservableObject, Identifiable {
    let id: UUID
    let nome: String
    let tipo: TipoConta

    @Published var saldo: Decimal = 0

    init(id: UUID, nome: String, tipo: TipoConta) {
        self.id   = id
        self.nome = nome
        self.tipo = tipo
    }

    func atualizarSaldo(_ novoSaldo: Decimal) {
        saldo = novoSaldo
    }

    var negativado: Bool { saldo < 0 }

    var podeTransferir: Bool { tipo != .poupanca }

    var acoesDisponiveis: [AcaoBancaria] {
        switch tipo {
        case .poupanca:
            return [.depositar, .sacar, .dadosCadastrais]
        case .corrente, .internacional:
            return AcaoBancaria.allCases
        }
    }
}
