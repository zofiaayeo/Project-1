{
  Project: EE-9 Sensor Control
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Zofia
  Date: 29th Nov 2021
  Log:
    Date: Desc
}

CON
'        _clkmode = xtal1 + pll16x          'Standard clock mode * crystal frequency = 80 MHz
'        _xinfreq = 5_000_000                'clkfreq = 1 sec, clkfreq/2
'        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
'        _Ms_001 = _ConClkFreq / 1_000

        ''[Declare Pins for Sensors]
        'Ultrasonic 1 Front
        frontscl1 = 6
        frontsda1 = 7

        'Ultrasonic 3 Back
        backscl2 =  8
        backsda2 =  9

        'Time of Flight 1
        tof1SCL = 0
        tof1SDA = 1
        tof1RST = 14

        'Time of Flight 2
        tof2SCL = 2
        tof2SDA = 3
        tof2RST = 15

        tofAdd = $29

VAR     'Global variable
  long cogIDNum, cogStack[128]
  long _Ms_001

OBJ

  Ultra     : "EE-7_Ultra_v2.spin"
  ToF[2]    : "EE-7_TOF.spin"

PUB Start(mainMSVal, mainTof1Add, mainTof2Add, mainUltra1Add, mainUltra2Add)

  _Ms_001 := mainMSVal

  Stop

  cogIDNum := cognew(sensorCore(mainTof1Add, mainTof2Add, mainUltra1Add, mainUltra2Add), @cogStack)

  return

PUB Stop

  if cogIDNum
    cogstop (cogIDNum~)

PUB Sensorcore(mainTof1Add, mainTof2Add, mainUltra1Add, mainUltra2Add)

   Ultra.Init(frontscl1, frontsda1, 0)
   Ultra.Init(backscl2, backsda2, 1)

  tofInit

  repeat
    long[mainUltra1Add] := Ultra.readSensor(0)
    long[mainUltra2Add] := Ultra.readSensor(1)
    long[mainToF1Add] := ToF[0].GetSingleRange(tofadd)
    long[mainToF2Add] := ToF[1].GetSingleRange(tofadd)
    Pause(50)

PRI tofInit | i

  Tof[0].Init(tof1SCL,tof1SDA,tof1RST)
  Tof[0].ChipReset(1)
  Pause(1000)
  Tof[0].FreshReset(tofAdd)
  Tof[0].MandatoryLoad(tofAdd)
  Tof[0].RecommendedLoad(tofAdd)
  Tof[0].FreshReset(tofAdd)

  Tof[1].Init(tof2SCL,tof2SDA,tof2RST)
  Tof[1].ChipReset(1)
  Pause(1000)
  Tof[1].FreshReset(tofAdd)
  Tof[1].MandatoryLoad(tofAdd)
  Tof[1].RecommendedLoad(tofAdd)
  Tof[1].FreshReset(tofAdd)

  return

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt (t += _Ms_001)
  return