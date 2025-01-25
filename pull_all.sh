submodules(){
	local path="$1"
	local branch="$2"
	gitmodules='./.gitmodules'
	
	#echo "Checking for submodules in $path"
	
	if [[ ! -f $gitmodules ]]; then
		#echo "No submodules found in $path"
		return 1
	fi
	
	grep path $gitmodules | sed 's/.*= //' | while read -r p
	do
		#echo "Found submodule $p"
		quick_pull "${path}/${p}/" "$branch"
		#echo "Returning to Parent module $path"
		cd "$path" #return to parent path after each iteration
	done
}

quick_pull() {
	local path="$1"
	local branch="$2"
	
	cd "$path"
	local name="${PWD##*/}"
	
	submodules "$path" "$branch"
	echo "------------------"
	echo $name
	git status

	local origin=$(git remote -v | awk '$3=="(push)" {print $1}')
	if [[ $branch == "--current" ]]; then 
		branch=$(git rev-parse --abbrev-ref HEAD)
	fi
	git pull $origin $branch
}

quick_pull "$1" "$2"

#git config --global alias.pullall '!sh "/../pull_all.sh" "$(realpath ${GIT_PREFIX:-.})"'