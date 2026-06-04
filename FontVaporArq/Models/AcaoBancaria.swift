//
//  AcaoBancaria.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

enum AcaoBancaria: String, CaseIterable, Identifiable {
    case depositar      = "Depositar"
    case sacar          = "Sacar"
    case pix            = "Pix"
    case pagEspecie     = "Pag. Espécie"
    case transferencia  = "Transferência"
    case salario        = "Registrar Salário"
    case dadosCadastrais = "Dados Cadastrais"

    var id: String { rawValue }

    var icone: String {
        switch self {
        case .depositar:       return "arrow.down.circle.fill"
        case .sacar:           return "arrow.up.circle.fill"
        case .pix:             return "bolt.fill"
        case .pagEspecie:      return "banknote.fill"
        case .transferencia:   return "arrow.left.arrow.right.circle.fill"
        case .salario:         return "dollarsign.circle.fill"
        case .dadosCadastrais: return "person.text.rectangle.fill"
        }
    }

    var corIcone: Color {
        switch self {
        case .depositar:       return .green
        case .sacar:           return .red
        case .pix:             return .cyan
        case .pagEspecie:      return .yellow
        case .transferencia:   return .orange
        case .salario:         return .mint
        case .dadosCadastrais: return .indigo
        }
    }

    var precisaValor: Bool {
        self != .dadosCadastrais
    }

    var precisaDestino: Bool {
        switch self {
        case .pix, .pagEspecie, .transferencia: return true
        default: return false
        }
    }
}
