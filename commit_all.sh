commit(){
	cd "$1"
	echo "------------------"
	dir="${PWD##*/}"
	echo $dir
	git status
		
	if [[ ! `git status --porcelain` ]]; then
		return 1
	fi
	
	read -rep "Enter message to add all files and commit $dir, or [--exit] to stop the process."$'\n>' message < /dev/tty
	
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

origin_dir="$1"
branch="$2"
grep path './.gitmodules' | sed 's/.*= //' | while read -r p
do
	commit "${origin_dir}/${p}/" "$branch"
done

commit "$origin_dir" "$branch"

#git config --global alias.commitall '!sh "/../commit_all.sh" "$(realpath ${GIT_PREFIX:-.})"'