--[[
    Gramps' shelves.

    This file IS the shop's stock. One line per item:

        { id = <item id>, price = <gil for ONE> },

    The name, the description and the stack size come from the game itself, so the id and the
    price are all a line needs. To add an item, add a line. To change a price, change the number.
    To take an item off the shelf, delete its line (or put -- in front of it).

    Players get a changed list the next time they press Reinstall on the launcher's Addons page.

    Stock chosen by Stacey, 4 Oct 2026. The prices are the Curio Vendor Moogle's for the same
    items (scripts/globals/shop.lua on the server), as a starting point.
]]
return {
    { id = 4181, price = 500 },    -- Scroll of Instant Warp
    { id = 4172, price = 1000 },   -- Reraiser
    { id = 4165, price = 700 },    -- Pot of Silent Oil
    { id = 4164, price = 700 },    -- Pinch of Prism Powder

    -- Ninja tools, all at 50 gil (Amalasanda sells these for 40 and 124).
    { id = 1161, price = 50 },     -- Uchitake
    { id = 1164, price = 50 },     -- Tsurara
    { id = 1167, price = 50 },     -- Kawahori-ogi
    { id = 1170, price = 50 },     -- Makibishi
    { id = 1173, price = 50 },     -- Hiraishin
    { id = 1176, price = 50 },     -- Mizu-deppo
    { id = 1179, price = 50 },     -- Shihei
    { id = 1182, price = 50 },     -- Jusatsu
    { id = 1185, price = 50 },     -- Kaginawa
    { id = 1188, price = 50 },     -- Sairui-ran
    { id = 1191, price = 50 },     -- Kodoku
    { id = 1194, price = 50 },     -- Shinobi-tabi

    -- Ninja tools no NPC sells, priced by Stacey at 50.
    { id = 2553, price = 50 },     -- Sanjaku-tenugui
    { id = 2555, price = 50 },     -- Soshi
    { id = 2642, price = 50 },     -- Kabenro
    { id = 2643, price = 50 },     -- Jinko
    { id = 2644, price = 50 },     -- Ryuno
    { id = 2970, price = 50 },     -- Mokujin
    { id = 8804, price = 50 },     -- Furusumi

    -- Tools, at the NPC price (Bastok Mines, San d'Oria and Al Zahbi sell these).
    { id = 605,  price = 200 },    -- Pickaxe
    { id = 1021, price = 500 },    -- Hatchet
    { id = 1020, price = 300 },    -- Sickle

    -- Level 1 ammunition, 10 gil each.
    { id = 17296, price = 10 },    -- Pebble (throwing)
    { id = 17318, price = 10 },    -- Wooden Arrow (ranged)
    { id = 17336, price = 10 },    -- Crossbow Bolt (marksmanship)
    { id = 17343, price = 10 },    -- Bronze Bullet (marksmanship)
};
