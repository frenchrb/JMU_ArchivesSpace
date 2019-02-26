* ASpace2MARCXML.xsl creates MARC record from EAD exported from ArchivesSpace
* ASpace2VaHeritage.xsl modifies ArchivesSpace EAD for upload to Virginia Heritage
* ASpace2HTML.xsl and ASpace2HTMLabstract.xsl create finding aid and abstract snippet for website. For finding aids with multiple container types, use ASpace2HTML-gencontainer.xsl instead.

To run Spaceport with GUI: ```python spaceportGUI.py```

To run Spaceport from the command line: ```python spaceport.py input output```

where ```input``` is a text file listing IDs (one per line) and ```output``` is the location where the generated files will be saved.

Optional arguments:
```
  --vaheritage    run ASpace2VaHeritage.xsl
  --marcxml       run ASpace2MARCXML.xsl
  --html          run ASpace2HTML.xsl
  --htmlmulti     run ASpace2HTML-gencontainer.xsl (multiple container types)
  --htmlabs       run ASpace2HTMLabstract.xsl
  --retainexport  retain EAD exported from ArchivesSpace
```


These scripts are released under a CC-BY-NC 4.0 license.

Created by Rebecca B. French
