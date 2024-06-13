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

### Post release
- Change all of below into github issues
- More basic device features
  - ChaurusWorm
  - ChaurusWormVag
  - FaceHugger
  - FaceHuggerGag
- Add more parasite features
  - Invidiviual vib events for each device
  - look into the other modifiers too, I think there are some good ones lying around
  - Add buffs and debuffs to the player based on which parasite they have and what state the parasite is in
- tons of testing to ensure the overall quest still works
- possibly incorporate some of the SL Parasites fixes I've seen around?
- Convert entirety of SL Parasites (or as much as is beneficial) into UD to make it easier to add more things to it

### Maybe
- Implement the whole cure thing into UD (i.e. having a certain item will make minigames easier and decrease the likelihood of some events)
  - probably as a modifier
- Implement the retaliation thing into UD as well
  - probably as a modifier
  - definitely add ways for it to have custom dialogue and/or custom messages
  - maybe tie it into the cure mechanic
- Add an option for the Loot Item modifier in UD to equip the item onto the player (e.g. you could have it give you skooma)
  - not sure if this exists yet, but add something like Midas and make it give items instead of gold
    - probably overhaul Midas to do that instead
- Add a way for a device to have UD spit out alternate equipfilter and equippre text (which would remove the need for the hacky workaround that I currently use)

## Attributions and Credits

### Code
This project builds on the original [Sexlab Parasites](https://github.com/SkyrimLL/Skyrim/tree/main/SE/Parasites) by [deepbluefrog](https://github.com/SkyrimLL). The concept and all the original code belongs to them.

The project also uses the wonderful [Unforgiving Devices](https://github.com/IHateMyKite/UnforgivingDevices) by [IHateMyKite](https://github.com/IHateMyKite) as the framework for its changes.

I used [Wenderer](https://next.nexusmods.com/profile/Wenderer/about-me?gameId=1151)'s excellent [FOMOD creation tool](https://www.nexusmods.com/fallout4/mods/6821) to create the FOMOD `.xml`s.

The Papyrus scripts are compiled by [Orvid](https://github.com/Orvid)'s lightning-fast and very cool [Caprica](https://github.com/Orvid/Caprica) compiler.

You may wonder why there's no `.esp` in this repo. That's because it uses the amazing [Spriggit](https://github.com/Mutagen-Modding/Spriggit) by [Noggog](https://github.com/Noggog)! If you want to develop a mod, definitely check it out - it may save you a headache as your projects get big. I also repurposed for this project the build script that I believe he developed for the Starfield Community Patch.

### Audio
Sounds under [CC-BY-NC 3.0](creativecommons.org/licenses/by-nc/3.0/):  
[Mud Squelching.wav](freesound.org/s/365246) by [Cally06](freesound.org/people/Cally06)

Sounds under [CC-BY 4.0](creativecommons.org/licenses/by/4.0/):  
[Slimy squelching flesh(comp,lmtr,dnsx2,Eq,lmtr).wav](freesound.org/s/536830) by [newlocknew](freesound.org/people/newlocknew)

Sounds under [CC0](creativecommons.org/publicdomain/zero/1.0/):  
[squelch.wav](freesound.org/s/423927) by [OutofPhaze](freesound.org/people/OutofPhaze) 