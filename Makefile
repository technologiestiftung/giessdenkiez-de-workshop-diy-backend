.DEFAULT_GOAL := build
build:
	@pandoc \
	--to=revealjs \
	--highlight-style=zenburn \
	--template=src/default.revealjs \
	--standalone \
	--output=docs/index.html \
	src/slides.md \
	--slide-level=2 \
	--variable theme=simple \
	--variable height="'100%'" \
	--variable width="'100%'" \
	--variable margin=0.2 \
	--variable minScale=1 \
	--variable maxScale=1 \
	--variable transition=fade \
	--variable revealjs-url=https://unpkg.com/reveal.js ;
	@mkdir -p docs/assets/{css,images}
	@cp -R ./src/assets/* docs/assets/ ;
	@echo "pandoc build and assets copy successful"

docker:
	docker compose up
serve:
	@npx reload -p 3000 --dir ./docs

watch: docker
	@npx chokidar "./src/*.md" "./src/assets/css/*.css" -c "make docker"

clean:
	@rm -rf ./docs/* && touch ./docs/.gitkeep