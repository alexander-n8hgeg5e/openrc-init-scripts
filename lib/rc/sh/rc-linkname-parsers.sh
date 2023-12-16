
declare -A svcdata

parse_svcdata(){
	# The RC_SVCNAME/linkname/(here ${1}) consists of 3 parts
	# devided by underscore.
	# The prefix is not used.

	# need to opererate on:
	# ${prefix}_${node-or-hostname}_${service-description_or_something_with_underscores}
	#                                       .__            --.
	#                  /|\                  | \    /|\      /|
	#                   |                      \    |      /
	#              svcdata[node]               svcdata[name]
	
	#  # := rm shortest prefix 
	# %% := rm longest suffix
	# ## := rm longest prefix
	
	
	# remove prefix
	local without_prefix="${RC_SVCNAME#*_}"
	
	# name after first underscore
	svcdata[name]="${without_prefix#*_}"
	
	# remove the longest ending
	# the name will have underscores in it
	svcdata[node]="${without_prefix%%_*}"
}
