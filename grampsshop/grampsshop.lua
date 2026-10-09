--[[
    Gramps Shop, Kupo! - a small shop you can open anywhere on Vanadreams.

    A little "Gramps Shop, Kupo!" button sits on your screen while you are in game. Click it and
    the shop opens: pick an item, pick how many, press Buy. Nothing has to be typed.

    The shop is this addon. What Gramps sells and what it costs is the list in gramps_stock.lua,
    beside this file; the game supplies each item's name and description.

    Buying sends one line to the Vanadreams server for you (!gramps <item> <how many> <gil>),
    which takes the gil and puts the item in your bag. That command only exists on Vanadreams,
    so the shop keeps itself shut everywhere else.

    Commands (all optional, the button does the same):
      /gramps          open or close the shop
      /gramps button   show or hide the little button
]]

addon.name    = 'grampsshop';
addon.author  = 'Vanadreams';
addon.version = '0.1.7';
addon.desc    = 'Gramps Shop, Kupo! A small shop you can open anywhere on Vanadreams.';
addon.link    = 'https://github.com/VanaDreams/grampsshop';

require('common');
local imgui    = require('imgui');
local settings = require('settings');

local SHOP_NAME = 'Gramps Shop, Kupo!';

-- ---------------------------------------------------------------------------
-- settings
-- ---------------------------------------------------------------------------
local defaults = T{
    shop_open   = T{ false },   -- the shop window; closed until the button is clicked
    show_button = T{ true },    -- the little button that opens it
    servers     = T{ 'vanadreams' },
};
local cfg = settings.load(defaults);

-- ---------------------------------------------------------------------------
-- stock: gramps_stock.lua, beside this file
-- ---------------------------------------------------------------------------
local stock = T{};
local stock_error = '';
do
    local ok, list = pcall(require, 'gramps_stock');
    if not ok or type(list) ~= 'table' then
        stock_error = 'gramps_stock.lua could not be read: ' .. tostring(list);
    else
        for _, line in ipairs(list) do
            local id, price = tonumber(line.id), tonumber(line.price);
            if id and price and id > 0 and price >= 0 then
                stock:append({ id = math.floor(id), price = math.floor(price) });
            end
        end
        if #stock == 0 then stock_error = 'gramps_stock.lua has no items in it.'; end
    end
end

-- ---------------------------------------------------------------------------
-- state
-- ---------------------------------------------------------------------------
local BUY_PAUSE = 2.0;          -- seconds between purchases, so a double click buys once

local shop = {
    selected = 1,
    quantity = T{ 1 },
    note     = '',              -- what the shop last did, shown under the Buy button
    reply    = '',              -- what Gramps last said back from the server
    last_buy = -BUY_PAUSE,      -- so the very first Buy is never mistaken for a double click
    allowed  = false,
    allowed_reason = '',
};

local function now() return os.clock(); end
local function say(msg) print(('\30\08[Gramps]\30\01 %s'):format(msg)); end

local function check_server()
    local cmd = '';
    pcall(function() cmd = AshitaCore:GetConfigurationManager():GetString('boot', 'ashita.boot', 'command') or ''; end);
    cmd = cmd:lower();
    for _, name in ipairs(cfg.servers) do
        if #name > 0 and cmd:find(name:lower(), 1, true) then shop.allowed = true; shop.allowed_reason = ''; return true; end
    end
    shop.allowed = false;
    shop.allowed_reason = 'Gramps only keeps shop on Vanadreams, kupo.';
    return false;
end

local function logged_in()
    local ok, status = pcall(function() return AshitaCore:GetMemoryManager():GetPlayer():GetLoginStatus(); end);
    return ok and status == 2;
end

-- ---------------------------------------------------------------------------
-- what the game knows: item names, gil, bag space
-- ---------------------------------------------------------------------------
local function item_info(id)
    local r = AshitaCore:GetResourceManager():GetItemById(id);
    if not r then return { name = 'item ' .. tostring(id), text = '', stack = 1 }; end
    local stack = tonumber(r.StackSize) or 1;
    if stack < 1 then stack = 1; end
    return { name = r.Name[1] or ('item ' .. tostring(id)), text = (r.Description and r.Description[1]) or '', stack = stack };
end

local function my_gil()
    local it = AshitaCore:GetMemoryManager():GetInventory():GetContainerItem(0, 0);  -- slot 0 of the inventory is gil
    if it and it.Id == 65535 then return it.Count; end
    return 0;
end

local function free_slots()
    local inv = AshitaCore:GetMemoryManager():GetInventory();
    return inv:GetContainerCountMax(0) - inv:GetContainerCount(0);
end

local function commas(n)
    local s = tostring(math.floor(n));
    local out = s:reverse():gsub('(%d%d%d)', '%1,'):reverse();
    if out:sub(1, 1) == ',' then out = out:sub(2); end
    return out;
end

