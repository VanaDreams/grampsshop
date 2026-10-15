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

    Stock chosen by Stacey, 4 Oct 2026. The prices are the Curio Vendor Moogle's for the same
    items (scripts/globals/shop.lua on the server), as a starting point.
]]
return {
    { id = 4181, price = 500, name = "Scroll of Instant Warp" },
    { id = 4172, price = 1000, name = "Reraiser" },
    { id = 4165, price = 700, name = "Pot of Silent Oil" },
    { id = 4164, price = 700, name = "Pinch of Prism Powder" },

    -- Ninja tools: only Shihei, 10 gil each, up to a stack of 99 (Ferrin, 15 Oct 2026).
    { id = 1179, price = 10, name = "Shihei", stack = 99 },

    -- Gathering tools, 25 gil each, up to a stack of 12 (Ferrin, 15 Oct 2026).
    { id = 605, price = 25, name = "Pickaxe", stack = 12 },
    { id = 1021, price = 25, name = "Hatchet", stack = 12 },
    { id = 1020, price = 25, name = "Sickle", stack = 12 },

    -- Level 1 ammunition, 10 gil each.
    { id = 17296, price = 10, name = "Pebble", stack = 99 },    -- (throwing)
    { id = 17307, price = 10, name = "Dart", stack = 99 },    -- (throwing)
    { id = 17318, price = 10, name = "Wooden Arrow", stack = 99 },    -- (ranged)
    { id = 17336, price = 10, name = "Crossbow Bolt", stack = 99 },    -- (marksmanship)
    { id = 17343, price = 10, name = "Bronze Bullet", stack = 99 },    -- (marksmanship)
};
