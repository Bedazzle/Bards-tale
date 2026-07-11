# The Bard's Tale — level index (id → dungeon)

All 17 levels identified by decoding each block's own text pool (lengths at `$C2E0`,
bitstream at the address in that level's decoder clone — it varies per level; read the
`ld de,nnnn` before `ld hl,$C2E0`). See `docs/BARDSTALE_LEVEL_FORMAT.md`.

This is the canonical *Bard's Tale 1* layout: Cellars 1 + Sewers 3 + Catacombs 3 +
Castle 3 + Kylearan's Tower 1 + Mangar's Tower 5 = **16 dungeon mazes** + the city.

| id | Dungeon | Distinctive in-level text | Status |
|----|---------|---------------------------|--------|
| 01 | **City of Skara Brae** | "guild", "Garth's Shoppe", "purchase" | done (`levels/city/`) |
| 02 | **Cellars** (Wine Cellar of the Scarlet Bard) | "This is the wine cellar of the Scarlet Bard", "Rare wines - 50 years and older. Keep Out!" | carved (`levels/level_02/`) |
| 03 | **Sewers 1** | "You are in the sewers under Skara Brae. The shallow water holds unknown terrors." | to do |
| 04 | **Sewers 2** | "There are tracks here, leading east", "There is no exit until the seven words are said" | to do |
| 05 | **Sewers 3** | "Seek the Snare from behind the scenes", "The hand of time writes and cannot erase" | to do |
| 06 | **Catacombs 1** | "miles of winding, twisting tunnels… ancient bones of acolytes", "burial preparation chamber" | to do |
| 07 | **Catacombs 2** | "chambers of Bashar Kavilor, High Priest. Prepare to die!", "Stasis chamber ahead" | to do |
| 08 | **Catacombs 3** | "Seek the Mad One's stoney self in Harkyn's domain", "burial chamber of King Aildrek" | to do |
| 09 | **Harkyn's Castle 1** | "a wide corridor leads into Baron Harkyn's castle… fabulous tapestries", "the Baron's throne" | to do |
| 10 | **Harkyn's Castle 2** | "a splendid library", "Slave quarters", the wizened man | to do |
| 11 | **Harkyn's Castle 3** | "The Barracks", "The Crystal Sword will leave the crystal guardian in many pieces", "legions of Baron Harkyn" | to do |
| 12 | **Kylearan's Tower** | guardian riddle: "As a guardian He must walk… the first part of his name means rock", "living statue" | to do |
| 13 | **Mangar's Tower 1** | "Beyond the lie / Before the slip / A passage north…", "Ahead lies the exit, oh faithful ones!" | to do |
| 14 | **Mangar's Tower 2** | "The Spectre Snare can catch a foe and bind him", "Two shapes yours, one's around…" | to do |
| 15 | **Mangar's Tower 3** | One-God riddles: "Do not scry, the first is lie", "the third is passion…" | to do |
| 16 | **Mangar's Tower 4** | "Welcome to Mangar's crypt", "The shape of a skull is etched on the floor" | to do |
| 17 | **Mangar's Tower 5** | "3 geometric shapes: a square, a circle, and a triangle", "This is Mangar's treasure trove", boiling-liquid pool | to do |

Raw blocks: `original/levels/level_NN.bin` (14789 bytes, org `$C18C`). Suggested subdir
names when carving: `level_03` → `sewers_1`, … `level_17` → `mangars_tower_5` (or keep
`level_NN` and note the dungeon in the file header, as `level_02` does).
