# Myth Madness

## Programming Patterns
### State Pattern
#### Keeps track of the state of the card in relation to the grabber since I wanted to implement a grabber class for this project. It helps determine if a card is being moved or is idle and can be picked up. It's also good for telling you as the player if the mouse if over a card which helps for displaying each card's information.

### Prototype Pattern
#### Each card in the game has shared attributes such as power, cost, description etc. Therefore, to create the specific cards that are seen in the game, each card is based on the prototype class and inherits the attributes and functions of the prototype class. This helped streamline the process of adding new cards to the game.

### Flyweight Pattern
#### Only one instance of usage in this project, but this pattern was used for loading file images for cards. Since, for example, cards share a back image, the file only needed to be loaded once instead of each time a new card is created. Since there are 20 cards in the deck, this cuts a lot of the repeated work to only what is needed.

## Assets Used
### Card Assets: AI generated using ChatGPT

## Note to Grader
### Points are only calculated if there are cards in opposite locations. If there are cards in one player's location, but not in the opponent's location points are not granted. The AI plays cards into a random pile, so it prevents the game from ending early.

### New feature for incremental card reveal. The button at the center of the screen seperates opponent turn, flipping cards, and calculating scores. You must press this button to progress the game.

## Sources Cited
### Vector class developed by Zac Emerzian
