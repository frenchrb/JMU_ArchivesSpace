# Spaceport
App to generate MARCXML, EAD for Virginia Heritage, and HTML for JMU Libraries website from ArchivesSpace EAD finding aids 

## Requirements
Created and tested with Python 3.6 and Saxon-HE 9.7. Requires requests and ArchivesSnake. PyInstaller 3.3.1 used to create executable.

To set up environment from file: ```conda env create –f=environment.yml```

Requires a config file (local_settings.ini) in the same directory. Example of local_settings.ini:
```
[ArchivesSpace]
baseURL:https://aspace.lib.jmu.edu/staff/api
repository:4
user:user
password:pw

[Saxon]
saxon_path:SaxonHE9-7-0-6J\
```

## Usage
The app can be run from the command line (with or without GUI) or the executable.
To run Spaceport with GUI: ```python spaceportGUI.py```

To run Spaceport from the command line: ```python spaceport.py input output```

where ```input``` is a text file listing IDs (one per line) and ```output``` is the location where the generated files will be saved.

Optional arguments:
```
  --vaheritage    run ASpace2VaHeritage.xsl
  --marcxml       run ASpace2MARCXML.xsl
  --html          run ASpace2HTML.xsl
  --htmlmulti     run ASpace2HTML-gencontainer.xsl (multiple container types)
  --htmlnew       run as-ead-html-jmu.xsl (new design)
  --htmlabs       run ASpace2HTMLabstract.xsl
  --retainexport  retain EAD exported from ArchivesSpace
```

* ASpace2MARCXML.xsl creates MARC record from EAD exported from ArchivesSpace
* ASpace2VaHeritage.xsl modifies ArchivesSpace EAD for upload to Virginia Heritage
* HTML
  * ASpace2HTMLabstract.xsl creates abstract snippet for website manuscript list.
  * ASpace2HTML.xsl creates finding aid web page (old design)
  * For finding aids with multiple container types (old design), use ASpace2HTML-gencontainer.xsl instead of ASpace2HTML.xsl.
  * as-ead-html-jmu.xsl creates finding aid web page (new design)

## Build
```pyinstaller spaceportGUI.py --noconsole -F -n spaceport```

## License
These scripts are released under a CC-BY-NC 4.0 license.

## Contact
Rebecca B. French - <https://github.com/frenchrb>
