/* Lab4_Project.ino
 * @file   Lab4_Project.ino
 *   @author    Ruvim Piholyuk, Illya Kuzmych
 *   @date      7-June-2022
 *   @brief   Final project for EE 474
 *   
 *  Lab4_Project.ino demonstrates our working prototype utilizing an ultrasonic sensor
 *  and external LED/buzzer to behave as failsafe proximity sensor
 *  
 *  To successfully build our project we needed to utilize two peripherals we have not in the past:
 *  A buzzer and an ultrasonic sensor. We utilized the ultrasonic sensor to constantly run and read data
 *  and update the blink and buzzer rates based on closer/farther distances from any hazard
 *  Pin 45 was the output of the buzzer which was set to high or low, and Pin 47 was the output of the LED
 *  
 *  
 *  Pin 9 is to read in the echo from the ultrasonic sensor, while Pin 10 is to set trigger to high
 *  Every task runs at the maximum tick rate allowed by freeRTOS (15 ms)
 *  The lights update corresponding to the delay within, so the system transitions more smoothly from close to farther distances
 *  than from farther to closer distances
 */

#include <Arduino_FreeRTOS.h> ///< include the freeRTOS library

#define ECHOPIN 10 ///< input pin for the echo from the ultrasonic sensor
#define TRIGPIN 9 ///< output pin for the trigger on the ultrasonic sensor
#define INPUT_PORT_B4 (~(1 << DDB4)) ///< set Port B4 to be an input port
#define OUTPUT_PORT_H6 (1 << DDH6) ///< set Port H6 to be an output port
#define OUTPUT_PORT_L2 (1 << DDL2) ///< set Port L2 to be an output port
#define OUTPUT_PORT_L4 (1 << DDL4) ///< set Port L4 to be an output port

// Constants for the bitwise operations to turn on/off the LED and the buzzer
#define TURN_OFF_LED (~(1 << PORTL2)) ///< bitwise operation to set PORTL2 to low
#define TURN_ON_LED (1 << PORTL2) ///< bitwise operation to set PORTL2 to high
#define TURN_ON_BUZZER (1 << PORTL4) ///< bitwise operation to set PORTL4 to high
#define TURN_OFF_BUZZER (~(1 << PORTL4)) ///< bitwise operation to set PORTL4 to low


// Constants for LED and buzzer rates
#define SIX_FEET 72 ///< 72 inches
#define FIVE_FEET 60 ///< 60 inches
#define FOUR_FEET 48 ///< 48 inches
#define THREE_FEET 36 ///< 36 inches
#define TWO_FEET 24 ///< 24 inches
#define ONE_FEET 12 ///< 12 inches


// Global variables
long duration; ///< tracks the duration for the echo to reach the object and back to the sensor
int distance; ///< variable to hold distance based on the duration for the signal to travel

/**
 * main block to initialize all ports and create tasks in freeRTOS
 *
 */
void setup() {
  Serial.begin(9600);

  // 
  DDRL |= OUTPUT_PORT_L2; ///< Set port L2 to output
  DDRH |= OUTPUT_PORT_H6; ///< Set Port H6 to output
  DDRB &= INPUT_PORT_B4; ///< set Port B4 to input
  DDRL |= OUTPUT_PORT_L4; ///< Set Port L4 to output

  xTaskCreate(
    readData
    ,  "Read the Sensor Data"   // A name just for humans
    ,  1024
    ,  NULL
    ,  3  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL );

  xTaskCreate(
    ledWarning
    ,  "Adjustor for LED blink rate"   // A name just for humans
    ,  512
    ,  NULL
    ,  3  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL );

  xTaskCreate(
    buzzerWarning
    ,  "Buzzer sound"
    ,  512
    ,  NULL
    ,  3  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
    ,  NULL );
    
}

void loop() {
  // does nothing 
}

/**
 * Method responsible for reading data from the ultrasonic sensor
 *
 * @param *pvParameters pointer to NULL parameter
 */