-- ---------------------------------------------------------------------------
-- buying
-- ---------------------------------------------------------------------------
local function buy(line, quantity)
    if not shop.allowed then shop.note = shop.allowed_reason; return; end
    if not logged_in() then shop.note = 'Log in first, kupo.'; return; end
    if now() - shop.last_buy < BUY_PAUSE then return; end

    local info  = item_info(line.id);
    quantity    = math.max(1, math.min(quantity, info.stack));
    local total = line.price * quantity;

    if my_gil() < total then
        shop.note = ('That comes to %s gil and you have %s, kupo.'):format(commas(total), commas(my_gil()));
        return;
    end
    if free_slots() < 1 then
        shop.note = 'Your bag is full, kupo. Make some room first.';
        return;
    end

    shop.last_buy = now();
    shop.reply    = '';
    shop.note     = ('Asked Gramps for %d x %s (%s gil).'):format(quantity, info.name, commas(total));
    -- The one thing that reaches the server: it takes the gil and hands over the item.
    AshitaCore:GetChatManager():QueueCommand(1, ('/say !gramps %d %d %d'):format(line.id, quantity, total));
end

-- Gramps answers in the chat log ("Gramps : ..."); show his last line in the shop window too.
ashita.events.register('text_in', 'grampsshop_text_in', function (e)
    if e.injected then return; end
    local text = e.message_modified or e.message or '';
    -- Your own client echoes the line the Buy button sent ("Terry : !gramps 4172 1 1000").
    -- Nobody else ever sees it; keep it out of your own chat log too.
    if text:find('!gramps %d+ %d+ %d+') then e.blocked = true; return; end
    local at = text:find('Gramps : ', 1, true);
    if not at then return; end
    shop.reply = text:sub(at):gsub('[%z\1-\31\127]', '');
end);

-- ---------------------------------------------------------------------------
-- windows
-- ---------------------------------------------------------------------------
-- Vanadreams palette, from the site: night, plum, velvet, gold, soft gold, cream
local C = {
    night  = { 0.059, 0.039, 0.090 },
    plum   = { 0.137, 0.098, 0.220 },
    velvet = { 0.200, 0.133, 0.290 },
    gold   = { 0.839, 0.655, 0.298 },
    soft   = { 0.945, 0.804, 0.471 },
    cream  = { 1.000, 0.953, 0.824 },
    fail   = { 0.900, 0.450, 0.450 },
};
local function rgba(c, a) return { c[1], c[2], c[3], a }; end

local STYLE_COLOURS = 14;
local function push_style()
    imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 6.0);
    imgui.PushStyleColor(ImGuiCol_WindowBg,      rgba(C.night, 0.95));
    imgui.PushStyleColor(ImGuiCol_TitleBg,       rgba(C.plum, 1.0));
    imgui.PushStyleColor(ImGuiCol_TitleBgActive, rgba(C.velvet, 1.0));
    imgui.PushStyleColor(ImGuiCol_Border,        rgba(C.gold, 0.35));
    imgui.PushStyleColor(ImGuiCol_FrameBg,       rgba(C.velvet, 0.60));
    imgui.PushStyleColor(ImGuiCol_PopupBg,       rgba(C.night, 0.92));
    imgui.PushStyleColor(ImGuiCol_Button,        rgba(C.velvet, 0.85));
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, rgba(C.gold, 0.60));
    imgui.PushStyleColor(ImGuiCol_ButtonActive,  rgba(C.gold, 0.85));
    imgui.PushStyleColor(ImGuiCol_Header,        rgba(C.velvet, 0.85));
    imgui.PushStyleColor(ImGuiCol_HeaderHovered, rgba(C.gold, 0.45));
    imgui.PushStyleColor(ImGuiCol_Separator,     rgba(C.gold, 0.35));
    imgui.PushStyleColor(ImGuiCol_Text,          rgba(C.cream, 1.0));
    imgui.PushStyleColor(ImGuiCol_TextDisabled,  rgba(C.soft, 0.75));
end
local function pop_style()
    imgui.PopStyleColor(STYLE_COLOURS);
    imgui.PopStyleVar(1);
end

-- the little button that opens the shop, so nobody has to type a command
-- Where the button sits until you drag it somewhere else. Up to 0.1.1 it sat at 60,60 and could
-- not be dragged (the button filled its whole window, so there was nothing to take hold of).
-- Stacey, 4 Oct 2026: an inch lower and half an inch further left - about 70 px to the inch on
-- her screen - and make it movable.
local BUTTON_HOME     = { 25, 130 };
local OLD_BUTTON_HOME = { 60, 60 };
local send_button_home = false;     -- found still at the old spot: move it on the next frame

local function draw_button()
    local flags = bit.bor(ImGuiWindowFlags_NoTitleBar, ImGuiWindowFlags_AlwaysAutoResize,
                          ImGuiWindowFlags_NoScrollbar, ImGuiWindowFlags_NoCollapse);
    imgui.SetNextWindowPos(BUTTON_HOME, send_button_home and ImGuiCond_Always or ImGuiCond_FirstUseEver);
    send_button_home = false;
    if imgui.Begin('##grampsshop_button', cfg.show_button, flags) then
        -- Nobody chose the old spot, because nobody could move the button: treat it as "not placed yet".
        local x, y = imgui.GetWindowPos();
        if x == OLD_BUTTON_HOME[1] and y == OLD_BUTTON_HOME[2] then send_button_home = true; end

        -- the handle: plain text is not a button, so pressing here drags the window
        imgui.TextDisabled('::');
        if imgui.IsItemHovered() then imgui.SetTooltip('Drag here to move the button'); end
        imgui.SameLine();
        if imgui.Button(SHOP_NAME) then
            cfg.shop_open[1] = not cfg.shop_open[1];
            settings.save();
        end
    end
    imgui.End();
