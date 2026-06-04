import SwiftUI

enum TipoConta: String, CaseIterable, Identifiable, Codable {
    case corrente = "corrente"
    case poupanca = "poupanca"
    case internacional = "internacional"

    var id: String { rawValue }

    var titulo: String {
        switch self {
        case .corrente: return "Conta Corrente"
        case .poupanca: return "Conta Poupança"
        case .internacional: return "Conta Internacional"
        }
    }

    var icone: String {
        switch self {
        case .corrente: return "creditcard.fill"
        case .poupanca: return "banknote.fill"
        case .internacional: return "globe"
        }
    }

    var cor: Color {
        switch self {
        case .corrente: return .cyan
        case .poupanca: return .green
        case .internacional: return .orange
        }
    }

    var descricao: String {
        switch self {
        case .corrente: return "Depósito, saque, Pix e transferências"
        case .poupanca: return "Rendimento mensal automático"
        case .internacional: return "Operações em moeda estrangeira"
        }
    }
}
