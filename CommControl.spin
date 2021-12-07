{
  Project: EE-9 Comm Control
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Zofia
  Date: 29th Nov 2021
  Log:
    Date: Desc
}

CON

  commRxPin = 20
  commTxPin = 21
  commBaud  = 9600

  commStart     = $7A
  commForward   = $01
  commReverse   = $02
  commTurnLeft  = $03
  commTurnRight = $04
  commStopAll   = $AA

  forward    = 1
  reverse    = 2
  stopall    = 3
  turnleft   = 4
  turnright  = 5

VAR     'Global variable
long cogIDCom, comStack[128]
long _Ms_001

OBJ

  Comm      : "FullDuplexSerial.spin"

PUB Start(mainMSVal, value)

  _Ms_001 := mainMSVal

  Stop

  cogIDCom := cognew(Manual(value), @comStack)

  return

PUB Stop

  if cogIDCom
    cogstop (cogIDcom~)

PUB Manual (value)

  Comm.Start(commTxPin, commRxPin, 0, commBaud)
  Pause(2000)

  repeat
    value := Comm.Rxcheck
    if value == CommStart
      value := Comm.Rx
      case value
          commForward:
              long[value] := forward

          commReverse:
              long[value] := reverse

          commTurnLeft:
              long[value] := turnleft

          commTurnRight:
              long[value] := turnright

          commStopAll:
               long[value] := stopall

PRI Pause(ms) | t

  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _MS_001)
  return