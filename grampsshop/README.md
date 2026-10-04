# Gramps Shop, Kupo!

A small shop you can open anywhere on Vanadreams, as an Ashita v4 addon.

While you are in game a little **Gramps Shop, Kupo!** button sits on your screen. Click it and the shop opens: pick an item, pick how many, press **Buy**. The gil comes out of your pocket and the item goes into your bag. Nothing has to be typed.

Gramps answers in the chat log and in the shop window, so you can see what each purchase cost.

It works on Vanadreams only. On any other server the shop stays shut.

## Install

From the Vanadreams launcher: tick **grampsshop** on the Addons page.

By hand: copy this folder to `Ashita-v4beta\addons\grampsshop\`, then in game:

```
/addon load grampsshop
```

## Use

Click the button. To move it, drag the little `::` beside it; it stays where you put it.

If you would rather not have the button, untick **Show the little shop button** in the shop window. These still work without it:

```
/gramps
/gramps button
```

`/gramps` opens and closes the shop. `/gramps button` brings the button back.

## What Gramps sells

The stock and the prices are the list in `gramps_stock.lua`, beside the addon. One line per item: the item's id and the price in gil for one. The game supplies the name, the description and how many stack.

When the list changes, press Reinstall on the launcher's Addons page to get the new one.

## How it works

The addon is the shop. When you press Buy it sends one line to the Vanadreams server for you, `!gramps <item> <how many> <gil>`, and the server takes the gil and hands over the item. The server keeps no stock list and no prices of its own.

## Settings

Kept per character by Ashita's settings library under `config\addons\grampsshop\`.
