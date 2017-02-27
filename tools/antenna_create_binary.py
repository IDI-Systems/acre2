#!/usr/bin/env python3

import sys
import os
import struct

classname = sys.argv[1]

maindirectory = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..'))
filepath = os.path.join(maindirectory,'extras','antennas')

###################################
#
#   Read Values from Output file
#
###################################


frequencies = []
radiationBlockFlag = 0
gaindata = b""

with open(os.path.join(filepath,"{}.out".format(classname))) as f:
    for i, line in enumerate(f, 1):
        if 'FREQUENCY=' in line:
            line = line.strip()
            frequencies.append(float(line[11:-4]))
            pass

        if "- - ANGLES - -" in line:
            radiationBlockFlag = 1
            startRead = i + 2
            pass

        if (radiationBlockFlag == 1):
            if " ***** DATA" in line:
                ## We reached the EOF
                radiationBlockFlag = 0
                break
            if not line.strip():
                ## Radiation Data Block is finished
                radiationBlockFlag = 0
                continue
            if (i > startRead):
                ## Copy those values
                values = line.split()
                if ((float(values[0]) >= 0) and (float(values[1]) > 0)):
                    values = values[2:4]
                    values = [float(x) for x in values]
                    gaindata += struct.pack("ff",values[0],values[1])

frequencies = frequencies[1:]

freqMin = int(min(frequencies))
freqMax = int(max(frequencies))
freqStep = int(frequencies[1] - frequencies[0])
freqCount = len(frequencies)


###################################
#
#   Read Values from Input file
#
###################################

# Init Values
thetaSteps = 0
phiSteps = 0
thetaResolution = 0
phiResolution = 0

with open(os.path.join(filepath,"{}.inp".format(classname))) as f:
    for line in f:
        if 'RP' in line:
            values = line.split()
            thetaSteps = int((int(values[2]) - 1)/2 + 1)
            phiSteps = int(int(values[3]) - 1)
            thetaResolution = float(values[7])
            phiResolution = float(values[8])


###################################
#
#   Generate binarized output
#
###################################


out = struct.pack("fffIIIff",freqMin,freqMax,freqStep,freqCount,thetaSteps,phiSteps,thetaResolution,phiResolution) + gaindata

outputfilename = os.path.join(maindirectory,'addons','sys_antenna','binary','{}_gain.aba'.format(classname))

outputfile = open(outputfilename, 'bw')
outputfile.truncate()
outputfile.write(out)
outputfile.close()


print("{} bytes written to {}".format(len(out),outputfilename))
