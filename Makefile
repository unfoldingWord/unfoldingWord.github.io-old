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
	git commit publish -m 'Publishing site'
	git push origin master
