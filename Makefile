all: dist/build/ring3bot/ring3bot

dist/setup: ring3bot.obuild
	obuild configure

dist/build/ring3bot/ring3bot: dist/setup
	obuild build

.PHONY: clean
clean:
	rm -rf dist
