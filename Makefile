# vim: noet sw=4 ts=4

.PHONY : all
all : _site

_site : \
		_vendor \
		docs \
		favicon.ico \
		images/icons/blocked-21.png \
		images/icons/done-21.png \
		images/icons/maybe-21.png \
		images/icons/todo-21.png \
		images/icons/wip-21.png \
		images/logo-128.png \
		images/logo-64.png \
		images/logotype-600.png \
		images/sun-200.png \
		images/sunt-200.png
	bundle exec jekyll build

.PHONY : serve
serve : _site
	bundle exec jekyll serve --drafts

_vendor : Gemfile
	bundle install --path _vendor/bundle

images/icons/todo-21.png: _images-original/todo.png images/icons
	convert $< -resize 21x21 $@
images/icons/done-21.png: _images-original/done.png images/icons
	convert $< -resize 21x21 $@
images/icons/blocked-21.png: _images-original/blocked.png images/icons
	convert $< -resize 21x21 $@
images/icons/wip-21.png: _images-original/wip.png images/icons
	convert $< -resize 21x21 $@
images/icons/maybe-21.png: _images-original/maybe.png images/icons
	convert $< -resize 21x21 $@

images/logo-64.png: _images-original/logo-v1.png images
	convert $< -resize 64x64 $@
favicon.ico: images/logo-64.png
	cp $< $@
images/sun-200.png: _images-original/sun.png images
	convert $< -resize 200x200 $@
images/sunt-200.png: _images-original/sunt.png images
	convert $< -resize 200x200 $@
images/logotype-600.png: _images-original/logotype-v1.png images
	convert $< -resize 600x315 $@
images/logo-128.png: _images-original/logo-v1.png images
	convert $< -resize 128x128 $@

images/icons:
	mkdir -p $@

images:
	mkdir -p $@

.PHONY: docs
docs: docs/index.html \
	docs/C_style.html \
	docs/Mercury_style.html \
	docs/bugtracking.html \
	docs/compiler_internals.html \
	docs/concept_map.html \
	docs/contributing.html \
	docs/design_principles.html \
	docs/getting_started.html \
	docs/grades.html \
	docs/howto_make_pr.html \
	docs/plasma_ref.html \
	docs/pz_format.html \
	docs/pz_machine.html \
	docs/references.html \
	docs/ideas.html \
	docs/types.html

docs/index.txt: ../plasma/docs/index.txt
	cp $< $@

docs/C_style.txt: ../plasma/docs/C_style.txt
	cp $< $@
docs/Mercury_style.txt: ../plasma/docs/Mercury_style.txt
	cp $< $@
docs/bugtracking.txt: ../plasma/docs/bugtracking.txt
	cp $< $@
docs/compiler_internals.txt: ../plasma/docs/compiler_internals.txt
	cp $< $@
docs/concept_map.txt: ../plasma/docs/concept_map.txt
	cp $< $@
docs/contributing.txt: ../plasma/docs/contributing.txt
	cp $< $@
docs/design_principles.txt: ../plasma/docs/design_principles.txt
	cp $< $@
docs/getting_started.txt: ../plasma/docs/getting_started.txt
	cp $< $@
docs/grades.txt: ../plasma/docs/grades.txt
	cp $< $@
docs/howto_make_pr.txt: ../plasma/docs/howto_make_pr.txt
	cp $< $@
docs/plasma_ref.txt: ../plasma/docs/plasma_ref.txt
	cp $< $@
docs/pz_format.txt: ../plasma/docs/pz_format.txt
	cp $< $@
docs/pz_machine.txt: ../plasma/docs/pz_machine.txt
	cp $< $@
docs/references.txt: ../plasma/docs/references.txt
	cp $< $@
docs/ideas.txt: ../plasma/docs/ideas.txt
	cp $< $@
docs/types.txt: ../plasma/docs/types.txt
	cp $< $@

%.html : %.txt docs/_asciidoc.conf
	asciidoc --conf-file docs/_asciidoc.conf -o $@ $<

.PHONY: clean
clean:
	rm -rf images _site docs/*.txt docs/*.html Gemfile.lock

.PHONY: upload
upload: all
	rsync -crv \
		--exclude Gemfile \
		--exclude Gemfile.lock \
		--exclude README.md \
		--exclude LICENSE.md \
		--exclude CONTRIBUTING.md \
		--exclude Makefile \
		--exclude images-original \
		--del _site/ champagne:/srv/www/plasmalang/

