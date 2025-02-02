# GALACTIC PARADOX PROTOTYPE

## Controls
- `WASD` to accelerate in a direction relative to mouse position.
- `ESCAPE` or `TAB` to open upgrade menu
- `LEFT MOUSE BUTTON` to fire weapon

## TODO / KNOWN ISSUES
	- Issue: Player can go into debt in the upgrade menu
	- Todo: Refactor 'working' code to follow code goals/principles
		- Example entities updates to extend base entities. 
		- Define Ship class and refactor Player class (prepares for Pilot Classes/AI)
	- Todo: Expose remaining game state variables to upgrades menu
	- Todo: Implement 'Goal Gameplay' mode
	- Pie in sky:
		- Customizable ship colors
			- Try using a grey pallete asset with a shader to target specific shades.
	

## Mission
- Explore a fusion of Randomness, Player decision making, Decision consequences, and Mutual escalation.
- If gameplay loop has legs, consider alternative settings and movement like gladiators in gladiator arenas.

## Current Gameplay
	- Player starts with basic ship.
	- Player destroys crates.
	- Destroyed crates drop gold flakes.
	- Player collects gold flakes.
	- Player manipulated game variables with gold flakes (I.E. Player max speed, acceleration, bullet speed, mob spawn rate, mob density, etc)
	- Repeat with tweaked game variables.
	- Autopilot mode:
		- Removes player control of ship
		- Ship maintains velocity at time of activation
		- Reduces efficacy of player improvements while active
		- Ship auto-targets nearest crate and fires

## Goal Gameplay (high level):
	- Upgrades contain a player benefit and an enemy benefit.
	- Upgrades are generated by randomly selecting and pairing a player benefit and enemy benefit
		- Example: 
			- SAVAGE:
				- Player: +15% damage to all attacks.
				- Enemy: +10% spawn rate (more enemies per wave).
	- Player is presented with N upgrade options at some cadence (trigger TBD).
	- Player must take one upgrade option, weighing the risk and reward of each.
	- Every time the player improves, the enemy improves.
	- Player goal is leaderboard centric, time alive and currency collected.

### Example/WIP Abilities

#### Offensive:
	- SAVAGE:
		- Player: +15% damage to all attacks.
		- Enemy: +10% spawn rate.
	
	- PRECISION:
		- Player: Increase critical hit chance by 10%.
		- Enemy: +5% max health.
	
	- CLEAVE:
		- Player: Bullets gain/increase AoE damage.
		- Enemy: +10% movement speed.

#### Defensive:
	- TBD:
		- Player: Gain an extra shield that absorbs damage.
		- Enemy: Chance to spawn with shields.

	- TBD:
		- Player: Reduce damage taken from projectiles by 20%.
		- Enemy: Kamikaze enemies deal 10% more damage.

	- TBD:
		- Player: +10% max health.
		- Enemy: Regenerate 5% of max health per second while not engaged.

#### Utility:
	- TBD:
		- Player: +X seconds to bullet time duration.
		- Enemy: +X% projectile speed.

	- TBD:
		- Player: Increase movement speed by X%.
		- Enemy: Spawn X% closer to the player.

	- TBD: 
		- Player: +X% currency earned from defeated enemies.
		- Enemy: Drop explosive hazards upon death.

	- TBD:
		- Player: +X% Bullet speed.
		- Enemy: +X% chance to disable player movement on hit.


#### Guiding Design Principles for Balanced Upgrades:
- Distinct Impacts:
	- Ensure the player and enemy benefits impact different aspects of gameplay. 
	- For example, we don't want to offer a player +20 damage, and enemies -10% damage taken. The two cancel each other out, and is really just a +10 player damage upgrade. That's not fun or challenging.
- Strategic Tension:
	- Upgrades should force the player to consider trade-offs in their playstyle or tactics. 
	- For example, faster enemies might make a sniper build harder to execute, while explosive hazards encourage careful positioning.
- Synergy Opportunities:
	- Some upgrades can be designed to open up synergy, while others might disrupt it. 
	- For example, projectile piercing could work well with a crowd control ability but is countered by enemies with shields.
- Long-Term Consequences:
	- Some upgrades should have compounding effects that become more pronounced in later waves, encouraging the player to think ahead. For instance, faster enemies might not feel overwhelming early but could become a problem with higher enemy spawn rates in later waves.


## Code principles/goals (WIP)
- Aim to have completely interchangable entities. 
	- All Projectiles/Guns should work with all Ships.
	- All Pilots should work with all Ships. 
	- All Dropables/Effects should work with all Ships and Projectiles.
	- If done correctly, each component of the game should be expandable and 'just work'.
		- Add a new projectile? Attach to any ship. Vise versa.
	
	- Pilot Class:
		- This is AI.
		- Interacts with Ship API to execute tasks
		- Owns a Ship (ships should not care who is operating, player or AI)
	- Ship Class:
		- var Base max speed
		- var Base rotation speed
		- var Base acceleration speed
		- var Base deceleration speed
		- Owns Projectiles
		- Owned by Pilot
		- Executes will of Pilot, movement and firing of weapons.
		- On destruction, instantiates and deploys any Destruction Effect and Droppable Loot classes.
	- Destruction Effect Class:
		- Owned by destructable entities, is instantiated on parent destruction
	- Collectible Class:
		- Owned by destructable entities, is instantiated on parent destruction
		- Has `set_target` method, monitorable by player gravitational field.
	- Impact Effect Class:
		- Owned by Projectile, is instantiated on allowed collision and reparented to collision target. 
		- `_ready` method manipulates parent node, cleans self up. 
	- Projectile Class:
		- var Base damage
		- var Base speed
		- var Base time_in_space
		- Owned by Ships, enables primary/secondary fire.
	- Despawner Class:
		- var time allowed off screen
		- Owned by any entity
		- Despawns parent after time off screen exceeds set variable
	- Spawner Class:
		- var mob_list (what things it can spawn)
		- var base spawn rate (how often something is spawned)
		- var base max density (how many are allowed on screen at a given time)
		- Owned by Game/root scene.
		- Handles spawning relevant mobs in accordance to set vars
	- GameState Class:
		- Global entity
		- Provides public api for private state
		- Leverages ENUMS to guarantee clean access throughout codebase
	
