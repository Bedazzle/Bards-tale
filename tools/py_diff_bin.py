from glob import glob
import sys
import os.path
import os

TAB = '\t'
ORGADR = 23296
CHECKFROM = 23296
CHECKTO   = 65535

#print(os.getcwd())

files = [sys.argv[1], sys.argv[2]]

#-------------------------------------------------------------------------------

dump = []

for f in files:
    dump.append(open(f, "rb").read())

fsize = len(dump[0])
fcount = len(files)

found = 0

info = "no info set"

for i in range(0, fsize):
    if (ORGADR + i >= CHECKFROM) and (ORGADR + i <= CHECKTO):

        info = "%4X " % (ORGADR + i)

        for f in range(1, fcount):
            for x in range(0, len(files)):
                if sys.version_info[0] < 3:
                    info = "%s%s%0.2X" % (info, TAB, ord(dump[x][i]))
                else:
                    info = "%s%s%0.2X" % (info, TAB, dump[x][i])

            s10 = "%5d" % (ORGADR + i)
            s16 = "%4X" % (ORGADR + i)

            for x in range(0, len(files)):
                if sys.version_info[0] < 3:
                    s10 = "%s%s%3d" % (s10, TAB, ord(dump[x][i]))
                    s16 = "%s%s%0.2X" % (s16, TAB, ord(dump[x][i]))
                else:
                    s10 = "%s%s%3d" % (s10, TAB, dump[x][i])
                    s16 = "%s%s%0.2X" % (s16, TAB, dump[x][i])

            if dump[f-1][i] != dump[f][i]:
                print(s16)

                found = found + 1
                break


if found == 0:
    print("NO vital diffs found")
else:
    print("Found %d diffs" % found)