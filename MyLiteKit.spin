{
  Project: EE-9 MyLiteKit
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Zofia
  Date: 29th Nov 2021
  Log:
    Date: Desc
}

CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  'Creating a Pause()
  _ConClickFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _MS_001 = _ConClickFreq / 1_000

VAR

  long  ToFFront, ToFBack, UltraFront, UltraBack
  long  signal

OBJ

  'Term      : "FullDuplexSerial.spin"     'UART Communication
  Sensor    : "SensorControl.spin"        'Object / Blackbox
  Motor     : "MotorControl.spin"         'Motor Movement
  Comm      : "CommControl.spin"          'For Remote Control

PUB Main    | rxValue

  'Declaration & Initialization
  'Term.Start(31, 30, 0, 115200)
  Motor.Init

  Sensor.Start(_Ms_001, @ToFFront, @ToFBack, @UltraFront, @UltraBack)
  Comm.Start(_Ms_001, @signal)
  Pause(1000)     'Buffer
  {
  Motor.Movement(1)
  Pause(3000)
  Motor.Movement(3)
  Pause(3000)
  Motor.Movement(2)
  Pause(3000)
  Motor.Movement(3)
  Pause(3000)
  Motor.Movement(4)
  Pause(3000)
  Motor.Movement(3)
  Pause(3000)
  Motor.Movement(5)
  Pause(3000)
  Motor.Movement(3)
  Pause(3000)
  }
  'Run & get readings
  repeat
    Pause(50)
   ' term.str(string(13))
    'term.dec(signal)
    case Signal
      1:
         if (ToFFront > 250) | (UltraFront < 300)
           Motor.Movement(3)
           Pause(1000)
         else
           Motor.Movement(1)                                  'Move forward

      2:
         if (ToFBack > 250) | (UltraBack < 300)
           Motor.Movement(3)
           Pause(1000)
         else
           Motor.Movement(2)                                  'Move backwards

      3:
        Motor.Movement(3)                                      'Stops all motors
        Pause(1000)

      4:
        if (ToFFront > 250) | (UltraFront < 300) | (ToFBack > 250) | (UltraBack < 300)
          Motor.Movement(3)
          Pause(1000)
        else
          Motor.Movement(4)                                    'Turn Left

      5:
        if (ToFFront > 250) | (UltraFront < 300) | (ToFBack > 250) | (UltraBack < 300)
          Motor.Movement(3)
          Pause(1000)
        else
          Motor.Movement(5)                                    'Turn Right

PRI Pause(ms) | t

  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _MS_001)
  return