end

local function draw_shop()
    imgui.SetNextWindowSize({ 380, 0 }, ImGuiCond_FirstUseEver);
    if imgui.Begin(SHOP_NAME, cfg.shop_open) then
        if stock_error ~= '' then
            imgui.TextWrapped(stock_error);
        elseif not shop.allowed then
            imgui.TextWrapped(shop.allowed_reason);
        else
            imgui.TextDisabled('Your gil:');
            imgui.SameLine();
            imgui.TextColored(rgba(C.soft, 1.0), commas(my_gil()));
            imgui.SameLine(imgui.GetWindowWidth() - 130);
            imgui.TextDisabled(('Bag space: %d'):format(free_slots()));
            imgui.Separator();

            -- the shelf
            if shop.selected > #stock then shop.selected = 1; end
            imgui.BeginChild('grampsshop_shelf', { 0, 150 }, ImGuiChildFlags_Borders);
            for i, line in ipairs(stock) do
                local info = item_info(line.id);
                if imgui.Selectable(('%s   -   %s gil##%d'):format(info.name, commas(line.price), i), i == shop.selected) then
                    shop.selected = i;
                    shop.quantity[1] = 1;
                    shop.note = '';
                end
            end
            imgui.EndChild();

            -- the item in hand
            local line = stock[shop.selected];
            local info = item_info(line.id);
            imgui.TextColored(rgba(C.gold, 1.0), info.name);
            if info.text ~= '' then imgui.TextWrapped(info.text); end
            imgui.Separator();

            if info.stack > 1 then
                imgui.PushItemWidth(100);
                imgui.InputInt('How many', shop.quantity);
                imgui.PopItemWidth();
                if shop.quantity[1] < 1 then shop.quantity[1] = 1; end
                if shop.quantity[1] > info.stack then shop.quantity[1] = info.stack; end
                imgui.SameLine();
                imgui.TextDisabled(('up to %d at a time'):format(info.stack));
            else
                shop.quantity[1] = 1;
                imgui.TextDisabled('One at a time, kupo.');
            end

            local total = line.price * shop.quantity[1];
            imgui.Text(('Total: %s gil'):format(commas(total)));
            imgui.SameLine(imgui.GetWindowWidth() - 110);
            if imgui.Button('Buy', { 96, 24 }) then buy(line, shop.quantity[1]); end

            if shop.reply ~= '' then
                imgui.TextColored(rgba(C.soft, 1.0), shop.reply);
            elseif shop.note ~= '' then
                imgui.TextDisabled(shop.note);
            end
        end
        imgui.Separator();
        if imgui.Checkbox('Show the little shop button', cfg.show_button) then settings.save(); end
        if not cfg.show_button[1] then imgui.TextDisabled('Type /gramps to open the shop without it.'); end
    end
    imgui.End();
end

local was_open, had_button = cfg.shop_open[1], cfg.show_button[1];

ashita.events.register('d3d_present', 'grampsshop_present', function ()
    -- nothing on the title screen or character select
    if not logged_in() then return; end
    if not cfg.shop_open[1] and not cfg.show_button[1] then return; end

    push_style();
    if cfg.show_button[1] then draw_button(); end
    if cfg.shop_open[1] then draw_shop(); end
    pop_style();

    -- the window's own close button changes these; remember the change
    if cfg.shop_open[1] ~= was_open or cfg.show_button[1] ~= had_button then
        was_open, had_button = cfg.shop_open[1], cfg.show_button[1];
        settings.save();
    end
end);

-- ---------------------------------------------------------------------------
-- commands
-- ---------------------------------------------------------------------------
ashita.events.register('command', 'grampsshop_cmd', function (e)
    local args = e.command:args();
    if #args == 0 or args[1] ~= '/gramps' then return; end
    e.blocked = true;
    local sub = (args[2] or ''):lower();
    if sub == 'button' then
        cfg.show_button[1] = not cfg.show_button[1];
        say(cfg.show_button[1] and 'the little button is back.' or 'the little button is hidden. /gramps opens the shop.');
    elseif sub == 'help' then
        say('/gramps opens or closes the shop. /gramps button shows or hides the little button.');
    else
        cfg.shop_open[1] = not cfg.shop_open[1];
    end
    settings.save();
end);

ashita.events.register('load', 'grampsshop_load', function ()
    check_server();
    if stock_error ~= '' then say(stock_error); return; end
    say(shop.allowed and 'the shop is open, kupo! Click the Gramps Shop button, or type /gramps.' or shop.allowed_reason);
end);

ashita.events.register('unload', 'grampsshop_unload', function ()
    settings.save();
end);
