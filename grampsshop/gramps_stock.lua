--[[
    Gramps' shelves.

    This file IS the shop's stock. One line per item:

        { id = <item id>, price = <gil for ONE>, name = "<the item's name>" },

    Items sell one at a time. Add stack = <how many> to a line to let players buy up to that
    many in one go (only the ammunition does). The description comes from the game; the
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

    -- Ninja tools, all at 50 gil (Amalasanda sells these for 40 and 124).
    { id = 1161, price = 50, name = "Uchitake" },
    { id = 1164, price = 50, name = "Tsurara" },
    { id = 1167, price = 50, name = "Kawahori-ogi" },
    { id = 1170, price = 50, name = "Makibishi" },
    { id = 1173, price = 50, name = "Hiraishin" },
    { id = 1176, price = 50, name = "Mizu-deppo" },
    { id = 1179, price = 50, name = "Shihei" },
    { id = 1182, price = 50, name = "Jusatsu" },
    { id = 1185, price = 50, name = "Kaginawa" },
    { id = 1188, price = 50, name = "Sairui-ran" },
    { id = 1191, price = 50, name = "Kodoku" },
    { id = 1194, price = 50, name = "Shinobi-tabi" },

    -- Ninja tools no NPC sells, priced by Stacey at 50.
    { id = 2553, price = 50, name = "Sanjaku-tenugui" },
    { id = 2555, price = 50, name = "Soshi" },
    { id = 2642, price = 50, name = "Kabenro" },
    { id = 2643, price = 50, name = "Jinko" },
    { id = 2644, price = 50, name = "Ryuno" },
    { id = 2970, price = 50, name = "Mokujin" },
    { id = 8804, price = 50, name = "Furusumi" },

    -- Tools, at the NPC price (Bastok Mines, San d'Oria and Al Zahbi sell these).
    { id = 605, price = 200, name = "Pickaxe" },
    { id = 1021, price = 500, name = "Hatchet" },
    { id = 1020, price = 300, name = "Sickle" },

    -- Level 1 ammunition, 10 gil each.
    { id = 17296, price = 10, name = "Pebble", stack = 99 },    -- (throwing)
    { id = 17307, price = 10, name = "Dart", stack = 99 },    -- (throwing)
    { id = 17318, price = 10, name = "Wooden Arrow", stack = 99 },    -- (ranged)
    { id = 17336, price = 10, name = "Crossbow Bolt", stack = 99 },    -- (marksmanship)
    { id = 17343, price = 10, name = "Bronze Bullet", stack = 99 },    -- (marksmanship)
};
