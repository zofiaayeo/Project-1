{
  Project: EE-9 Motor
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Zofia
  Date: 29th Nov 2021
  Log:
    Date: Desc
}

CON

  _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
  _xinfreq = 5_000_000

  ' Creating a Pause()
  _ConClickFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _MS_001 = _ConClickFreq / 1_000

  ' Declare Pins for Motors
  motor1 = 10
  motor2 = 11
  motor3 = 12
  motor4 = 13

  ' Declare Zero Speed for Motors
  'motor1Zero = 2000
  'motor2Zero = 1800
  'motor3Zero = 1800
  'motor4Zero = 1800
        motor1Zero = 1520
        motor2Zero = 1520
        motor3Zero = 1520
        motor4Zero = 1520

VAR

  long MovementCoreStack[64]
  long cogIDM

OBJ ' Objects

  Motors  : "Servo8Fast_vZ2.spin"


PUB Init

  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(500)
'  StopAllMotors

PUB Movement (Move)
  Stop
  case Move
    1:
      cogIDM := cognew(Forward(-600), @MovementCoreStack)
      'Pause(250)
    2:
      cogIDM := cognew(Reverse(20), @MovementCoreStack)
      'Pause(250)
    3:
     cogIDM := cognew(StopAllMotors, @MovementCoreStack)
     'Pause(250)
    4:
     cogIDM := cognew(TurnLeft(40), @MovementCoreStack)
     'Pause(250)
    5:
     cogIDM := cognew(TurnRight(40), @MovementCoreStack)

PUB Set (motor, speed)

  case motor
    motor1:
      speed += motor1Zero
      Motors.Set(motor1, speed)
    motor2:
      speed += motor2Zero
      Motors.Set(motor2, speed)
    motor3:
      speed += motor3Zero
      Motors.Set(motor3, speed)
    motor4:
      speed += motor4Zero
      Motors.Set(motor4, speed)

PUB Stop

  if cogIDM
    cogstop(cogIDM~)

PUB StopAllMotors

  Set(motor1, motor1Zero)
  Set(motor2, motor2Zero)
  Set(motor3, motor3Zero)
  Set(motor4, motor4Zero)

PUB Forward (speed)

  Set(motor1, +speed)
  Set(motor2, +speed)
  Set(motor3, +speed)
  Set(motor4, +speed)

PUB Reverse (speed)

  Set(motor1, -40)
  Set(motor2, -40)
  Set(motor3, -40)
  Set(motor4, -40)

PUB TurnLeft (speed)

  Set(motor1, +speed)
  Set(motor2, -600)
  Set(motor3, +speed)
  Set(motor4, -600)

PUB TurnRight (speed)

  Set(motor1, -600)
  Set(motor2, +speed)
  Set(motor3, -600)
  Set(motor4, +speed)

PRI Pause(ms) | t

  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _MS_001)
  return