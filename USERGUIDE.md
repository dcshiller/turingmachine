# Turing Machine Simulator
## User's Guide

The program is intended for the creation and visualization of Turing Machines. This guide is split up into two sections, reflecting the two main functions of the simulator. The first section covers creating a Turing machine program. The second covers how to run your program. A general knowledge of how Turing machines work will be assumed. The unfamiliar are encouraged to consult [wikipedia](https://en.wikipedia.org/wiki/Turing_machine), the [Stanford Encyclopedia of Philosophy](http://plato.stanford.edu/entries/turing-machine/), or [Boolos, Burgess, and Jeffrey's](https://www.amazon.com/Computability-Logic-George-S-Boolos-ebook/dp/B00DO1HG40/ref=sr_1_1?ie=UTF8&qid=1471868584&sr=8-1&keywords=burgess+boolos+and+jeffrey) excellent introduction.

### Turing Machine Design


![Editor]
[Editor]: ./docs/Editor.png

The design menu presents the different machine states in the current program and the instructions that define those program states. The left hand panel presents all of the states in the machine. Each state is given a number for identification purposes, but these numbers don't reflect anything except that the first state in the program MUST be the state named 'One'.

No state may be deleted, but any state that is not part of the tree will be ignored when the program is saved or run.

Individual states can be accessed and modified through the right hand panel. In order to select a different state, the state names panel must be in focus. Focus can be toggled between the two panels with the enter key. When the State Names panel is in focus, one state will be highlighted red. This is the state that is currently selected, and which will be presented on the right. If the State Names panel is not in focus, this state name will instead be presented in red.

![EditorStates]
[EditorStates]: ./docs/EditorStates.png

New states can be created from the State Names panel with the 'new' item at the end of the list. Simply navigate with the down arrow to this item and press enter. A new state will be added and it will come into focus on the Program Instructions Panel.

![ProgramInstructions]
[ProgramInstructions]: ./docs/ProgramInstructions.png

The state presents what the machine is instructed to do if it sees an X or an O. The first line reflects X, the second O. The first part of the line indicates the machines behavioral response, the second indicates how the program evolves from there. Each may be toggled with a space bar.



Work In Progress!
