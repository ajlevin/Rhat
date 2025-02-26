# Rhat **(Name Pending)*
### Nicole Ruedger & Asa Levine

## Overview:
The Rhat* project aims to take the classic metroidvania style and explore the inner journey one takes in the process of self-growth. 
As the player traverses through realms of their mind palace, they must contend with the psychosomatic manifestation of all that holds
them back, either conquering or falling to this darker entity. However, this entity is as alive as the player, growing and learning
with the player. Using a modified reinforcement learning algorithm, this mirrored entity learns to find the weaknesses and flaws
in the players mindset and exploit it in an attempt to end their journey the time. 

## Architecture:
The game has a few key pieces of architecture that form the skeleton of the game. They compose the world, the entities, and the behaviors of the nemesis.
The latter of the aformentioned is the most complex of the three, containing the reinforcement model that determines its growth. 

#### World Control
The world and its different realms is controlled by a Stage Controller that waits for alerts from various triggers placed around each stage.
Upon hitting a trigger, it phases out the entirety of the current stage and moves to the triggered stage through a quick transition animation.
All stages and their associated tilemaps are independent from one another and loaded and deloaded purely by the external controller. Each controller
contains only the information neeeded to properly generate all needed entities, animate its componenets, and deconstruct itself once finished.

There exists 3 (as of now) realms -- The intro realm, the anxiety realm, and the nemesis' lair. Each will be punctuated with a confrontation with this
enigmatic nemesis that will plague the player throughout the game, but the player must first safely navigate each realm to arrive before them.

#### Entity Control
Every entity in the game functions with a few basic universal data models. Shared between all is the hitbox and hurtbox code that controls all damaging
interactions between entities. Additionally, there is a few variations of a very similar stat script that controls how the stats (most importantly 
being health) are controlled for each unique entity type. The behavior of each unique entity type is controlled by a finite state machine designed
for each entity type (player and nemesis included, as unique as they are). This state machine merely moves between the needed states for an entity,
allowing for dynamic behavior modification as needed. The player and nemesis both use more complex versions of the generic state machines found for 
most other entities due to the player interaction of the former and the machine learning model for the latter, but the fundamental aspects of it mirror
their more mundance counterparts.

#### The Machine Learning model
*This section will be updated with more technical details as the implementation is developed is continued*
The Nemesis (or Nem as it'll often be referred to) is the shadowed entity harassing the player as they journey through their interal environments.
Nem will appear a few times throughout the journey, attacking the player at the end of each zone with a new learnt behavior from watching the player's
behaviors as they've traveled. Nem contains the exact same moveset as the player, as their being is a mirror of the player themselves as they seek to
change. Nem achieves this dynamic learning through the use of a pseudo-bayesian reinforcement learning model that watches the player and aims to tune
a set of parameter ranges to fairly counter the player's behavior. Should the player be more aggressive, the model will play defensive. If the player
likes the play slow, then Nem will take the fight to them. The model tunes a set of values within a predetermined range in order to maximize the player's
defeat and Nem's survival. However, the values are kept bound within a range to keep it fair, as should Nem be fully unchained, there is little one can 
do at the mercy of one who knows every move one makes. 
