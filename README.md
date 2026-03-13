# PARP-LostPaws

## Authors
Weronika Maślana
Katarzyna Kanicka
Hanna Zarzycka

## Topic of the story:
Muffin, a fat and very lazy house cat, was lying in the warm sun, happily baking like a loaf of bread.

Suddenly, someone picked her up.
Before she could complain, she was placed inside a metal cage and loaded into the back of a truck. Around her were many other cages filled with nervous animals.

After many long hours, the truck turned onto a rough, bumpy road. The cages rattled and slid across the floor.

Then — **BANG!**

The truck's back door swung open. Muffin’s cage rolled out of the truck and into the tall grass by the road.

The truck disappeared into the distance.

Muffin pushed the cage door open with her paw and stepped outside.

She was free.

But one question remained:

**How will she find her way home?**


## Task:
write adventure, text based game in:
* prolog (W)
* huskel (K)
* smalltalk (H)

## Prolog launch
```
swipl
[lostPaws].
start.
```

## Prolog - win sequence
```
e.
take(small_stick).
take(branch).
w.
s.
search(white_rock).
search(hat).
take(gerbil).
eat(gerbil).
take(hat).
n.
n.
search(cardborad_box).
drop(branch).
take(cod).
eat(cod).
take(big_stick).

show_mouth.  #you should have: hat, big_stick and small_stick

w.
n.
search(hay).
attach(big_stick, hay).
attach(small_stick, frame).
attach(hat, headless_man).
take(brown_mouse).
eat(brown_mouse).

s.
# optional - if u missed brown_mouse
search(brick).
take(tiny_mouse).
eat(tiny_mouse).

e.
take(cardboard_box).
take(branch).
s.
take(cage).
w.
attach(branch, broken_stool).
take(stool).

n.
n.
w.
w.
drop(cage).
drop(cardboard_box).
search(cardboard_box).
take(makerel).
eat(makerel).
search(cardboard_box).
take(herring).
take(cardboard_box).
attach(cardboard_box, cage).
attach(stool, tower).

w.
drop(herring).
s.
halt.
```