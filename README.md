# 16bit-VHDL-processor<br>
My final project for ELEC2602, a superscalar 16bit microprocessor <br>

![Alt text](https://raw.githubusercontent.com/AlistairSymonds/16bit-VHDL-processor/pages/Proj%20DataPath.png "Block Diagram/DataPath")

The typical execution cycle is represented by the state machine below. To achieve parallel execution this state machine is being used on two different instructions at once, the val of PC and PC+1, if an error would occur due to data depency or PC jumping the result of the instruction at PC+1 is simply not saved to a register, everything else still occurs. 
![Alt text](https://raw.githubusercontent.com/AlistairSymonds/16bit-VHDL-processor/pages/elecFSM.png "Finite State Machine Diagram")

Written using Quartus 17 although it should work with any VHDL software.<br>
Set top level entity to "processor.vhd" and fire away<br>
