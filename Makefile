stat:
	git branch
	git status -s

test: stat
	./cibuild.sh

build: test

install:
	bundle install

serve: test
	bundle exec jekyll serve

commit: test
	git diff >/tmp/git-diff.out 2>&1
	git commit -a
	git pull --no-edit
	git push
	echo "Ensure the build completed https://travis-ci.org/unfoldingWord/unfoldingword.github.io"
	echo "Check http://test-unfoldingword.org.s3-website-us-west-2.amazonaws.com in a moment"

publish: test
	@read -p "Merge develop into master? <Ctrl-C to break>"
	git checkout develop
	git merge master
	git checkout master
	git merge develop
	git push origin master
	echo "Ensure the build completed https://travis-ci.org/unfoldingWord/unfoldingword.github.io"
	echo "Check https://unfoldingword.org/ in a moment"
	git checkout develop
