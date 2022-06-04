/*c_asgn01.c
 *
 *      EE474 introductory C programming assignment #1
 *      Spring 2022
 *
 *     Student Name: Illya Kuzmych
 *
 */

/*  #include some system library function prototypes */
      //  we will use printf()
#include <stdio.h>
//  also get math function
#include <math.h>
#include <string.h>    // for strlen (ONLY)
#include <stdlib.h>    // for random()


#define LINUX            1
//#define VISUALC          1

#define         CARD_ERROR      (unsigned char) 0xFF  //  a value that cannot be a card
#define         N_DECK          52           // standard # of cards in a deck
// data types
typedef int           shuffle;
//typedef unsigned char hand[7];


/*  function prototypes for simplified printing functions */
void print_int(int);
void print_usi(unsigned int);
void print_newl();
void print_str(char*);
void print_chr(char);
void print_dble(double);


// solution functions

/**********************************************************************
                 All variable declarations
**********************************************************************/

int i,j,k;      // these make good loop iterators.
int card, suit;

//  Random number seed.
//      try  43227 (player 1 has 4 10s)
int seed = 1;
// Part 1.2
int t1, t2;


// Part 2.0

shuffle cards[N_DECK][2];

//  Part 2.2

unsigned char testhand[7]={0};


//Part 3.0

// Part 3.1

// Part 3.2

int dealer_deck_count = 0;  // how many cards have been dealt from a deck


// Part 3.3


/***********************************************************************
                      Function prototypes
**************************************************************************/
char* length_pad(char*, int);     // prob 1.4
int randN(int);                   // 2.1
void fill(shuffle[N_DECK][2]);             // 2.1
int check_arr(int currsize, int suit, int card, shuffle deck[N_DECK][2]); // part of 2.1
unsigned char convert(int card, int suit);  // 2.2
int valid_card(unsigned char card); // 2.2
int gcard(unsigned char card);   // 2.2
int gsuit(unsigned char card);   // 2.2
void names(int n, int j, char *answer);          // 2.3
void deal(int M, unsigned char hand[7], shuffle deck[N_DECK][2]);    // 3.2
void printhand(int M, unsigned char* hand, char* buff1);
int trip_s(int M, unsigned char hand[]);
int four_kind(int M, unsigned char hand[]);
int pairs(int M, unsigned char hand[]);


