import UIKit
import Foundation

var myName = "Korn Dogg"
var smallerString = "lol"

//contains
if myName.contains(smallerString) {
    print("\(myName) contains \(smallerString)")
} else {
    print("There is no \(smallerString) in \(myName)")
}

//hasPrefix + hasSuffix

var occupation = "Swift Developer"
var searchString = "Swift"

//print(occupation.hasPrefix(searchString))
print("\nPREFIX SEARCH")

if occupation.hasPrefix(searchString) {
    print("Great! You are hired!")
} else {
    print("No job for you.")
}

print("\nSUFFIX SEARCH")
occupation = "iOSDeveloper"
searchString = "Developer"

if occupation.hasSuffix(searchString) {
    print("Great! You are hired! We need more \(occupation)")
} else {
    print("No job for you.")
}
//.removeLast()
print("\nREMOVE")

var bandName = "The White Stripes"
var lastChar = bandName.removeLast()
print("After we remove \(lastChar) the band is just \(bandName)")

//.removeFirst(k: Int)
print("\nREMOVE FIRST #")
var person = "Dr. Nick"
let title = "Dr. "
person.removeFirst(title.count)
print(person)

//.replacingOccurences(of: with:)
print("\nREPLACING OCCURANCES OF")

//123 James St.
//123 James St
//123 James Street

var address = "123 James St."
var streetString = "St."
var replacementString = "Street"

var standardAddress = address.replacingOccurrences(of: streetString, with: replacementString)
print(standardAddress, address)

//Iterate Through a String
print("\nBACKWARDS STRING")

var name = "Korn Dogg"
var backwardsName = ""
for letter in name {
    backwardsName = String(letter) + backwardsName
}
print(name, backwardsName)

var newBackwardsName = ""
for letter in name.reversed() {
    newBackwardsName += String(letter)
}
print(name, newBackwardsName)

//Capitalization
print("\nPLAYING WITH CAPS")
var crazyCaps = "SWifT DeVElOpeR"
var uppercase = crazyCaps.uppercased()
var lowercase = crazyCaps.lowercased()
var capitalize = crazyCaps.capitalized

print(crazyCaps)
print(uppercase,lowercase,capitalize)

//Word Gardens Challenge
//Set up wordToGuess and revealedWord

var wordToGuess = "SWIFT"
var revealedWord = ""
for _ in wordToGuess {
    revealedWord += "_ "
}
revealedWord.removeLast()
print("SWIFT will show as '\(revealedWord)'")

// Create a String From a Repeating Value
revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
print("SWIFT will show as '\(revealedWord)'")

//Word Garden Challenge
//Set up revealerWord after lettersGuessed
wordToGuess = "SWIFT"
revealedWord = ""
var lettersGuessed = "SQFTX"

// iterate through all letters in wordToGuess
for letter in wordToGuess {
    // check to see if letter in Words Guessed is in lettersGuessed
    if lettersGuessed.contains(letter) {
        //if so add letter to revealedWord with a blank space
        revealedWord = revealedWord + "\(letter) "
    } else {
        //if not add _ and blank space
        revealedWord = revealedWord + "_ "
    }
}

print("Word to guess is: \(wordToGuess)")
print("Letters guessed are: \(lettersGuessed)")
print("What is shown is: \(revealedWord)")
