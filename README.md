# posh-md-zettelkasten

Powershell functions for supporting a markdown based Zettelkasten.

## `Build-TagFiles`

Creates a markdown tag listing file based on #tags found in input files.

### Syntax

`Build-TagFiles.ps1 [-TagPattern <String[]>] [-Path <String[]>] [-DestinationPath <String>] [-Exclude <String[]>] [-Force] [<CommonParameters>]`

### Description

Searches for tags identified by the TagPattern regular expression within files identified by Path. Creates a markdown based tag index at DestinationPath.

This cmdlet supports Zettelkasten notetaking by providing a plain-text method to index tagged files.

### Parameters

#### `-TagPattern <String[]>`

Regular expression for matching tags.  
Default: `#((?!\s|#).)+`

#### `-Path <String[]>`

One or more paths leading to input files. Supports wildcards.  
Default: `./*.md`

#### `-DestinationPath <String>`

The path specifying the tag index file to be generated.  
Default: `./Tags.md`

#### `-Exclude <String[]>`

One or more paths that will be excluded from the input.  
Default: `$DestinationPath`

#### `-Force [<SwitchParameter>]`

Force this cmdlet to overwrite existing files.  
Default: `False`

### Inputs

None.

### Outputs

`[System.IO.FileInfo]` The file that this cmdlet creates.

### Notes

The markdown link generation method, `Format-MarkdownLink`, may need to be adjusted to create links that will work on the target platform.

### Related Links

- [Wikipedia: Zettelkasten](https://en.wikipedia.org/wiki/Zettelkasten)
