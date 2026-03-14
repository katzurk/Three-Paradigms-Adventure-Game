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
s.
take(white_rock).
w.
arrange(s,h,e,l,t,e,r).
take(shell).
w.
search(river).
take(cool_pebble).
n.
drop(cool_pebble).
drop(shell).
drop(white_rock).
e.
n.

search(brick).
take(tiny_mouse).
eat(tiny_mouse).
take(brick).
s.
w.
drop(brick).
arrange(b,w,c,s).
search(pipe).
take(herring).
eat(herring).
take(pipe).

e.
attach(pipe, broken_stool).
e.
s.

search(hat).
take(gerbil).
eat(gerbil).
take(hat).
n.
e.
take(small_stick).
w.
n.
search(cardboard_box)
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
e.
take(cardboard_box).
s.
take(cage).
w.
take(stool).

n.
n.
w.
w.
drop(cage).
drop(cardboard_box).
search(cardboard_box).
take(mackerel).
eat(mackerel).
search(cardboard_box).
take(rauch).
take(cardboard_box).
attach(cardboard_box, cage).
attach(stool, tower).

w.
w.
take(bone).

e.
drop(bone).
drop(rauch).
s.
halt.
```