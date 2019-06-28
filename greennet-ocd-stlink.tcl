#log_output openocd.log
#debug_level 3
telnet_port 5555

#
# STMicroelectronics ST-LINK/V2 in-circuit debugger/programmer
#

interface stlink
stlink_layout usb
stlink_device_desc "ST-LINK/V2"
stlink_vid_pid  0x0483 0xb001 
#
# dummy values, not really needed
#
adapter_khz 2000
adapter_nsrst_delay 100
reset_config trst_and_srst

#source [find interface/stlink-v2.cfg]
#source [find target/stm32lx_stlink.cfg]

#
# STM32lx stlink pseudo target
#

set CHIPNAME stm32lx
set CPUTAPID 0x2ba01477
set WORKAREASIZE 0x3800

#source [find target/stm32_stlink.cfg]

#
# stm32 stlink pseudo target
#

if { [info exists CHIPNAME] } {
   set _CHIPNAME $CHIPNAME
} else {
   set _CHIPNAME stm32f1x
}

# Work-area is a space in RAM used for flash programming
# By default use 16kB
if { [info exists WORKAREASIZE] } {
   set _WORKAREASIZE $WORKAREASIZE
} else {
   set _WORKAREASIZE 0x4000
}

if { [info exists CPUTAPID] } {
   set _CPUTAPID $CPUTAPID
} else {
   # this is the SW-DP tap id not the jtag tap id
   set _CPUTAPID 0x1ba01477
}

#
# possibles value are stlink_swd or stlink_jtag
#
transport select stlink_swd

stlink newtap $_CHIPNAME cpu -expected-id $_CPUTAPID

set _TARGETNAME $_CHIPNAME.cpu
target create $_TARGETNAME stm32_stlink -chain-position $_TARGETNAME

$_TARGETNAME configure -work-area-phys 0x20000000 -work-area-size $_WORKAREASIZE -work-area-backup 0

set _FLASHNAME $_CHIPNAME.flash
flash bank $_FLASHNAME stm32lx 0 0 0 0 $_TARGETNAME

#$_TARGETNAME

#for {set x 1} {$x < 10 } {set x [expr $x +1]} { $_TARGETNAME mdb 0x200041f0 }


#stlink_serial IPPGJABHIFHH