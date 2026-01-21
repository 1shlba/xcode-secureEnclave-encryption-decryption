@IBAction func encryptButtonTapped(_ sender: Any) {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        guard prepareKey() else { return }
        encrypt(userInput: text)
}
