extends Resource
## Class data.
## Made by Yni, licensed under MIT license.
class_name GameData

## Protagonist puppet class
@export var puppet_class: Array[PuppetClass]
## Ally puppet class
@export var friend_puppet_class: Array[PuppetClass]
## Enemy puppet class
@export var enemy_puppet_class: Array[PuppetClass]
## Neutral puppet class
@export var neutral_puppet_class: Array[PuppetClass]
