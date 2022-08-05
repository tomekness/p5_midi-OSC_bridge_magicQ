
// 

// for further information see --> https://github.com/tomekness/p5_midi-OSC_bridge_magicQ

/** 
 * An Simple example on how to bridge an Midi-Input to an OSC-Output
 *
 * Midi-input in this example coming from an Behringer BCF2000 
 * 
 * outputting OSC to MagicQ (ChamSys) --> https://chamsyslighting.com/products/magicq
 * (you need to be out of demo-mode to be able to use osc at MagicQ)
 * 
 * tested on Processing 3.3.7 
 *
 *
 * p5 library requirments
 * ------------------------
 * oscP5 by andreas schlegel --> https://www.sojamo.de/libraries/oscP5/ 
 * and theMidiButhems --> https://github.com/sparks/themidibus
 *
 * tool tip
 * -----------
 * OSC and MIDI - Controll and Test Utility --> https://hexler.net/protokol 
 *
 */

// example  by tomek_n | 2022 -- based on examples by oscP5 and theMidiBus

//Import the libraries

import oscP5.*;
import netP5.*;
import themidibus.*; 

OscP5 oscP5;
NetAddress myRemoteLocation;  // who to talk to 

MidiBus myBus;

boolean debug = true; // in debug mode we print some informations to the terminal

//////// buttons on my midi controller 
int[] button_midiNote = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

//////// what the buttons should do in MagicQ
String[] button_OSCcomand = {
  "/pb/1/flash", // flash button at fader 1 
  "/pb/2/flash", 
  "/pb/3/flash", 
  "/pb/4/flash", 
  "/pb/5/flash", 
  "/pb/6/flash", 
  "/pb/7/flash", 
  "/pb/8/flash", 
  "", 
  "/rpc/09H"  // clear 
};

////// fader at my midi controller 

int[] ccNums = {0, 1, 2, 3, 4, 5, 6, 7};

String[] ccIds = {
  "/pb/1", 
  "/pb/2", 
  "/pb/3", 
  "/pb/4", 
  "/pb/5", 
  "/pb/6", 
  "/pb/7", 
  "/pb/8"
};


int [] noteBolNums = {20, 21, 22, 23, 24, 25, 26, 27, 28, 29};

boolean [] noteBolState = {false, false, false, false, false, false, false, false, false, false};


int[] ccAtributeNums = {10, 11, 12, 13, 14, 15, 16, 17};

String[] ccAtributeIds = {
  "04", 
  "5", 
  "16", 
  "17", 
  "18", 
  "/pb/6", 
  "/pb/7", 
  "/pb/8", 
  "/rpc/07,04,10,1H", 
  "/rpc/08,04,10,1H", 
};


void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  // Either you can
  //                   Parent In Out
  //                     |    |  |
  //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  // or you can ...
  //                   Parent         In                   Out
  //                     |            |                     |
  //myBus = new MidiBus(this, "IncomingDeviceName", "OutgoingDeviceName"); // Create a new MidiBus using the device names to select the Midi input and output devices respectively.

  // or for testing you could ...
  //                 Parent  In        Out
  //                   |     |          |
  myBus = new MidiBus(this, 0, "Java Sound Synthesizer"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5("10.0.0.1", 9000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("10.0.0.1", 8000);
}

void draw() {
}

// Receive a noteOn
void noteOn(int channel, int pitch, int velocity) {
  // send an OSC command   
  NoteOnSendToMagicQ(channel, pitch, 127);
  if (debug) {
    print("Note On:");
    print("-----");
    print(" Channel:"+channel);
    print(" Pitch:"+pitch);
    println(" Velocity:"+velocity);
  }
}

void noteOff(int channel, int pitch, int velocity) {

  NoteOnSendToMagicQ(channel, pitch, 0);
  // Receive a noteOff
  if (debug) {
    print("Note Off:");
    print("----");
    print(" Channel:"+channel);
    print(" Pitch:"+pitch);
    println(" Velocity:"+velocity);
  }
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange    
  CCSendToMagicQ(channel, number, value);
  if (debug) {
    print("Controller Change:");
    print("---");
    print(" Channel:"+channel);
    print(" Number:"+number);
    print(" Value:"+value);
    println(" oscValue: " + int(value/1.27));
  }
}


void NoteOnSendToMagicQ( int _c, int _n, int _v) {
  
  // we are using buttons in two different ways, 
  //note 1–10 is just a button (e.g. flash-button)
  // note 20–30 is an internal boolean 
  //we are using the change the functionality of an potti on our midi controller  
  if (_n>=0 && _n<10) {
    for (int e=0; e<button_midiNote.length; e++ ) {
      if (_n == button_midiNote[e]) {
        OscMessage myMessage = new OscMessage(button_OSCcomand[e]);
        // add an value to the osc message 
        // midi command is between 0-127 
        // magicQ wants an int between 0-100
        myMessage.add(int(_v/1.27)); 
        // send the message 
        oscP5.send(myMessage, myRemoteLocation); 
        if (debug)println("send");
      }
    }
  } else if (_n>=20 && _n<30) {
    for (int e=0; e<noteBolNums.length; e++ ) {
      if (_n == noteBolNums[e]) {
        if (_v==127) {
          noteBolState[e]=true;
        } else {
          noteBolState[e]=false;
        }
        if (debug)println("send");
      }
    }
  }
}


void CCSendToMagicQ( int _c, int _n, int _v) {
  /* in the following different ways of creating osc messages are shown by example */
  if (_n>=0 && _n<10) {
    for (int e=0; e<ccNums.length; e++ ) {
      if (_n == ccNums[e]) {
        OscMessage myMessage = new OscMessage(ccIds[e]);
         // add an value to the osc message 
        // midi command is between 0-127 
        // magicQ wants an int between 0-100
        myMessage.add(int(_v/1.27)); 
        // send the message 
        oscP5.send(myMessage, myRemoteLocation); 
        if (debug)println("send");
      }
    }
  } else if (_n>=10 && _n<20) {
    for (int e=0; e<ccAtributeNums.length; e++ ) {
      if (_n == ccAtributeNums[e]) {
        String msg="";
        if (_v == 127) {
          msg += "/rpc/08," + ccAtributeIds[e];
        } else if (_v == 1) {
          msg += "/rpc/07," + ccAtributeIds[e];
        } 
        if (noteBolState[e]==true) {
          msg += ",10,1H";
        } else {
          msg += ",100,1H";
        }
        OscMessage myMessage = new OscMessage(msg);
         // add an value to the osc message 
        // midi command is between 0-127 
        // magicQ wants an int between 0-100
        myMessage.add(int(_v/1.27)); 
        // send the message 
        oscP5.send(myMessage, myRemoteLocation); 
        if (debug)println("send");
      }
    }
  }
}


void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
