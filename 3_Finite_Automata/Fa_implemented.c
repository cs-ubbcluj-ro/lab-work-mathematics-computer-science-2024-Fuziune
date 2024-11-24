#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STATES 100
#define MAX_ALPHABET 10
#define MAX_TRANSITIONS 100

// Structure to represent a transition in the DFA
typedef struct {
    char state[10];  // State name
    char symbol;     // Symbol from the alphabet
    char nextState[10];  // Next state
} Transition;

// Structure to represent the DFA
typedef struct {
    char states[MAX_STATES][10];  // Array to hold the states
    int numStates;
    char alphabet[MAX_ALPHABET];  // Array to hold the alphabet
    int numSymbols;
    Transition transitions[MAX_TRANSITIONS];  // Transition table
    int numTransitions;
    char finalStates[MAX_STATES][10];  // Final states
    int numFinalStates;
} DFA;

// Function to read the DFA from a file
int readDFA(const char *filename, DFA *dfa) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Error opening file!\n");
        return -1;
    }

    // Read states
    fscanf(file, "States: ");
    char buffer[100];
    fgets(buffer, 100, file);
    char *state = strtok(buffer, ", ");
    while (state != NULL) {
        strcpy(dfa->states[dfa->numStates], state);
        dfa->numStates++;
        state = strtok(NULL, ", ");
    }

    // Read alphabet
    fscanf(file, "Alphabet: ");
    fgets(buffer, 100, file);
    char *symbol = strtok(buffer, ", ");
    while (symbol != NULL) {
        dfa->alphabet[dfa->numSymbols] = symbol[0];  // Only first character
        dfa->numSymbols++;
        symbol = strtok(NULL, ", ");
    }

    // Read transitions
    fscanf(file, "Transitions: ");
    fgets(buffer, 100, file);
    char *transition = strtok(buffer, ", ");
    while (transition != NULL) {
        sscanf(transition, "%[^-]->%c->%s", dfa->transitions[dfa->numTransitions].state,
               &dfa->transitions[dfa->numTransitions].symbol,
               dfa->transitions[dfa->numTransitions].nextState);
        dfa->numTransitions++;
        transition = strtok(NULL, ", ");
    }

    // Read final states
    fscanf(file, "Final States: ");
    fgets(buffer, 100, file);
    state = strtok(buffer, ", ");
    while (state != NULL) {
        strcpy(dfa->finalStates[dfa->numFinalStates], state);
        dfa->numFinalStates++;
        state = strtok(NULL, ", ");
    }

    fclose(file);
    return 0;
}

// Function to print DFA components
void printDFA(DFA *dfa) {
    printf("States: ");
    for (int i = 0; i < dfa->numStates; i++) {
        printf("%s ", dfa->states[i]);
    }
    printf("\n");

    printf("Alphabet: ");
    for (int i = 0; i < dfa->numSymbols; i++) {
        printf("%c ", dfa->alphabet[i]);
    }
    printf("\n");

    printf("Transitions:\n");
    for (int i = 0; i < dfa->numTransitions; i++) {
        printf("%s -> %c -> %s\n", dfa->transitions[i].state,
               dfa->transitions[i].symbol,
               dfa->transitions[i].nextState);
    }

    printf("Final States: ");
    for (int i = 0; i < dfa->numFinalStates; i++) {
        printf("%s ", dfa->finalStates[i]);
    }
    printf("\n");
}

// Function to verify if a string is accepted by the DFA
int verifyString(DFA *dfa, const char *input) {
    char currentState[10];
    strcpy(currentState, dfa->states[0]);  // Start state is the first state

    for (int i = 0; input[i] != '\0'; i++) {
        char symbol = input[i];
        int transitionFound = 0;

        for (int j = 0; j < dfa->numTransitions; j++) {
            if (strcmp(dfa->transitions[j].state, currentState) == 0 &&
                dfa->transitions[j].symbol == symbol) {
                strcpy(currentState, dfa->transitions[j].nextState);
                transitionFound = 1;
                break;
            }
        }

        if (!transitionFound) {
            return 0;  // Invalid transition
        }
    }

    // Check if current state is a final state
    for (int i = 0; i < dfa->numFinalStates; i++) {
        if (strcmp(currentState, dfa->finalStates[i]) == 0) {
            return 1;
        }
    }

    return 0;
}

int main() {
    DFA dfa;
    dfa.numStates = 0;
    dfa.numSymbols = 0;
    dfa.numTransitions = 0;
    dfa.numFinalStates = 0;

    if (readDFA("C:/Users/ioan1/Desktop/Oies/Tema3LFTC/FA.in.txt", &dfa) != 0) {
        return -1;
    }

    printDFA(&dfa);

    char input[100];
    printf("Enter a string to verify: ");
    scanf("%s", input);

    if (verifyString(&dfa, input)) {
        printf("The string is accepted by the DFA.\n");
    } else {
        printf("The string is not accepted by the DFA.\n");
    }

    return 0;
}
