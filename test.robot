*** Settings ***
Library     Telnet


*** Variables ***
${REPL}             watchdog.repl

# Registers
${BASE_ADDRESS}     0x0
${REFRESH}          ${BASE_ADDRESS}
${CONTROL}          0x4
${STATUS}           0x8
${TIME}             0xC
${MSVP}             0x10
${TRIGGER}          0x14
${FORCE}            0x18

# Time
${START_TIME}       0x989680


*** Test Cases ***
Watchdog Test Functionality
    Create Machine
    Execute Command    sysbus WriteDoubleWord ${TRIGGER} 0x3e0
    Execute Command    sysbus WriteDoubleWord ${TIME} ${START_TIME}
    Execute Command    sysbus WriteDoubleWord ${MSVP} ${START_TIME}
    Execute Command    sysbus WriteDoubleWord ${CONTROL} 0x0
    Execute Command    sysbus WriteDoubleWord ${REFRESH} 0xDEADC0DE
    ${CURR_TIME} =    Execute Command    sysbus ReadDoubleWord ${REFRESH}

    Evaluate    int(${CURR_TIME}) < int(${START_TIME})


*** Keywords ***
Create Machine
    Execute Command    using sysbus
    Execute Command    mach create

    ExecuteCommand
    ...    include @${CURDIR}/MPFS_Watchdog_NEW.cs
    Execute Command
    ...    machine LoadPlatformDescriptionFromString "wdog0: Timers.MPFS_Watchdog_NEW @ sysbus 0x0 {frequency: 1000000}"

    # Execute Command    machine LoadPlatformDescription @${CURDIR}/${REPL}
