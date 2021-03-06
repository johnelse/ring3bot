all: build

J=4

CONFIG_DEFINITION=lib/config.atd
CONFIG_PARSER=lib/config_j.ml
CONFIG_TYPES=lib/config_t.ml

$(CONFIG_PARSER): $(CONFIG_DEFINITION)
	atdgen -j $(CONFIG_DEFINITION)

$(CONFIG_TYPES): $(CONFIG_DEFINITION)
	atdgen -t $(CONFIG_DEFINITION)

setup.ml: _oasis
	oasis setup

setup.data: setup.ml
	ocaml setup.ml -configure

build: setup.data setup.ml $(CONFIG_PARSER) $(CONFIG_TYPES)
	ocaml setup.ml -build -j $(J)

clean:
	ocamlbuild -clean
	rm -f $(CONFIG_PARSER)*
	rm -f $(CONFIG_TYPES)*
	rm -f setup.data setup.log
