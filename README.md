# Unforgiving-Parasites
A rework of SexLab Parasites to be fully compatible with Unforgiving Devices.

It should generally function as with per the original mod, with some bonus flavour and interactability.

## Rough Summary

Most parasites here come in one of two types:
 - Interactable (e.g. Spider Penis)
 - Static (e.g. Tentacle Armor)

Interactable parasites are those you can remove using UD minigames. They'll usually do their best to settle as deep within the character as possible - the more entrenched they are, the harder it'll be to remove them (very similar to Inflation Plugs in UD). The wearer's arousal also plays a massive role; a high enough arousal will make any minigames impossible.

It's very important to also consider that many of these interactable parasites will be near-impossible (but not entirely impossible! make sure to try them all out) to remove unless you know how to cure them. You'll find out how during the Parasites questline.

Finally, static parasites are just that - static. They're stuck on you forever, or until you find out how to cure them. It should be very clear to you if you're wearing one of these, since you simply won't have any way of escaping it.

## TO-DO

### Before alpha release
 - ~~custom menus for the various plugs (they shouldn't say stuff like "Vibrate" or "Inflate")~~
- ~~Go over everything and ensure there are no auto-patched locks (there shouldn't be a padlock on a tentacle skinsuit)~~
  - ~~sorta done - just need to make sure I don't forget to do this on every device~~
    - ~~Test to ensure no locks work~~
- ~~FaceHugger~~ ~~and FaceHuggerGag~~
- ~~ChaurusWorm and ChaurusWormVag~~
- ~~The entire spriggan set~~
- ~~custom sounds for vibration events~~
  - ~~sorta done - just need to test~~
  - LATER ~~must normalise all the sounds to make sure it's all consistent~~
- ~~Change from accessibility to some other form of difficulty for the devices~~
- ~~Basic documentation and readme~~
- ~~Add deflation success message~~
- ~~Finish off / polish off some devices~~
  - ~~ChaurusWorm~~
  - ~~ChaurusWormVag~~
  - ~~FaceHuggerGag~~
    - ~~add durability damage base~~
- ~~A minor round of testing to ensure each and every device works with every event~~
  - ~~ChaurusWorm~~
  - ~~ChaurusWormVag~~
  - ~~FaceHuggerGag~~
  - ~~SprigganArms~~
  - ~~SprigganBoots~~
  - ~~SprigganBody~~
  - ~~SprigganGag~~
- ~~A final round of testing to ensure every device works perfectly~~
- Add/fix flavour text:
  - ChaurusWorm
  - ChaurusWormVag
  - FacehuggerGag

### Post release
- Basic LL mod page
- More basic device features
  - ChaurusWorm
  - ChaurusWormVag
  - FaceHugger
  - FaceHuggerGag
- Invidiviual vib events for each device
- tons of testing to ensure the overall quest still works
- possibly incorporate some of the SL Parasites fixes I've seen around?
- Balance each one of the plugs with differing stats and effects (so it's not just the same plug reskinned)
  - add cuttability where it would make sense
  - softer and squishier ones would probably be quite strong against physical stuff but weak against magic, and harder ones the opposite
- Add buffs and debuffs to the player based on which parasite they have and what state the parasite is in
- Go hard on testing and normalizing all the sounds
- Automatic CI/CD
  - Trimmed READMEs, etc.
  - Spriggit <=> .esp (both ways - I make edits in both places)
  - scripts to .pex
  - build script to make it into FOMOD
    - with script sources and MO files as options
- Documentation about what this mod does somewhere (maybe as a nexus page or GH wiki?)

## Attributions and Credits

### Code
This project builds on the original [Sexlab Parasites](https://github.com/SkyrimLL/SkLLmods/tree/master/Parasites) by @deepbluefrog. The concept and all the original code belongs to them.

The project also uses the wonderful [Unforgiving Devices](https://github.com/IHateMyKite/UnforgivingDevices) by @IHateMyKite as the framework for its changes.

### Audio
Sounds under [CC-BY-NC 3.0](creativecommons.org/licenses/by-nc/3.0/):  
[Mud Squelching.wav](freesound.org/s/365246) by [Cally06](freesound.org/people/Cally06)

Sounds under [CC-BY 4.0](creativecommons.org/licenses/by/4.0/):  
[Slimy squelching flesh(comp,lmtr,dnsx2,Eq,lmtr).wav](freesound.org/s/536830) by [newlocknew](freesound.org/people/newlocknew)

Sounds under [CC0](creativecommons.org/publicdomain/zero/1.0/):  
[squelch.wav](freesound.org/s/423927) by [OutofPhaze](freesound.org/people/OutofPhaze) 