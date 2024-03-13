quick_push() {
repo="$1"
branch="$2"
echo $dir
git status
read -rep "Enter message to add all files and commit $repo."$'\n>' message < /dev/tty

if [[ "$message" == "--exit" ]]; then
		exit -1
	fi
	
if [[ -z $message ]] || [[ "$message" == "--skip" ]]; then
	return 1
fi
	
git add .
git commit -m "$message"
	
if [[ ! -z "$2" ]]; then
	origin=$(git remote -v | awk '$3=="(push)" {print $1}')
	branch=$2
	if [[ $2 == "--current" ]]; then 
		branch=$(git rev-parse --abbrev-ref HEAD)
	fi
	git push $origin $branch
fi
}

repo=$1
branch=$2
quick_push "$repo" "$branch"

#git config --global alias.quickpush '!sh "/../quick_push.sh" "$(realpath ${GIT_PREFIX:-.})"'