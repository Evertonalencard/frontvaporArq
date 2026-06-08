import Foundation
import Combine

class ContaRegistrada: ObservableObject, Identifiable {
    let id: UUID
    let nome: String
    let tipo: TipoConta

    @Published var saldo: Double = 0
    @Published var salario: Double = 0
    @Published var possuiCartao: Bool = false
    @Published var cartaoId: Int64? = nil
    @Published var limiteCartao: Double? = nil
    @Published var ultimoEmprestimo: Double? = nil

    init(id: UUID, nome: String, tipo: TipoConta) {
        self.id = id
        self.nome = nome
        self.tipo = tipo
    }

    func atualizarSaldo(_ novoSaldo: Double) {
        saldo = novoSaldo
    }

    func atualizarSalario(_ novoSalario: Double) {
        salario = novoSalario
    }

    func atualizarCartao(id: Int64, limite: Double) {
        self.cartaoId = id
        self.possuiCartao = true
        self.limiteCartao = limite
    }

    func atualizarLimiteCartao(_ novoLimite: Double) {
        self.limiteCartao = novoLimite
        self.possuiCartao = true
    }

    func registrarEmprestimo(_ valor: Double) {
        self.ultimoEmprestimo = valor
    }

    var negativado: Bool { saldo < 0 }

    var podeTransferir: Bool { tipo != .poupanca }

    var acoesDisponiveis: [AcaoBancaria] {
        switch tipo {
        case .poupanca:
            return [.depositar, .sacar, .dadosCadastrais]
        case .corrente, .internacional:
            return [
                .depositar,
                .sacar,
                .pix,
                .pagEspecie,
                .transferencia,
                .salario,
                .solicitarEmprestimo,
                .solicitarCartao,
                .aumentarLimiteCartao,
                .dadosCadastrais
            ]
        }
    }
}
