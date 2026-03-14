# PARP-LostPaws
```
============================================================
      _                     _   _____
     | |                   | | |  __ \
     | |      ___   ___   _| |_| |__) |_ ___      _____
     | |     / _ \ / __| /_` __|  ___/ _` \ \ /\ / / __|
     | |____| (_) |\__ \___| |_| |  | (_| |\ V  V /\__ \
     |______\___/ |___/\__,____|_|   \__,_| \_/\_/ |___/

============================================================
              THE JOURNEY BEGINS IN THE WILD
============================================================

                       |\__/,|   (`\
                     _.|o o  |_   ) )
                   -(((---(((--------

                [ FIND YOUR WAY HOME ]

============================================================
```


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

# === SPOILERS BELOW! ===

## Map of terrain
![Game Map basic](images/map-basic.png)
<!-- ![Game Map pretty](images/map_pretty.png) -->


##  Walkthrough in prolog

Krótki poradnik jak ukończyć grę i wrócić Muffinem do domu.

### 1. Ucieczka z okolicy klatki
- Idź na **południe do meadow**.
- `take(white_rock).` – pod kamieniem znajdziesz **hat**.
- Idź **na zachód do rocky_road**.

### 2. Rozwiązanie zagadki z kamieniami
- Na rocky_road ułóż litery w słowo:
shelter
- Otrzymasz **shell** i wskazówkę o **shelter** (nie idź tam - to złe zakończenie).

### 3. Zbudowanie totemu przy wodospadzie
- Idź:
  - `w` → river
  - `n` → waterfall
- Musisz mieć:
  - `brick`
  - `white_rock`
  - `cool_pebble` (`search(river).`)
  - `shell`
- Zanieś kamienie do waterfall i ułóż od najcięższego do najlżejszego (przy pomocy arrange i używając tylko pierszych liter powyższych przedmiotów):
b,w,c,s
- Z wody wypłynie **pipe**.

### 4. Przepłoszenie wron na cabbage_field
Potrzebne:
- `big_stick`
- `small_stick`
- `hay`
- `hat`

W **wheat_field** zbuduj stracha:
big_stick z hay -> frame
small_stick z frame -> headless_man
hat z headless_man
Powstanie **scarecrow** i wrony odlecą.

### 5. Zbudowanie schodów na moście by przeskoczyć bramę
Zbierz przedmioty:
- `pipe`
- `broken_stool`
- `cardboard_box`
- `cage`

Budowanie:
pipe z broken_stool -> stool
cardboard_box z cage -> tower
tower z stool
Powstaną **stairs** które pozwolą przejść do miasta.

### 6. Pozbycie się psa
- W **graveyard** znajdziesz:
bone
- będąc w **town** rzuć ją psu (drop).

### 7. Odwrócenie uwagi orła
- przynieś do town rybę (np. z pudełka w lesie)
- rzuć rybę w town

### 8. zchodzimy na południe do domu i wygrywamy
- pamiętaj by po drodze zbierać i jeść ryby i gryzonie by nie umrzeć z wyczerpania


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
search(branch).
take(squirel).
eat(squirel).
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
take(rat).
eat(rat).
w.
take(bone).

e.
drop(bone).
drop(rauch).
s.
halt.
```