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
    { id = 3509, price = 5000 },   -- Plate of Heavy Metal
};
