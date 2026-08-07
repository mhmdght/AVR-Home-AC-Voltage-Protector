'*****************************************************
' Voltage Protector for Attiny25
' 220
' Code By Mohammad Ghaffari
' https://github.com/mhmdght
'*****************************************************

$regfile = "attiny25.dat"
$crystal = 8000000
$hwstack = 40
$swstack = 16
$framesize = 32

' ========== Configs ===========

' ---------- Pin Configuration ----------
Config PinB.0 = Output          ' Relay
Config PinB.1 = Output          ' Red LED
Config PinB.2 = Output          ' Yellow LED
Config PinB.3 = Output          ' Green LED
Config PinB.4 = Input           ' Voltage sensor (ADC2)

' ---------- ADC Setup ----------
Config Adc = Single , Prescaler = Auto , Reference = INTERNAL_1.1

' ---------- Variables ----------
Dim Vwarn As Bit                ' 0=Normal, 1=Warning
Dim Vsafe As Bit                ' 0=Unsafe, 1=Safe
Dim Adcval As Word              ' Raw ADC value
Dim wait_timer As Integer       ' Initial or Recovery Wait
wait_timer = 20                   ' Delay Timer

' Thresholds (based on 1.1V ref & 10K+1K divider)
' 1.065V -> 990, 0.795V -> 736
Const High_threshold = 990
Const Low_threshold = 736






' ============== Start of Program ==============
Init:
   ' Disable relay at startup
   Reset PortB.0                ' Relay OFF

   ' First voltage check
   Adcval = Getadc(2)           ' Read ADC2 (PB4)
   If Adcval >= High_threshold Or Adcval <= Low_threshold Then
      Vsafe = 0                 ' Voltage OVER/UNDER
      Vwarn = 1                 ' Set warning status immediately
      Goto Main_loop            ' Main loop will handle warning via Warning_state
   Else
      Vsafe = 1                 ' Voltage Safe
      Vwarn = 0
   End If

   ' If safe, go to initial wait
   Goto Wait_init

' ---------- Initial Wait (Delay) ----------
Wait_init:
   Vwarn = 0                    ' Clear warning flag (already 0 but safe)
   Set PortB.2                  ' Yellow LED ON
   Wait wait_timer              ' Delay Timer

   ' Re-check voltage after wait
   Adcval = Getadc(2)
   If Adcval >= High_threshold Or Adcval <= Low_threshold Then
      Vsafe = 0
      Vwarn = 1                 ' Set warning flag
   Else
      Vsafe = 1
      Vwarn = 0                 ' Ensure flag is clear
   End If

   ' Go to main loop; if voltage still unsafe it will enter Warning_state
   Goto Main_loop

' ============== Main Loop ==============
Main_loop:
   ' Check voltage every cycle
   Adcval = Getadc(2)
   If Adcval >= High_threshold Or Adcval <= Low_threshold Then
      Vsafe = 0
   Else
      Vsafe = 1
   End If

   ' State decision
   If Vsafe = 1 And Vwarn = 0 Then Goto Normal_state
   If Vsafe = 1 And Vwarn = 1 Then Goto Wait_state
   Goto Warning_state           ' All other cases -> unsafe

' ---------- Normal Operation ----------
Normal_state:
   Reset PORTB.2                ' Yellow OFF
   Reset PORTB.1                ' Red OFF
   Set PORTB.3                  ' Green ON
   Set PORTB.0                  ' Relay ON (enable AC)
   Goto Main_loop

' ---------- Recovery Wait (from warning) ----------
Wait_state:
   Vwarn = 0                    ' Remove warning flag
   Set PORTB.2                  ' Yellow ON
   Wait wait_timer              ' Delay Timer

   ' Check voltage after wait
   Adcval = Getadc(2)
   If Adcval >= High_threshold Or Adcval <= Low_threshold Then
      Vsafe = 0
      Vwarn = 1                 ' Still unsafe ? set warning again
      Goto Warning_state        ' Directly go to warning
   Else
      Vsafe = 1
   End If
   Goto Main_loop               ' Safe & continue main loop

' ---------- Warning Output (unified) ----------
Warning_state:
   Vwarn = 1                    ' Set warning flag
   Reset PORTB.0                ' Relay OFF
   Set PORTB.2                  ' Yellow ON
   Set PORTB.1                  ' Red ON
   Reset PORTB.3                ' Green OFF
   Waitms 200                   ' Red LED on for 200 ms
   Reset PORTB.1                ' Red OFF
   Waitms 100                   ' Red LED off for 100 ms
   Goto Main_loop

   End