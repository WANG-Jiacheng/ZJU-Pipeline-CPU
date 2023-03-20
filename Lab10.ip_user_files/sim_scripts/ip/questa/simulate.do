onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib Rom_opt

do {wave.do}

view wave
view structure
view signals

do {Rom.udo}

run -all

quit -force
