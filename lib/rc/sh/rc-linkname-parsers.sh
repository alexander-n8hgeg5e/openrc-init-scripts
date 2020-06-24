

parse_svcdata(){
	# The RC_SVCNAME/linkname/(here ${1}) consists of 3 parts
	# devided by underscore.
	# The prefix is not used.

	# need to opererate on:
	# ${prefix}_${node-or-hostname}_${service-description_or_something_with_underscores}
	
	#  # := rm shortest prefix 
	# %% := rm longest suffix
	# ## := rm longest prefix
	
	
	# remove prefix
	local without_prefix="${1#*_}"
	declare -A svcdata
	
	# name after first underscore
	svcdata[name]="${without_prefix#*_}"
	
	# remove the longest ending
	# the name will have underscores in it
	svcdata[node]="${without_prefix%%_*}"
}
