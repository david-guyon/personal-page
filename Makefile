port = 9000

all: build

build: hakyll
	./site build

hakyll: site.hs
	ghc --make site.hs
	./site clean

new:
	@./new_post.sh

preview: hakyll
	./site preview -p $(port)

clean: hakyll
	./site clean
