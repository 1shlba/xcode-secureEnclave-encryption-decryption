# xcode-secureEnclave-encryption-decryption
Swift iOS lab project showcasing Secure Enclave key storage and asymmetric encryption with the Apple Security framework.

## Project Overview
- Secure Enclave elliptic curve key generation
- Public key encryption (ECIES + AES-GCM)
- Private key never leaves Secure Enclave
- Ciphertext and public key displayed in the UI

## Repository Contents
- `KeychainHelper.swift` - Keychain helper class function
- `ViewController.swift` - Properties, Key preparation, Encrypting User input, and Decrypt functions
- `EncryptButton` and `DecryptButton.swift` - Scripts for linking each button to their respective User interface button

> Note: The full Xcode project is not included as it was developed on a borrowed macOS device.
> The provided Swift files can be added to a new Xcode iOS project to run the app.

## How to Run (Xcode)
1. Open Xcode on macOS
2. Create a new **iOS App** project (Storyboard, Swift)
3. Build a simple user interface in Main.Storyboard with:
   
•	A Text Field at the top for user input.
•	A Text View to show encrypted output.
•	A Text View to show decrypted text.
•	Two Buttons labelled “Encrypt” and “Decrypt”.

4. Add the `.swift` files from the `Source/` folder
5. Build and run on a simulator or real device

## Security Concepts Demonstrated
- Secure Enclave vs Keychain
- Hardware-backed key storage
- Asymmetric encryption
- ECIES (X9.63 + SHA256 + AES-GCM)

## Academic Context
Completed as part of **Cyber Security for Mobile Platforms – Spring 2025**


