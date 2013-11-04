all: dist/build/ring3bot/ring3bot

CONFIG_DEFINITION=lib/config.atd
CONFIG_PARSER=lib/config_j.ml
CONFIG_TYPES=lib/config_t.ml

$(CONFIG_PARSER): $(CONFIG_DEFINITION)
	atdgen -j $(CONFIG_DEFINITION)

$(CONFIG_TYPES): $(CONFIG_DEFINITION)
	atdgen -t $(CONFIG_DEFINITION)

dist/setup: $(CONFIG_PARSER) $(CONFIG_TYPES) ring3bot.obuild
	obuild configure

dist/build/ring3bot/ring3bot: dist/setup
	obuild build

.PHONY: clean
clean:
	rm -f $(CONFIG_PARSER)*
	rm -f $(CONFIG_TYPES)*
	rm -rf dist
