quick_pull() {	
cd "$1"
echo "------------------"
dir="${PWD##*/}"
repo="$1"
branch="$2"
echo $dir
git status

origin=$(git remote -v | awk '$3=="(push)" {print $1}')
branch=$2
if [[ $2 == "--current" ]]; then 
	branch=$(git rev-parse --abbrev-ref HEAD)
fi
git pull $origin $branch
}

origin_dir="$1"
branch="$2"
grep path './.gitmodules' | sed 's/.*= //' | while read -r p
do
	quick_pull "${origin_dir}/${p}/" "$branch"
done

quick_pull "$origin_dir" "$branch"

#git config --global alias.pullall '!sh "/../pull_all.sh" "$(realpath ${GIT_PREFIX:-.})"'