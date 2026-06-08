import Foundation

private struct ValorRequest: Encodable {
    let valor: Double
}

private struct NomeRequest: Encodable {
    let nome: String
}

private struct PagamentoRequest: Encodable {
    let tipo: String
    let valor: Double
    let idContaOrigem: String
    let idContaDestino: String
}

private struct CartaoRequestDTO: Encodable {
    let numero: String
    let cvv: String
    let validade: String
    let titular: String
    let limite: Double
}

private struct EmprestimoRequest: Encodable {
    let valor: Double
    let idConta: String
}

class BancoAPIClient {
    static let shared = BancoAPIClient()

    private let contaBaseURL = "https://contaprojvaporarquitetura-2.onrender.com"
    private let pagamentoBaseURL = "https://pagamentoservice-356z.onrender.com"
    private let cartaoBaseURL = "https://cardservice.onrender.com"
    private let emprestimoBaseURL = "https://emprestimoservice.onrender.com"

    func criarConta(nome: String, tipo: TipoConta) async throws -> ResultadoAPIDTO {
        let endpoint: String
        switch tipo {
        case .corrente:
            endpoint = "\(contaBaseURL)/contas/corrente"
        case .poupanca:
            endpoint = "\(contaBaseURL)/contas/poupanca"
        case .internacional:
            endpoint = "\(contaBaseURL)/contas/internacional"
        }
        return try await post(url: endpoint, body: NomeRequest(nome: nome))
    }

    func depositar(contaId: UUID, valor: Double) async throws -> ResultadoAPIDTO {
        try await post(url: "\(contaBaseURL)/contas/\(contaId)/depositar", body: ValorRequest(valor: valor))
    }

    func sacar(contaId: UUID, valor: Double) async throws -> ResultadoAPIDTO {
        try await post(url: "\(contaBaseURL)/contas/\(contaId)/sacar", body: ValorRequest(valor: valor))
    }

    func saldo(contaId: UUID) async throws -> ResultadoAPIDTO {
        try await get(url: "\(contaBaseURL)/contas/\(contaId)/saldo")
    }

    func registrarSalario(contaId: UUID, valor: Double) async throws -> ResultadoAPIDTO {
        try await post(url: "\(contaBaseURL)/contas/\(contaId)/salario", body: ValorRequest(valor: valor))
    }

    func buscarSalario(contaId: UUID) async throws -> Double {
        let dto = try await get(url: "\(contaBaseURL)/contas/\(contaId)/salario")
        return dto.novoValor ?? 0
    }

    func pagar(tipo: String, origemId: UUID, destinoId: UUID, valor: Double) async throws -> PagamentoResponseDTO {
        let body = PagamentoRequest(
            tipo: tipo,
            valor: valor,
            idContaOrigem: origemId.uuidString,
            idContaDestino: destinoId.uuidString
        )

        var request = URLRequest(url: URL(string: "\(pagamentoBaseURL)/pagamentos")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode, "URL:", request.url?.absoluteString ?? "")
        }
        if let json = String(data: data, encoding: .utf8) {
            print("BODY:", json)
        }

        return try JSONDecoder().decode(PagamentoResponseDTO.self, from: data)
    }

    func solicitarEmprestimo(contaId: UUID, valor: Double) async throws -> EmprestimoResponseDTO {
        let body = EmprestimoRequest(
            valor: valor,
            idConta: contaId.uuidString
        )

        var request = URLRequest(url: URL(string: "\(emprestimoBaseURL)/emprestimos")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode, "URL:", request.url?.absoluteString ?? "")
        }
        if let json = String(data: data, encoding: .utf8) {
            print("BODY:", json)
        }

        return try JSONDecoder().decode(EmprestimoResponseDTO.self, from: data)
    }

    func solicitarCartao(titular: String, limite: Double) async throws -> CartaoDTO {
        let body = CartaoRequestDTO(
            numero: UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16).description,
            cvv: String(Int.random(in: 100...999)),
            validade: "12/30",
            titular: titular,
            limite: limite
        )

        _ = try await postString(url: "\(cartaoBaseURL)/card/solicitar", body: body)

        return CartaoDTO(
            id: Int64.random(in: 1...999999),
            numero: body.numero,
            cvv: body.cvv,
            validade: body.validade,
            titular: body.titular,
            limite: body.limite,
            ativo: true
        )
    }

    func aumentarLimite(cartaoId: Int64) async throws -> String {
        var request = URLRequest(url: URL(string: "\(cartaoBaseURL)/card/aumento/\(cartaoId)")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode, "URL:", request.url?.absoluteString ?? "")
        }
        if let body = String(data: data, encoding: .utf8) {
            print("BODY:", body)
            return body
        }

        return "Sem resposta"
    }

    func buscarCartao(cartaoId: Int64) async throws -> CartaoDTO {
        let url = "\(cartaoBaseURL)/card/\(cartaoId)"
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode, "URL:", url)
        }
        if let json = String(data: data, encoding: .utf8) {
            print("BODY:", json)
        }

        return try JSONDecoder().decode(CartaoDTO.self, from: data)
    }

    private func post<B: Encodable>(url: String, body: B) async throws -> ResultadoAPIDTO {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode, "URL:", url)
        }
        if let json = String(data: data, encoding: .utf8) {
            print("BODY:", json)
        }

        return try JSONDecoder().decode(ResultadoAPIDTO.self, from: data)
    }

    private func postString<B: Encodable>(url: String, body: B) async throws -> String {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode, "URL:", url)
        }
        if let json = String(data: data, encoding: .utf8) {
            print("BODY:", json)
            return json
        }

        return ""
    }

    private func get(url: String) async throws -> ResultadoAPIDTO {
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode, "URL:", url)
        }
        if let json = String(data: data, encoding: .utf8) {
            print("BODY:", json)
        }

        return try JSONDecoder().decode(ResultadoAPIDTO.self, from: data)
    }
}

extension BancoAPIClient {
    func listarContas() async throws -> [ContaDTO] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "\(contaBaseURL)/contas")!)
        if let json = String(data: data, encoding: .utf8) {
            print("JSON /contas:", json)
        }
        return try JSONDecoder().decode([ContaDTO].self, from: data)
    }
}