/**********************************************************************
                          main()
***********************************************************************/
int main()
{
/**
 *
 * PROBLEM 1,  C-Basics
 *
 */

// initialize random numbers.
//  change the seed for testing.  Use this value to compare results with
#ifdef VISUALC

#endif
#ifdef LINUX
// srandom(seed);
#endif
print_str("Random seed: "); print_int(seed); print_newl();
srand(5647);  // trips and a pair in hand 0 on my computer (full house 7s over 6s)

// 1.1  Write a code to print out the 10 integers between 1 and 10 on separate lines:
print_str("Problem 1.1 Test Results: \n");
//  1.1 test code here ...
for (int i = 1; i <= 10; i++) {
  printf("%d\n", i);
}

// 1.2 Modify 1.1 to print (after the 10 ints):
//   a) sum of the ints.  b) sum of the ints squared.

print_str("Problem 1.2 Test Results: \n");

//  1.2 code here ...

t1 = 0 ; t2 = 0;
for (int i = 1; i <= 10; i++) {
  printf("%d\n", i);
  t1 += i;
  t2 += i * i;
}

print_int(t1) ;  print_int(t2) ;   print_newl();

print_str("Problem 1.3 Test Results:\n");

char *l1 = "sum: ";
char *l2 = "sum of squares: ";

print_str(l1) ; print_int(t1) ; print_newl();
print_str(l2) ; print_int(t2) ; print_newl();


//  1.4

print_str("Problem 1.4 Test Results: \n");
print_str(length_pad(l1,20)) ; print_int(t1) ; print_newl();
print_str(length_pad(l2,20)) ; print_int(t2) ; print_newl();





/**
 * 2.0   Card games
 */

// 2.1

print_str("Problem 2.1 Test Results: ");    ; print_newl();

fill(cards);


// print out the random cards.
for(i=0;i<N_DECK;i++) {
    print_str(" [");
    print_int(cards[i][0]); print_str(" "); print_int(cards[i][1]) ;
    print_str("] ");
    if(!((i+1)%7)) print_newl();
    }
print_newl();


// 2.2

print_str("Problem 2.2  Test Results: ");  print_newl();

//  your code for convert() (2.2.a) below main.
print_str("   2.2.a"); print_newl();
// to test, lets fill a hand up with some cards:
testhand[0] = convert(5,2);
testhand[1] = convert(15,2); // Oops!   15 is invalid card #
testhand[2] = convert(12,1);
testhand[3] = convert(6,3);
testhand[4] = convert(-1,7);  // Hey!  both -1 and 7 are invalid
testhand[5] = convert(10,4);
testhand[6] = convert(3,3);

// Let's check them carefully!
for (i = 0; i < 7; i++){
    if (testhand[i] == CARD_ERROR) {
        print_str(" check 1 card error: ");
        print_int(i);
        print_newl();
    }
}



// new test hand
testhand[0] = convert(1,1);  // Ace of Hearts
testhand[1] = convert(1,2);  // Ace of Diamonds
testhand[2] = convert(1,3);  // Ace of Clubs
testhand[3] = convert(1,4);  // Ace of Spades
testhand[4] = convert(11,2); // Jack of Diamonds
testhand[5] = convert(12,2); // Queen of Diamonds
testhand[6] = convert(13,4); // King of Spades

int i;
for (i = 0; i < 7; i++) {
    if (testhand[i] == CARD_ERROR) {
        print_str(" check 2 card error: ");
        print_int(i); print_newl();
        exit(0);
    }
}



//  your code for convert() (2.2.a) below main.
print_str("   2.2.b"); print_newl();

unsigned char card1, card2;

card1 = 0xFF;  // an invalid card
card2 = convert(1,4); // ace of spades

if (valid_card(card1) == CARD_ERROR)
    print_str(" 0xFF is not a valid card\n");
else print_str(" Somethings wrong with 2.2.b\n");
if (valid_card(card2) == CARD_ERROR)
    print_str(" Somethings wrong with 2.2.b\n");
else print_str("8-bit version of Ace of Spades is a VALID card.\n");

//  your code for convert() (2.2.a) below main.
print_str("   2.2.c,d"); print_newl();


for (i = 0; i < 7; i++) {
   int card = gcard(testhand[i]);  //    This part tests 2.2c,d
   int suit = gsuit(testhand[i]);
   print_str("card: "); print_int(card); print_str("   suit: "); print_int(suit);print_newl();
}

/////////////////  Part 3

char buffer[] = "   *empty*       ";


//  your code for convert() (2.2.a) below main.
print_str("Part 3.1 Test Results:");print_newl();

for(i=0;i<7;i++) {
   card = gcard(testhand[i]);  //    This part tests 2.2c,d
   suit = gsuit(testhand[i]);
   print_str(" >>>>");
   print_int(i); print_str(": "); print_int(card);print_int(suit) ;
   names(card,suit,buffer); // convert card,suit to string name in buffer
   print_str(buffer);
   print_newl();
   }
print_newl();

/*
 *     Test Part 3.2
 */

print_str("Part 3.2 Test Results:");print_newl();
print_str("Test the deal() function\n");
char buff[20]="";
for (i=0;i<3;i++) {
    print_str("\n\n----testing deal: hand: "); print_int(i);print_newl();
    print_str("Deck count: ");print_int(dealer_deck_count); print_newl();
    deal(7,testhand,cards); // see Prob 2.1 for "cards"
    print_str("--------dealt hand: \n");
    printhand(7,testhand, buff);
    print_newl();
    }


/*
 *     Test Part 3.3
 */

print_str("Part 3.3 Test Results:");print_newl();
print_str("Test the finding pokerhands function(s).\n");
unsigned char hands[10][7];   //array of 10 hands


dealer_deck_count = 0; // reset to full deck (hands should reappear)

int n_hands = 7;

for (i = 0; i < n_hands; i++) {
    deal(7, hands[i], cards);
}
print_str(" I have ");print_int(n_hands); print_str(" new hands\n");

for (i = 0; i < n_hands; i++) {
   int pct = pairs(7,hands[i]);
   int trips = trip_s(7,hands[i]);
   int fourk = four_kind(7,hands[i]);
   printf("I found %d pairs in hand %d\n",pct,i);
   printf("I found %d three-of-a-kinds in hand %d\n",trips,i);
   printf("I found %d four-of-a-kinds in hand %d\n",fourk,i);
   printf("Hand %d:\n",i);
   printhand(7,hands[i],buff);
   print_newl();
}

#ifdef VISUALC
getchar();
return 0;
#endif

}  //  END OF MAIN



