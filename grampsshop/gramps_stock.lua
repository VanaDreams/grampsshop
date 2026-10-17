--[[
    Gramps' shelves.

    This file IS the shop's stock. One line per item:

        { id = <item id>, price = <gil for ONE>, name = "<the item's name>" },

    Items sell one at a time. Add stack = <how many> to a line to let players buy up to that
    many in one go (the ammunition, Shihei and the gathering tools do). The description comes from the game; the
    name does too, and the name written here is what the shop shows when the game has none.
    To add an item, add a line. To change a price, change the number. To take an item off the
    shelf, delete its line (or put -- in front of it).

    Players get a changed list the next time they press Reinstall on the launcher's Addons page.

    Stock chosen by Stacey, 4 Oct 2026. Prices (Ferrin, 17 Oct 2026): every price is 20% over what
    the regular NPC shops charge for the item, rounded to the nearest gil. Items only the Curio
    Vendor Moogle sells use her price (scripts/globals/shop.lua on the server). Pebbles have no NPC
    shop, so they follow Darts; Bronze Bullets are only in guild shops, so the typical stocked price (20) is used.
]]
return {
    { id = 4181, price = 600, name = "Scroll of Instant Warp" },
    { id = 4172, price = 1200, name = "Reraiser" },
    { id = 4165, price = 840, name = "Pot of Silent Oil" },
    { id = 4164, price = 840, name = "Pinch of Prism Powder" },

    -- Ear of Millioncorn: NPC price is 48 gil (Rubahah, Benaige, Komalata), Gramps charges 20% more (Ferrin, 17 Oct 2026).
    { id = 629, price = 58, name = "Ear of Millioncorn", stack = 12 },

    -- Ninja tools: only Shihei (NPC 124 gil), up to a stack of 99 (15 Oct 2026).
    { id = 1179, price = 149, name = "Shihei", stack = 99 },

    -- Gathering tools (NPC 200 / 500 / 300 gil), up to a stack of 12 (15 Oct 2026).
    { id = 605, price = 240, name = "Pickaxe", stack = 12 },
    { id = 1021, price = 600, name = "Hatchet", stack = 12 },
    { id = 1020, price = 360, name = "Sickle", stack = 12 },

    -- Level 1 ammunition (NPC: Dart 10, Wooden Arrow 4, Crossbow Bolt 6).
    { id = 17296, price = 12, name = "Pebble", stack = 99 },    -- (throwing)
    { id = 17307, price = 12, name = "Dart", stack = 99 },    -- (throwing)
    { id = 17318, price = 5, name = "Wooden Arrow", stack = 99 },    -- (ranged)
    { id = 17336, price = 7, name = "Crossbow Bolt", stack = 99 },    -- (marksmanship)
    { id = 17343, price = 24, name = "Bronze Bullet", stack = 99 },    -- (marksmanship)
};
