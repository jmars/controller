all: src/index.iced
	./node_modules/.bin/iced -cb -I inline -o . src 

build: components
	@component build --dev

components: component.json
	@component install --dev

clean:
	rm -fr build components template.js

.PHONY: clean
