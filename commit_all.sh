submodules(){
	local path="$1"
	local branch="$2"
	gitmodules='./.gitmodules'
	
	echo "Checking for submodules in $path"
	
	if [[ ! -f $gitmodules ]]; then
		echo "No submodules found in $path"
		return 1
	fi
	
	grep path $gitmodules | sed 's/.*= //' | while read -r p
	do
		echo "Found submodule $p"
		commit "${path}/${p}/" "$branch"
		echo "Returning to Parent module $path"
		cd "$path" #return to parent path after each iteration
	done
}

commit(){
	local path="$1"
	local branch="$2"
	
	cd "$path"
	local name="${PWD##*/}" #get the name of the git repo's directory to use as name
	
	submodules "$1" "$2"
	echo "------------------"
	echo "QuickPushing $name from $path on branch $branch...";
	git status
		
	if [[ ! `git status --porcelain` ]]; then
		return 1
	fi
	
	read -rep "Enter message to add all files and commit $name, or [--exit] to stop the process."$'\n>' message < /dev/tty
	
	if [[ "$message" == "--exit" ]]; then
		exit -1
	fi
	
	if [[ -z $message ]] || [[ "$message" == "--skip" ]]; then
		return 1
	fi
	
	git add .
	git commit -m "$message"
	
	if [[ ! -z "$2" ]]; then
		origin=$(git remote)
		gitbranch=$2
		if [[ -z $2 ]] || [[ $2 == "--current" ]]; then 
			gitbranch=$(git symbolic-ref --short HEAD)
		fi
		echo "$origin $gitbranch"
		git push $origin $gitbranch
	fi
}

commit "$1" "$2" ''

#git config --global alias.commitall '!sh "/../commit_all.sh" "$(realpath ${GIT_PREFIX:-.})"'