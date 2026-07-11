# Level 02 — The Cellars — decoded text

Text pool of the level-02 overlay, decoded with `docs/bardstale_textcodec.py`
from `MESSAGES_TABLE` (`$C2E0`, 63 lengths) + `MESSAGES_TEXTS` (`$C320`, 944 bytes).
`\n` = newline; `\` = inflection marker (see `docs/BARDSTALE_TEXT_FORMAT.md`).

This text identifies the level: **the Cellars — the Wine Cellar of the Scarlet
Bard**, Kylearan's tutorial dungeon in *The Bard's Tale*.

| # | Message |
|---|---------|
| 0 | `there are stairs ` |
| 1 | ` Do you wish to take them? [Y-N]` |
| 2 | `darkness!` |
| 3 | `smoke in your eyes!` |
| 4 | ` \nSomething special is near...` |
| 5 | ` \nThere is a trap near!` |
| 6 | `there is a chest here. Will you\n\n(E)xamine it\n(O)pen chest\n(D)isarm it\n(T)rap zap\n(L)eave chest\n\n` |
| 7 | ` [1-6]` |
| 8 | `exmaine it?` (sic) |
| 9 | `open it?` |
| 10 | `disarm it?` |
| 11 | `You found nothing.` |
| 12 | `You already checked.` |
| 13 | `You disarmed it!` |
| 14 | `\nEnter trap name:\n\n` |
| 15 | `\n\nIt looks like a ` |
| 16 | `\n\nYou set off a ` |
| 17 | `TRAP! You've hit a ` |
| 18 | `A wandering creature offers to join your party. You can\n\n(A)llow it to join\n(F)ight it\n(L)eave in peace` |
| 19 | `\nI think you're in trouble!` |
| 20 | `\n\nThe answer is:\n\n` |
| 21 | `Robed men` |
| 22 | `Mouth...` |
| 23 | `An old statue of a fifteen foot tall warrior stands before you. Will you\n\n(A)pproach it\n(E)xit the room` |
| 24 | `\nWrong...:` |
| 25 | `An old man` |
| 27 | `\n\nKylearan vanishes.` |
| 28 | `Kylearan` |
| 29 | `A magic mouth on the wall speaks to the party, saying this:\n\n` |
| 30 | `Magic...` |
| 31 | `Insert character tape, press play then hit a key...` |
| 32 | `Dungeon not implemented!` (leftover/debug) |
| 33 | `Cellars` |
| 34 | `This is the wine cellar of the Scarlet Bard.The air is musty with old wine.` |
| 35 | `Rare wines - 5O years and older. Keep Out!` |
| 36 | `Fine wines - 1O years and older. For regular customers only.` |
| 37 | `(G)o back\n(F)ight him` |
| 38 | `here, going ` |
| 39 | `near here...` |
| 40 | `pit!` |
| 41 | `spiked pit!` |
| 42 | `timed Warstrike spell!` |
| 43 | `poison gas cloud!` |
| 44 | `tripwire, which caused poison darts to shoot!` |
| 45 | `tripwire, which caused a stone block to fall!` |
| 46 | `tripwire, which caused several crossbows to fire at you!` |
| 47 | ` Basilisk snare!` |
| 48 | `up` |
| 49 | `down` |
| 50 | ` got a key.` |

Notes:
- Messages 40–47 are the **trap-effect names** filled into templates 15–17.
- Messages 2–5, 38–39 are exploration/status fragments (`darkness!`, `smoke in
  your eyes!`, `Something special is near...`).
- 23/25/27/28 are the **Kylearan encounter** (statue → old man → Kylearan).
