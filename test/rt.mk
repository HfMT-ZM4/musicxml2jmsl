SCORES=./scores
FILENAMES=test1
OUTPUT:=$(foreach f, $(FILENAMES), $(SCORES)/jmsl4/$(f).XML)

.PRECIOUS: $(foreach f, $(FILENAMES), $(SCORES)/jmsl2/$(f).XML) \
$(foreach f, $(FILENAMES), $(SCORES)/musicxml/$(f).XML)\
$(foreach f, $(FILENAMES), $(SCORES)/jmsl3/$(f).XML)\
$(foreach f, $(FILENAMES), $(SCORES)/jmsl4/$(f).XML)

.PHONY: all
all: $(OUTPUT) 

$(SCORES)/jmsl4/%.XML: $(SCORES)/jmsl3/%.XML
	java -jar jmslwriter.jar jmsl $(SCORES)/jmsl3 $(SCORES)/jmsl4 $(notdir $@)

$(SCORES)/jmsl3/%.XML: $(SCORES)/musicxml/%.XML
	node ../musicxml2jmsl.js $< 1> $@ 2> $(SCORES)/skipped/$(basename $(notdir $@)).JSON

$(SCORES)/musicxml/%.XML: $(SCORES)/jmsl2/%.XML
	java -jar jmslwriter.jar musicxml $(SCORES)/jmsl2 $(SCORES)/musicxml $(notdir $@)

$(SCORES)/jmsl2/%.XML: $(SCORES)/jmsl1/%.XML
	java -jar jmslwriter.jar jmsl $(SCORES)/jmsl1 $(SCORES)/jmsl2 $(notdir $@)

.PHONY: clean clean-jmsl2 clean-jmsl3 clean-jmsl4 clean-musicxml clean-skipped
clean-jmsl4:
	rm -rf $(SCORES)/jmsl4/*
clean-jmsl3:
	rm -rf $(SCORES)/jmsl3/*
clean-musicxml:
	rm -rf $(SCORES)/musicxml/*
clean-jmsl2:
	rm -rf $(SCORES)/jmsl2/*
clean-skipped:
	rm -rf $(SCORES)/skipped/*
clean: clean-jmsl2 clean-jmsl3 clean-jmsl4 clean-musicxml clean-skipped
