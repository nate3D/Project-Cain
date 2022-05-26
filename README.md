# [Godot] Project Cain
An open-source, community-developed 2D platformer using Godot. This is intended to be a fun learning project for myself and the community with the eventual goal to publish on the Steam marketplace.

### Game Concept
Project Cain will be a roguelite, dungeon-crawling 2D platformer. The concept is inspired from Binding of Isaac and Risk of Rain 1 & 2. Enemies will drop currency that the player will use to buy items from merchants hidden within the levels. These items will synergize and stack successively. At the end of each dungeon (stage) the player will face a boss fight to proceed to the next level in the dungeon. Successfully beating a boss will result in 3 random boss-pool items of which the player may choose only one for free.

## Features
 - Finite State Machine for handling player interaction ([FlavioFS FSM](https://github.com/FlavioFS/godot-platformer-state-machine))
 - DARK Series assets ([Penusbmic](https://penusbmic.itch.io/))
 - Eventual FREE Steam release!

## How does the state machine work (credit to FlavioFS)
The player finite state machine (aka. PlayerFSM) switches among 6 states:
 - [Air (StateAir)](godot/Scenes/Player/StateAir.gd)
 - [Idle (StateIdle)](godot/Scenes/Player/StateIdle.gd)
 - [Jump (StateJump)](godot/Scenes/Player/StateJump.gd)
 - [Ladder (StateLadder)](godot/Scenes/Player/StateLadder.gd)
 - [Swim (StateSwim)](godot/Scenes/Player/StateSwim.gd)
 - [Walk (StateWalk)](godot/Scenes/Player/StateWalk.gd)
 - [Run (StateRun)](godot/Scenes/Player/StateRun.gd)

Those states inherit from [BasePlayerState](godot/Scenes/Player/BasePlayerState.gd) and the machine is controlled by [PlayerFSM](godot/Scenes/Player/PlayerFSM.gd).

The player itself ([Player.gd](godot/Scenes/Player/Player.gd)), which is a KinematicBody2D node, runs the PlayerFSM every frame.

[FlavioFS MIT License](FlavioFS_License)

## Roadmap
- [x] Base Assets (DARK Series - [Penusbmic](https://penusbmic.itch.io/))
- [ ] Enemy AI
- [ ] Procedural map generation ([GDQuest](https://github.com/GDQuest/godot-procedural-generation))
- [ ] Modular (Procedural) weapons/items
- [ ] Item pools
- [ ] And much more to come...
