# How to use the ESC calibration version:
    + Connect the board with your computer via USB port
    + Build and upload the code normally
    + Unplug the board
    + Connect the wire of one ESC with the Pin of the board.
    .. + YELLOW AND BROWN ONLY. DO NOT CONNECT THE RED WIRE
    + Power the board via the USB port    
    + Open the console window of MapleIDE
    + Wait for the confirm tones of the ESC (It will be repeated 4 time, just wait for two time before proceeding to the next step)
    + Now the maximum PWM value is being sent
    + Send any letter from the console window to send the minimum PWM value
    + Wait for the confirm tone 

The ESC is now calibrated. Unplug the board
The programming proceed uses the same procedure, however, wait for the correct tones before sending the minimum value.
    
# How to use the completed version
    + Change the using_controller in setup() to change the controller
    + Build and upload it to the board normally
   
## NOTE:
    - REMEMBER TO COPY THE Libmaple WITH THE ArduPilot 
    - CHANGE THE PATH IN THE congfig.mk FILE BEFORE TRYING TO BUILD THE CODE   
    - The compile command will be "make clean; make flymaple-quad; make upload" respectively

## Libmaple installation
    - The script install.sh will attempt to download all required dependencies for building the project. 

