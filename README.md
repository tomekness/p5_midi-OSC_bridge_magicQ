# p5_midi-OSC_bridge_magicQ
**Midi-OSC Bridge for MagicQ  build in p5 (processing.org)**

- An Simple example on how to bridge an Midi-Input to an OSC-Output
- Midi-input in this example coming from an Behringer BCF2000
- outputting OSC to MagicQ (ChamSys) --> https://chamsyslighting.com/products/magicq
  (you need to be out of demo-mode to be able to use osc at MagicQ)


ChamSys MagicQ --> https://chamsyslighting.com/products/magicq


### p5 library requirments

- oscP5 by andreas schlegel --> https://www.sojamo.de/libraries/oscP5/
- theMidiButhems --> https://github.com/sparks/themidibus

### OSC Settings and Message formating  

Setting up OSC in MagicQ 

(IP Adress needs to match your device/computers IP)
![magicQ port settings](https://github.com/tomekness/p5_midi-OSC_bridge_magicQ/blob/main/images/Screen%20Shot%202022-08-05%20at%2012.01.01.png)

(RX/TX ports need to match ports in your p5 sketch (p5-TX = magixQ RX))
![magicQ settings](https://github.com/tomekness/p5_midi-OSC_bridge_magicQ/blob/main/images/Screen%20Shot%202022-08-05%20at%2012.01.01.png)


**For Further information see --> ChamSys MagicQ manual - Chapter 44. Open Sound Control (OSC) --> https://secure.chamsys.co.uk/help/documentation/magicq/osc.html**



### tool tip
  
  - OSC and MIDI - Controll and Test Utility --> https://hexler.net/protokol

-------

// 2022 | example based on examples by oscP5 and theMidiBus


