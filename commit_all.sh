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
		#origin=$(git remote -v | awk '$3=="(push)" {print $1}')
		origin=$(git remote)
		branch=$2
		if [[ $2 == "--current" ]]; then 
			branch=$(git symbolic-ref --short HEAD)
		fi
		git push $origin $branch
	fi
}

origin_dir=$1
branch=$2
grep path './.gitmodules' | sed 's/.*= //' | while read -r p
do
	commit "${origin_dir}/${p}/" "$branch"
done

commit "$origin_dir" "$branch"

#git config --global alias.commitall '!sh "/../commit_all.sh" "$(realpath ${GIT_PREFIX:-.})"'