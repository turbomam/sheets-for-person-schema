RUN = poetry run
PLACEHOLDER_TEXT = 'foreces creation/retention of this diretory'
SCHEMA_SOURCE = ../src/sheets_for_person_schema/schema/sheets_for_person_schema.yaml

TEMPLATE_DIR = templates/
TSV_OUTPUT_DIR = output_tsv/

.PHONY: all clean individually copy_prepopulateds

all: clean individually copy_prepopulateds output_yaml/roundtrip.yaml output_yaml/sheets_for_person_schema.yaml schema_diff

# refactor clean rule

clean:
	rm -rf output_json/*json
	mkdir -p output_json
	echo $(PLACEHOLDER_TEXT) > output_json/placeholder.txt
	rm -rf output_tsv/*tsv
	mkdir -p output_tsv
	echo $(PLACEHOLDER_TEXT) > output_tsv/placeholder.txt
	rm -rf output_yaml/*yaml
	mkdir -p output_yaml
	echo $(PLACEHOLDER_TEXT) > output_yaml/placeholder.txt

output_tsv/%.tsv: $(SCHEMA_SOURCE)
	poetry run linkml2sheets \
		--schema $< \
  		--output-directory $(TSV_OUTPUT_DIR) $(subst $(TSV_OUTPUT_DIR),$(TEMPLATE_DIR),$@)

individually: output_tsv/classes.tsv output_tsv/slots.tsv output_tsv/class_slot_associations.tsv

copy_prepopulateds:
	cp pre_populated/*.tsv output_tsv/

output_yaml/roundtrip.yaml:
	$(RUN) sheets2linkml \
		--output $@ output_tsv/*.tsv

# get the reference schema into a shape that matches the output of sheets2linkml, esp wrt prefixes
output_yaml/sheets_for_person_schema.yaml: $(SCHEMA_SOURCE)
	$(RUN) gen-linkml --format yaml --output $@ $<

schema_diff: output_yaml/roundtrip.yaml output_yaml/sheets_for_person_schema.yaml
	- jd -color --yaml $^

#  poetry run gen-linkml --help
  #Usage: gen-linkml [OPTIONS] YAMLFILE
  #
  #Options:
  #  -o, --output PATH               Name of JSON or YAML file to be created
  #  --materialize-patterns / --no-materialize-patterns
  #                                  Materialize structured patterns as patterns
  #                                  [default: no-materialize-patterns]
  #  --materialize-attributes / --no-materialize-attributes
  #                                  Materialize induced slots as attributes
  #                                  [default: materialize-attributes]
  #  -f, --format [json|yaml]        Output format  [default: json]
  #  --metadata / --no-metadata      Include metadata in output  [default:
  #                                  metadata]
  #  --useuris / --metauris          Include metadata in output  [default:
  #                                  useuris]
  #  -im, --importmap FILENAME       Import mapping file
  #  --log_level [CRITICAL|ERROR|WARNING|INFO|DEBUG]
  #                                  Logging level  [default: WARNING]
  #  -v, --verbose                   verbosity
  #  --mergeimports / --no-mergeimports
  #                                  Merge imports into source file
  #                                  (default=mergeimports)
  #  --help                          Show this message and exit.


# sheets2linkml --help
  #Usage: sheets2linkml [OPTIONS] [TSV_FILES]...
  #
  #  Convert schemasheets to a LinkML schema
  #
  #  Example:
  #
  #     sheets2linkml my_schema/*tsv --output my_schema.yaml
  #
  #  If your sheets are stored as google sheets, then you can pass in --gsheet-id
  #  to give the base sheet. In this case arguments should be the names of
  #  individual tabs
  #
  #  Example:
  #
  #      sheets2linkml --gsheet-id 1wVoaiFg47aT9YWNeRfTZ8tYHN8s8PAuDx5i2HUcDpvQ
  #      personinfo types -o my_schema.yaml
  #
  #Options:
  #  -o, --output FILENAME           output file
  #  -n, --name TEXT                 name of the schema
  #  --unique-slots / --no-unique-slots
  #                                  All slots are treated as unique and top
  #                                  level and do not belong to the specified
  #                                  class  [default: no-unique-slots]
  #  --repair / --no-repair          Auto-repair schema  [default: repair]
  #  --gsheet-id TEXT                Google sheets ID. If this is specified then
  #                                  the arguments MUST be sheet names
  #  -v, --verbose
  #  --help                          Show this message and exit.


# poetry run linkml2sheets --help
  #Usage: linkml2sheets [OPTIONS] [TSV_FILES]...
  #
  #Options:
  #  -o, --output TEXT               output file
  #  -d, --output-directory TEXT     folder in which to store resulting TSVs
  #  -s, --schema TEXT               Path to the schema  [required]
  #  --overwrite / --no-overwrite    If set, then overwrite existing schemasheet
  #                                  files if they exist  [default: no-overwrite]
  #  --append-sheet / --no-append-sheet
  #                                  If set, then append to existing schemasheet
  #                                  files if they exist  [default: no-append-
  #                                  sheet]
  #  --unique-slots / --no-unique-slots
  #                                  All slots are treated as unique and top
  #                                  level and do not belong to the specified
  #                                  class  [default: no-unique-slots]
  #  -v, --verbose
  #  --help                          Show this message and exit.

  #
  #  Convert LinkML schema to schemasheets
  #
  #  Convert a schema to a single sheet, writing on stdout:
  #
  #      linkml2sheets -s my_schema.yaml my_schema_spec.tsv > my_schema.tsv
  #
  #  As above, with explicit output:
  #
  #      linkml2sheets -s my_schema.yaml my_schema_spec.tsv -o my_schema.tsv
  #
  #  Convert schema to multisheets, writing output to a folder:
  #
  #      linkml2sheets -s my_schema.yaml specs/*.tsv -d output
  #
  #  Convert schema to multisheets, writing output in place:
  #
  #      linkml2sheets -s my_schema.yaml sheets/*.tsv -d sheets --overwrite
  #
  #  Convert schema to multisheets, appending output:
  #
  #      linkml2sheets -s my_schema.yaml sheets/*.tsv -d sheets --append
  #