
# Myth Madness

## Programming Patterns
### State Pattern
#### Keeps track of the state of the card in relation to the grabber since I wanted to implement a grabber class for this project. It helps determine if a card is being moved or is idle and can be picked up. It's also good for telling you as the player if the mouse if over a card which helps for displaying each card's information.

### Prototype Pattern
#### Each card in the game has shared attributes such as power, cost, description etc. Therefore, to create the specific cards that are seen in the game, each card is based on the prototype class and inherits the arributes and functions of the prototype class. Thsi helped streamline the process of adding new cards to the game.

### Feedback

## Postmortem
#### Overall, I think this project turned out reasonably well. I do wish to make some basic quality of life changes as well as attempt to make each card reveal incrementally after clicking the submit button, but lua doesn't necessarily have a sleep() function as other languages do so the process might be quite difficult. I also think that being able to serperate the functionality of my code into more files makes everything more modular and spreads out the amount of lines of code needed amongst multiple files instead of having to code all in one. This was something that I was able to do earlier on in this project compared to the solitaire game where I had a lot of functionality in 1 file which hurt readability. I also think I was able to use enums where appropriate in order to avoid string comparison which could lead to potential bugs. If I had to do this project again, I would try and make a better submit play function that would allow me to make the overall turn structure better visually. Since I was implementing this game in pieces, I think that implementing those pieces in a different order might be better for me in the long run. Lastly, I would maybe try and rebalance the cards so make the game last longer.

## Assets Used
### Card Assets: AI generated using ChatGPT

## Note to Grader
### Points are only calculated if there are cards in opposite locations. If there are cards in one player's location, but not in the opponent's location points are not granted. The AI plays cards into a random pile, so it prevents the game from ending early.
