import SwiftUI

enum AcaoBancaria: String, CaseIterable, Identifiable {
    case depositar = "Depositar"
    case sacar = "Sacar"
    case pix = "Pix"
    case pagEspecie = "Pag. Espécie"
    case transferencia = "Transferência"
    case salario = "Registrar Salário"
    case solicitarEmprestimo = "Solicitar Empréstimo"
    case solicitarCartao = "Solicitar Cartão"
    case aumentarLimiteCartao = "Aumentar Limite"
    case dadosCadastrais = "Dados Cadastrais"

    var id: String { rawValue }

    var icone: String {
        switch self {
        case .depositar: return "arrow.down.circle.fill"
        case .sacar: return "arrow.up.circle.fill"
        case .pix: return "bolt.fill"
        case .pagEspecie: return "banknote.fill"
        case .transferencia: return "arrow.left.arrow.right.circle.fill"
        case .salario: return "dollarsign.circle.fill"
        case .solicitarEmprestimo: return "doc.text.fill"
        case .solicitarCartao: return "creditcard.fill"
        case .aumentarLimiteCartao: return "plus.rectangle.on.creditcard.fill"
        case .dadosCadastrais: return "person.text.rectangle.fill"
        }
    }

    var corIcone: Color {
        switch self {
        case .depositar: return .green
        case .sacar: return .red
        case .pix: return .cyan
        case .pagEspecie: return .yellow
        case .transferencia: return .orange
        case .salario: return .mint
        case .solicitarEmprestimo: return .purple
        case .solicitarCartao: return .blue
        case .aumentarLimiteCartao: return .teal
        case .dadosCadastrais: return .indigo
        }
    }

    var precisaValor: Bool {
        switch self {
        case .dadosCadastrais, .solicitarCartao:
            return false
        default:
            return true
        }
    }

    var precisaDestino: Bool {
        switch self {
        case .pix, .pagEspecie, .transferencia:
            return true
        default:
            return false
        }
    }
}
