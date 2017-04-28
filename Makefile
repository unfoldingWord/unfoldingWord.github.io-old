stat:
	git branch
	git status -s

test: stat
	./cibuild.sh

build: test

assets:
	./assets_sync.sh

install:
	bundle install

serve: test
	bundle exec jekyll serve

commit: test
	git diff >/tmp/git-diff.out 2>&1
	git commit -a
	git pull --no-edit
	git push
	echo "Ensure the build completed https://travis-ci.org/unfoldingWord/unfoldingWord.github.io"
	echo "Check http://test-unfoldingword.org.s3-website-us-west-2.amazonaws.com in a moment"

publish: test
	echo "Submit a PR at https://github.com/unfoldingWord/unfoldingWord.github.io/pulls"
