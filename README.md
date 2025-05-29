
# Myth Madness

## Programming Patterns
### State Pattern
#### Keeps track of the state of the card in relation to the grabber since I wanted to implement a grabber class for this project. It helps determine if a card is being moved or is idle and can be picked up. It's also good for telling you as the player if the mouse if over a card which helps for displaying each card's information.

### Prototype Pattern
#### Each card in the game has shared attributes such as power, cost, description etc. Therefore, to create the specific cards that are seen in the game, each card is based on the prototype class and inherits the arributes and functions of the prototype class. Thsi helped streamline the process of adding new cards to the game.

### Feedback

## Postmortem
#### Overall, I think this project turned out reasonably well. I do wish to make some basic quality of life changes as well as attempt to make each card reveal incrementally after clicking the submit button, but lua doesn't necessarily have a sleep() function as other languages do so the process might be quite difficult. I also think that being able to serperate the functionality of my code into more files makes everything more modular and spreads out the amount of lines of code needed amongst multiople files instead of having to code all in one.

## Assets Used
### Card Assets: AI generated using ChatGPT
