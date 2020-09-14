<#
.SYNOPSIS
    Creates a markdown tag listing file based on #tags found in input files.
.DESCRIPTION
    Searches for tags identified by the TagPattern regular expression within files identified by Path. Creates a markdown based tag index at DestinationPath.

    This cmdlet supports Zettelkasten notetaking by providing a plain-text method to index tagged files.
.INPUTS
    None.
.OUTPUTS
    [System.IO.FileInfo]
        The file that this cmdlet creates.
.NOTES
    The markdown link generation method, Format-MarkdownLink, may need to be adjusted to create links that will work on the target platform.
.LINK
    https://github.com/DrakeLambert/posh-md-zettelkasten
.LINK
    https://en.wikipedia.org/wiki/Zettelkasten
#>
[CmdletBinding(PositionalBinding = $false)]
Param (
    # Regular expression for matching tags.
    [Parameter()]
    [string[]]
    $TagPattern = '#((?!\s|#).)+',

    # One or more paths leading to input files. Supports wildcards.
    [Parameter()]
    [string[]]
    $Path = './*.md',

    # The path specifying the tag index file to be generated.
    [Parameter()]
    [string]
    $DestinationPath = './Tags.md',

    # One or more paths that will be excluded from the input.
    [Parameter()]
    [string[]]
    $Exclude = $DestinationPath,

    # Force this cmdlet to overwrite existing files.
    [Parameter()]
    [switch]
    $Force = $false
)

$relativeTo = Split-Path -Parent -Path $DestinationPath
if ($relativeTo -eq '') {
    $relativeTo = '.'
}
$relativeTo = Resolve-Path -Path $relativeTo

function Format-MarkdownLink ($filePath) {
    $fileName = Split-Path -Path $filePath -LeafBase
    $relativePath = [System.IO.Path]::GetRelativePath($relativeTo, $filePath)
    return "[$fileName](<$relativePath>)"
}

function Format-TagAsMarkdown ($tag, $paths) {
    $pathLinks = $paths | ForEach-Object { "- $(Format-MarkdownLink $_)" }
    return "## $tag", '', $pathLinks | Join-String -Separator "`n"
}

$excludedFiles = $Exclude | Where-Object { Test-Path $_ } | Resolve-Path | Select-Object -ExpandProperty Path
$excludedFiles
$inputFiles = Get-Item $Path | Where-Object { $_.FullName -notin $excludedFiles }

$markdownTags = $inputFiles |
    Select-String -Pattern $TagPattern -CaseSensitive -AllMatches |
    Select-Object -ExpandProperty Matches -Property Path |
    Select-Object -Property Value, Path |
    Group-Object Value |
    ForEach-Object {
        Format-TagAsMarkdown $_.Name ($_.Group | Select-Object -ExpandProperty Path) 
    }

$tagFileContent = '# Tags', $markdownTags | Join-String -Separator "`n`n"

New-Item -Path $DestinationPath -ItemType File -Value $tagFileContent -Force:$Force