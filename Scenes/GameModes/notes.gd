extends Node

#This is just my updates and bug listing section for Logan/Adam/Myself

#Known bugs:
#- Food can instantiate inside of tail and other food entities
#	- Current attempt to abade this is grab random spawnpoint, check if inside snakes position array, update random spawn if yes
#- Cannot delete tail in reverse order one by one as desired, this was functioning before connecting speed/map buttons?
#	- Currently bandaided by reverting to just deleting the entire tail at once, which works just fine.

#Next steps:
#- Fix, at the least, first known bug


#<emitting_node>.connect("signal_name", <target_node>, "target_method_name")
