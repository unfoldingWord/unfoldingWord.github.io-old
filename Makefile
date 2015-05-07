stat:
	git status -s

build:
	jekyll build

commit:
	git diff >/tmp/git-diff.out 2>&1
	git commit -a
	git pull --no-edit origin master
	git push origin master

publish:
	touch publish
	git add publish
	git commit publish -m 'Publishing site'
	git push origin master
	sleep 2
	echo "Check https://unfoldingword.org/ in a moment"
	sleep 2
	rm -f publish
	git commit publish -m 'Cleaning up'
	git push origin master