// Part 1.4
//  your function length_pad() here...

char* length_pad(char *st, int n) {
	char* newchar;
	if (n > strlen(st)) {
		newchar = (char*) malloc(n + 1); 
		for (int i = 0; i < strlen(st); i++) { // fill up new array with elements from original st
			newchar[i] = st[i];
	}

	for (int j = 0; j <= n - 2; j++) {
		newchar[strlen(st) + j] = ' ';
		newchar[n - 1] = '\0';
	}
	return newchar;
	
	} else if (n < strlen(st)) {
		
		for (int i = n; i <= strlen(st) - 1; i++) { // add spaces in replacement of old characters
			st[i] = ' ';
			if (i == strlen(st) - 1) {
			st[i] = '\0';
			}
		}
	} 

	return st;  // if n < strlen

}

//Part 2.1
// your function fill() here ...
void fill(shuffle deck[N_DECK][2]) {
   for (int i = 0; i <= 51; i++) {
		int card, suit;
		suit = randN(4); // generate a random suit
		card = randN(13); // generate a random card

		// while loop will check the current cards in the deck
		// to see if it can put in the current random #
		while (check_arr(i, suit, card, deck) == 1) {
			suit = rand() % 4 + 1; // generate a random suit
			card = rand() % 13 + 1; // generate a random card
		}
   deck[i][0] = card;
   deck[i][1] = suit;
   }
}

// helper function for fill
int check_arr(int currsize, int suit, int card, shuffle deck[N_DECK][2]) {
	for (int i = 0; i < currsize; i++) {
		if ((deck[i][0] == card) && (deck[i][1] == suit)) {
			return 1; 
		}
	}
	return 0; // to behave as else case for condition above in the function
}


// Part 2.2
//  your code for convert() here
/**
 * Convert two integers (from shuffle for example) into char as above
 * Top 4 bits represent card number (1 - 13)
 * Bottom 4 bits represent suit (1-4)
 * @return unsigned char of 8 bits
 */
unsigned char convert(int card, int suit) {
   unsigned char character;

   // shift the bottom 4 bits of card to overlap with top 4 bits of 
   // the character. 
   // Then, bitwise OR it with the bottom 4 bits being bitwise ANDed with suit bits

   character = (0xF0 & (card << 4)) | (0x0F & suit);

   if ((suit > 4) || (suit < 1) || (card > 13) || (card < 1)) {
      return CARD_ERROR;
   } 

   return character;
}


// Test if a card byte is a valid card
// NOTE TO SELF: seems as though valid_card is being used to compare. 
// NOT actually returning boolean TRUE or FALSE
int valid_card(unsigned char card) {
	int cardValues, suitValues;

	cardValues = (0xF0 & card) >> 4;
	suitValues = 0x0F & card;

	if ((suitValues > 4) || (suitValues < 1) || (cardValues > 13) || (cardValues < 1)) {
		return CARD_ERROR;
	}
	return 1; // if not CARD_ERROR
}

// your code for gsuit and gcard here
int gcard(unsigned char card) {
   int card_int;
   card_int = (0x00) | (card >> 4);

   if ((card_int > 13) || (card_int < 1)) {
      return CARD_ERROR;
   }
   return card_int;
}