void readData(void *pvParameters) {
  for (;;) {
    PORTH &= ~(1 << PORTH6);
    vTaskDelay( 1 / portTICK_PERIOD_MS );
    PORTH |= 1 << PORTH6;
    vTaskDelay(5 / portTICK_PERIOD_MS );
    PORTH &= ~(1 << PORTH6);
  
    duration = pulseIn(ECHOPIN, HIGH);
    distance = (duration * 0.034 / 2) / 2.54; // distance in inches
    Serial.print("Distance: ");
    Serial.println(distance); 
  }
}


/**
 * Method responsible for controlling the blink rate of the LED
 *
 * @param *pvParameters pointer to NULL parameter
 */
void ledWarning(void *pvParameters) {
  int delayTime;
  
  for (;;) {
    if (distance > SIX_FEET) {
      delayTime = 10000;
    } 
    
    else if (distance > FIVE_FEET) { ///< between 5 and 6 feet
      delayTime = 1500;
    } 
    
    else if (distance > FOUR_FEET) { ///< between 5 and 6 feet
      delayTime = 1250;
    } 
    
    else if (distance > THREE_FEET) { ///< between 5 and 6 feet
      delayTime = 1000;
    } 
    
    else if (distance > TWO_FEET) { ///< between 5 and 6 feet
      delayTime = 750;
    } 
    
    else if (distance > ONE_FEET) { ///< between 5 and 6 feet
      delayTime = 250;
    } 
    
    else {
      delayTime = 100;
    }

    if (delayTime > 2000) {
      PORTL &= TURN_OFF_LED;
    } else {
      PORTL |= TURN_ON_LED;
      vTaskDelay(delayTime / portTICK_PERIOD_MS); // on for 2 secs, off for 2 secs
    }

    if (distance > SIX_FEET) {
      delayTime = 10000;
    } 
    
    else if (distance > FIVE_FEET) { ///< between 5 and 6 feet
      delayTime = 1500;
    } 
    
    else if (distance > FOUR_FEET) { ///< between 5 and 6 feet
      delayTime = 1250;
    } 
    
    else if (distance > THREE_FEET) { ///< between 5 and 6 feet
      delayTime = 1000;
    } 
    
    else if (distance > TWO_FEET) { ///< between 5 and 6 feet
      delayTime = 750;
    } 
    
    else if (distance > ONE_FEET) { ///< between 5 and 6 feet
      delayTime = 250;
    } 
    
    else {
      delayTime = 100;
    }

    if (delayTime > 2000) {
      PORTL &= TURN_OFF_LED;
    } else {
      PORTL &= TURN_OFF_LED;
      vTaskDelay(delayTime / portTICK_PERIOD_MS);
    }
  }
}

/**
 * Method responsible for controlling the buzz rate of the speaker
 *
 * @param *pvParameters pointer to NULL parameter
 */
void buzzerWarning(void *pvParameters) {
  int delayTime;
  
  for (;;) {
    if (distance > THREE_FEET) {
      delayTime = 10000;
    }
    
    else if (distance > TWO_FEET) { ///< between 5 and 6 feet
      delayTime = 750;
    } 
    
    else if (distance > ONE_FEET) { ///< between 5 and 6 feet
      delayTime = 250;
    }
    
    else {
      delayTime = 100;
    }

    if (delayTime > 750) {
      PORTL &= TURN_OFF_BUZZER;
    } else {
      PORTL |= TURN_ON_BUZZER;
      vTaskDelay(delayTime / portTICK_PERIOD_MS); // on for 2 secs, off for 2 secs
    }
    
    if (distance > THREE_FEET) {
      delayTime = 10000;
    }
    
    else if (distance > TWO_FEET) { ///< between 5 and 6 feet
      delayTime = 750;
    } 
    
    else if (distance > ONE_FEET) { ///< between 5 and 6 feet
      delayTime = 250;
    }
    
    else {
      delayTime = 100;
    }
    
      if (delayTime > 750) {
      PORTL &= TURN_OFF_BUZZER;
    } else {
      PORTL &= TURN_OFF_BUZZER;
      vTaskDelay(delayTime / portTICK_PERIOD_MS);
  }
}
}
