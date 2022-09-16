RUN = poetry run
PLACEHOLDER_TEXT = 'forces creation/retention of this directory'

# personinfo.yaml
# sheets_for_person_schema.yaml
SCHEMA_SOURCE = ../src/sheets_for_person_schema/schema/personinfo.yaml

SAMPLE_DATA = ../src/data/examples/example_personinfo_data.yaml
ROUNDTRIP_TEMP = roundtrip_temp.yaml

TEMPLATE_DIR = templates/
TSV_OUTPUT_DIR = output_tsv/

.PHONY: \
all \
clean \
copy_prepopulateds \
individually \
schema_diff \
validate_with_reference \
validate_with_roundtrip

all: multiclean validate_with_reference schema_diff validate_with_roundtrip

clean-%:
	echo $(subst clean-,,$@)
	rm -rf output_$(subst clean-,,$@)/*$(subst clean-,,$@)
	mkdir -p output_$(subst clean-,,$@)
	echo $(PLACEHOLDER_TEXT) > output_$(subst clean-,,$@)/placeholder.txt

multiclean: \
clean-tsv \
clean-yaml

# Do not run this rule directly. Add explicit desired targets as dependencies of the individually rule
output_tsv/%.tsv: $(SCHEMA_SOURCE)
	poetry run linkml2sheets \
		--schema $< \
		--output-directory $(TSV_OUTPUT_DIR) $(subst $(TSV_OUTPUT_DIR),$(TEMPLATE_DIR),$@)

# these patterns say "use the output_tsv/%.tsv rule to populate a tsv from the schema according to the matching template"
individually: \
output_tsv/class_slot_associations.tsv \
output_tsv/class_slot_lists.tsv \
output_tsv/classes.tsv \
output_tsv/enums.tsv \
output_tsv/slots.tsv \
output_tsv/subsets.tsv

# linkml2sheets can't currently populate every imaginable kind of template, so we provide some pre-populated tsvs
copy_prepopulateds: multiclean individually
	cp pre_populated/*.tsv output_tsv/

# yq-delete some attributes that we don't want to diff
# and uniqify mixins lists?
# todo generalize the yq cleanup
output_yaml/roundtrip.yaml: copy_prepopulateds
	rm -rf  $(ROUNDTRIP_TEMP)
	$(RUN) sheets2linkml output_tsv/*.tsv >  $(ROUNDTRIP_TEMP)
	# additional gen-linkml required to convert string min/max to integer?
	$(RUN) gen-linkml --no-materialize-attributes  --format yaml  $(ROUNDTRIP_TEMP) | \
		yq 'del(.. | select(has("from_schema")).from_schema)' | \
		yq 'del(.. | select(has("source_file")).source_file)' | \
		yq '(... | select(type == "!!seq")) |= unique' | \
		yq '(... | select(type == "!!seq")) |= sort' > $@
	rm -rf  $(ROUNDTRIP_TEMP)

# get the reference schema into a shape that matches the output of sheets2linkml, esp wrt prefixes
output_yaml/regenerated_reference.yaml: $(SCHEMA_SOURCE)
	$(RUN) gen-linkml --no-materialize-attributes --format yaml $< | \
		yq 'del(.. | select(has("from_schema")).from_schema)' | \
		yq 'del(.. | select(has("source_file")).source_file)' | \
		yq '(... | select(type == "!!seq")) |= unique' | \
		yq '(... | select(type == "!!seq")) |= sort' > $@

schema_diff: output_yaml/roundtrip.yaml output_yaml/regenerated_reference.yaml
	- jd -color --yaml $^

validate_with_reference: $(SCHEMA_SOURCE)
	$(RUN) linkml-validate \
		--schema $< \
		--target-class Container  $(SAMPLE_DATA)

validate_with_roundtrip: output_yaml/roundtrip.yaml
	$(RUN) linkml-validate \
		--schema $< \
		--target-class Container  $(SAMPLE_DATA)

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