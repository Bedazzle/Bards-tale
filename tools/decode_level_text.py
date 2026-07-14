# Generate a level overlay's decoded-text companion, named to the project convention
# STARThex-ENDhex__messages_texts.decoded.txt (matching the messages_texts.bin sibling,
# so start/end never drift). Decodes the 5-bit packed message pool via the shared codec
# (length table at $C2E0, bitstream at $C320).
#
# Usage:  python tools/decode_level_text.py <NN>          e.g.  06   -> level_06
#         python tools/decode_level_text.py level_06
#
# Reads original/levels/level_NN.bin; writes into levels/level_NN/data/ next to the
# STARThex-ENDhex__messages_texts.bin (whose filename supplies the exact region bounds).
import sys, os, re, glob, importlib.util

BASE = 0xC18C
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def load_codec():
    spec = importlib.util.spec_from_file_location(
        "tc", os.path.join(ROOT, "docs", "bardstale_textcodec.py"))
    tc = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tc)
    return tc

def main():
    arg = sys.argv[1]
    lvl = arg if arg.startswith("level_") else "level_%02d" % int(arg)
    binpath = os.path.join(ROOT, "original", "levels", "%s.bin" % lvl.replace("level_", "level_"))
    if not os.path.exists(binpath):
        sys.exit("no such overlay: %s" % binpath)
    datadir = os.path.join(ROOT, "levels", lvl, "data")

    # derive START-END from the messages_texts.bin sibling (the authoritative slice)
    sib = glob.glob(os.path.join(datadir, "*__messages_texts.bin"))
    if sib:
        m = re.match(r'([0-9A-Fa-f]{4})-([0-9A-Fa-f]{4})__', os.path.basename(sib[0]))
        start, end = int(m.group(1), 16), int(m.group(2), 16)
    else:
        # fallback: text is $C320 .. (level_tbl block start - 1); derive block start from the
        # addr_table_2 level_tbl_1 pointer is unreliable across pads, so require the .bin.
        sys.exit("no messages_texts.bin in %s - slice the regions first" % datadir)

    B = open(binpath, "rb").read()
    tc = load_codec()
    msgs = tc.decode_all(B[0xC2E0 - BASE:0xC2E0 - BASE + 64], B[0xC320 - BASE:])

    out = os.path.join(datadir, "%04X-%04X__messages_texts.decoded.txt" % (start, end))
    # CRLF to match the project convention (Windows working tree, see .gitattributes)
    with open(out, "w", encoding="utf-8", newline="\r\n") as f:
        for i, mmsg in enumerate(msgs):
            f.write(("[%3d] %r\n" % (i, mmsg)).replace("\\r", "\\n"))
    print("wrote %s (%d messages)" % (os.path.relpath(out, ROOT), len(msgs)))

if __name__ == "__main__":
    main()
