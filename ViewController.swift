    var keyName = "com.labcmp.lab3"
    var key: SecKey?
    var cipherTextData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Key prep + public key display
    private func prepareKey() -> Bool {
        defer { getPublicKey() }
        
        if key != nil { return true }
        
        key = KeychainHelper.getKey(name: keyName)
        if key != nil { return true }
        
        do {
            key = try KeychainHelper.generateAndSaveKey(name: keyName)
            return true
        } catch {
            print("Can't create key: \(error)")
            return false
        }
    }
    
    private func getPublicKey() {
        guard let key, let publicKey = SecKeyCopyPublicKey(key) else {
            print("Public Key: none")
            return
        }
        var error: Unmanaged<CFError>?
        if let data = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? {
            print("Public Key: \(data.base64EncodedString())")
        } else {
            print("Public Key: none")
        }
}



    private func encrypt(userInput: String) {
        guard let privateKey = key else { return }
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            print("Can't encrypt: no public key")
            return
        }
        
        // ECIES X9.63 + SHA256 + AES-GCM (must match decrypt)
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
        
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            print("Can't encrypt: algorithm not supported")
            return
        }
        
        var error: Unmanaged<CFError>?
        let clear = Data(userInput.utf8)
        
        guard let cipher = SecKeyCreateEncryptedData(publicKey,
                                                     algorithm,
                                                     clear as CFData,
                                                     &error) as Data? else {
            print("Encryption error: \(String(describing: error?.takeRetainedValue()))")
            return
        }
        
        cipherTextData = cipher
        let cipherB64 = cipher.base64EncodedString()
        
        // Show public key + ciphertext as in the lab
        if let pubKeyData = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? {
            let pubKeyB64 = pubKeyData.base64EncodedString()
            displayEncryptedText.text = "Public key:\n\(pubKeyB64)\n\nCipher Text:\n\(cipherB64)"
        } else {
            displayEncryptedText.text = cipherB64
        }
}




   private func decrypt() {
        guard let privateKey = key, let cipher = cipherTextData else { return }
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
        
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
            print("Can't decrypt: algorithm not supported")
            return
        }
        
        var error: Unmanaged<CFError>?
        guard let clear = SecKeyCreateDecryptedData(privateKey,
                                                    algorithm,
                                                    cipher as CFData,
                                                    &error) as Data? else {
            print("Decryption error: \(String(describing: error?.takeRetainedValue()))")
            return
        }
        
        
        displayDecryptedText?.text = String(decoding: clear, as: UTF8.self)
    }
