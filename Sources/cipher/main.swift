import Foundation
import ArgumentParser
import RNCryptor

struct Cypher: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Encrypt and decrypt files", version: "0.0.1")
    
    @Argument(help: "Password for encrypting and decrypting") var password: String
    @Option(name: .shortAndLong, help: "Input file name") var inputFile: String
    @Option(name: .shortAndLong, help: "Output file name") var outputFile: String
    @Flag(name: .shortAndLong, help: "Decrypt file") var decrypt = false
    
    
    mutating func run() throws {
        var converted = ""
        guard let input = try? String(contentsOfFile: inputFile) else {
            throw RuntimeError("Couldn't read from file \(inputFile)")
        }
        
        if decrypt {
            do {
                converted = try decryptContents(encryptedContent: input)
            } catch {
                throw RuntimeError("Couldn't encrypt '\(inputFile)'")
            }
        } else {
            converted = encryptContent(contents: input)
        }
        
        guard let _ = try? converted.write(toFile: outputFile, atomically: true, encoding: .utf8) else {
            throw RuntimeError("Couldn't write '\(outputFile)'")
        }
        
    }
    
    func encryptContent(contents: String) -> String {
        let contentData = contents.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: contentData, withPassword: password)
        return cipherData.base64EncodedString()
    }
    
    func decryptContents(encryptedContent: String) throws -> String {
        let encryptedData = Data.init(base64Encoded: encryptedContent)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: password)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        return decryptedString
    }
}

Cypher.main()

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