int gsuit(unsigned char card) {
   int suit_int;
   
   suit_int = 0x0F & card; // bits: 00001111 & suit = 0000(suit)

   if ((suit_int > 4) || (suit_int < 1)) {
      return CARD_ERROR;
   }
   return suit_int;
}



//Part 3.1:
//  Your code for names() here

char * card_names[]={"Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"};
char * suit_names[]={"Hearts","Diamonds","Clubs","Spades"};

void names(int card, int suit, char *answer) {
   int i;
   int index = 0; // keep track of location in the string
	memset(answer, 0, strlen(answer));
   for (i = 0; i < strlen(card_names[card - 1]); i++) {
      answer[i] = card_names[card - 1][i];
      index++;
   }
   answer[index] = ' '; answer[index + 1] = 'o'; answer[index + 2] = 'f'; answer[index + 3] = ' '; // ' of ' 

   for (i = 0; i < strlen(suit_names[suit - 1]); i++) {
      answer[index + 4] = suit_names[suit - 1][i];
      index++;
   }
}


// Part 3.2

void deal(int M, unsigned char hand[7], int deck[N_DECK][2]) {
   for (int i = 0; i < M; i++) {
		hand[i] = convert(deck[dealer_deck_count][0], deck[dealer_deck_count][1]);
		dealer_deck_count++;
   }
}


/*
 * Print out a hand of cards
 */
void printhand(int M, unsigned char* hand, char* buff1) {
	for (int i = 0; i < M; i++) {
		names(gcard(hand[i]), gsuit(hand[i]), buff1);
		print_str(buff1);
		print_newl();
		memset(buff1, 0, strlen(buff1)); // reset buff
	}
}

int pairs(int M, unsigned char hand[]) { // 8 bits (top 4 represent card, bottom 4 represent suit)
	int pairCount = 0;
   int pairCheck = 0;
   int number[M];
   
   // fill in new array with card int values
   for (int i = 0; i < M; i++) {
      number[i] = (0x0F & (hand[i] >> 4));
   }
   
   for (int i = 1; i <= 13; i++) {
      for (int j = 0; j < M; j++) {
         if (number[j] == i) {
            pairCheck++;
         }
      }
      if (pairCheck == 2) {
         pairCount++;
      }
      pairCheck = 0;
   }
   return pairCount;
}

int trip_s(int M, unsigned char hand[]) {
   int tripsCount = 0;
   int tripsCheck = 0;
   int number[M];
   
   // fill in new array with card int values
   for (int i = 0; i < M; i++) {
      number[i] = (0x0F & (hand[i] >> 4));
   }
   
   for (int i = 1; i <= 13; i++) {
      for (int j = 0; j < M; j++) {
         if (number[j] == i) {
            tripsCheck++;
         }
      }
      if (tripsCheck == 3) {
         tripsCount++;
      }
      tripsCheck = 0;
   }
   return tripsCount;
}


int four_kind(int M, unsigned char hand[]) {
   int quadsCount = 0;
   int quadsCheck = 0;
   int number[M];
   
   // fill in new array with card int values
   for (int i = 0; i < M; i++) {
      number[i] = (0x0F & (hand[i] >> 4));
   }
   
   for (int i = 1; i <= 13; i++) {
      for (int j = 0; j < M; j++) {
         if (number[j] == i) {
            quadsCheck++;
         }
      }
      if (quadsCheck == 4) {
         quadsCount++;
      }
      quadsCheck = 0;
   }
   return quadsCount;
}


/**************************************************************************
  simplified I/O and other functions for this assignment
***************************************************************************/
void print_int(int x)
  {
  printf(" %d ",x);
  }
void print_usi(unsigned int x)
  {
  printf(" %d",x);
  }
void print_dble(double x)
  {
  printf(" %f",x);
  }
void print_newl()
  {
  printf("\n");
  }
void print_str(char *x)
  {
  printf("%s",x);
  }
void print_chr(char x)
  {
  printf("%c",x);
  }

int randN(int n)   //  return a random integer between 1 and n
  {
  double x;
  x = 1.0 + (double) n * rand() / RAND_MAX;
  return ((int) x);
  }
