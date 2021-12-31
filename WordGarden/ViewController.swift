//
//  ViewController.swift
//  WordGarden
//
//  Created by Korlin Favara on 12/27/21.
//

import UIKit
import AVFAudio


class ViewController: UIViewController {
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var guessedLetterTextField: UITextField!
    
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterTextField.text!
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        updateGameStatusLabels()
    }
    
    func playSound(name: String) {
        if let sound = NSDataAsset(name: name) {
            do{
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch{
                print("ERROR: \(error.localizedDescription) Did not initialize AV Player")
            }
        } else{
            print("ERROR: Did not read sound")
        }
    }
    
    func updateUIAfterGuess() {
        //resigns control of keyboard which is seen at the first responder
        guessedLetterTextField.resignFirstResponder()
        guessedLetterTextField.text! = ""
        guessLetterButton.isEnabled = false
    }
    
    func formatRevealedWord() {
        var revealedWord = ""
        // format and show revealedWord in wordBeingRevealedLabel to include new guess
        for letter in wordToGuess {
            // check to see if letter in Words Guessed is in lettersGuessed
            if lettersGuessed.contains(letter) {
                //if so add letter to revealedWord with a blank space
                revealedWord = revealedWord + "\(letter) "
                
            } else {
                //if not add _ and blank space
                revealedWord = revealedWord + "_ "
                playSound(name: "incorrect")
            }
        }
        // remove space at the end of revealedWord
        revealedWord.removeLast()
        wordBeingRevealedLabel.text = revealedWord
    }
    
    func updateAfterWinOrLose() {
        currentWordIndex += 1
        guessedLetterTextField.isEnabled = false
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        updateGameStatusLabels()
    }
    
    func updateGameStatusLabels() {
        // update text label at top of screen
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words Remaining: \(wordsToGuess.count - (wordsMissedCount + wordsGuessedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
    }
    func drawFlowerAndPlaySound(currentLetterGuessed: String) {
        // update image, if needed, and keep track of wrong guesses
        if wordToGuess.contains(currentLetterGuessed) == false{
            wrongGuessesRemaining = wrongGuessesRemaining - 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIView.transition(with: self.flowerImageView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {self.flowerImageView.image = UIImage(named: "wilt\(self.wrongGuessesRemaining)")})
                { (_) in
                    // if we are not on the last flower
                    // - show the next flower
                    if self.wrongGuessesRemaining != 0 {
                        self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                    } else {
                        self.playSound(name: "word-not-guessed")
                        UIView.transition(with: self.flowerImageView,
                                          duration: 0.5,
                                          options: .transitionCrossDissolve,
                                          animations: {self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")},
                                          completion: nil)
                    }
                    
                }
                self.playSound(name: "incorrect")
        }
        }else {
            playSound(name: "correct")
        }
    }

    func guessALetter() {
        // get current letter guessed and add it to all letters guessed
        let currentLetterGuessed = guessedLetterTextField.text!
        lettersGuessed = lettersGuessed + currentLetterGuessed
        
        formatRevealedWord()
        drawFlowerAndPlaySound(currentLetterGuessed: currentLetterGuessed)
        
        // update gameStatusLabel for wrong guesses
        guessCount += 1
        let guesses = (guessCount == 1 ? "guess" : "guesses")
        gameStatusMessageLabel.text = "You've made \(guessCount) \(guesses)"
        
        // update win or lose
        if wordBeingRevealedLabel.text!.contains("_") == false {
            gameStatusMessageLabel.text = "You've guessed it! It took you \(guessCount) guesses"
            wordsGuessedCount += 1
            playSound(name: "word-guessed")
            updateAfterWinOrLose()
        } else if wrongGuessesRemaining == 0 {
            gameStatusMessageLabel.text = "So sorry. You're all out of guesses."
            wordsMissedCount += 1
            updateAfterWinOrLose()
        }
        // check to see if you've used all the words. If so, update with a message indicating player can restart the entire game
        if currentWordIndex == wordToGuess.count {
            gameStatusMessageLabel.text! += "\n\nYou've tried all the words! Restart from beginning?"
        }
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        // this dismisses the keyboard
        updateUIAfterGuess()
    }
    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        // this dismisses the keyboard
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        // if all words have been guessed and you press playAgain, then restart all games as if the app has been restarted
        if currentWordIndex == wordsToGuess.count {
            currentWordIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0
        }
        
        playAgainButton.isHidden = true
        guessedLetterTextField.isEnabled = true
        guessLetterButton.isEnabled = false //don't turn true until a character appears in the text field
        wordToGuess = wordsToGuess[currentWordIndex]
        // create word with _ and blank spaces for each letter
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        guessCount = 0
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuesses)")
        lettersGuessed = ""
        gameStatusMessageLabel.text = "You've made Zero guesses"
        updateGameStatusLabels()
        
    }
    
    
}

