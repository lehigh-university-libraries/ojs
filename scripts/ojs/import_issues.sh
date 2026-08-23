#!/bin/bash

# Import script for OJS Native XML
# Usage: ./import_issues.sh <journal_path> <xml_directory>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <journal_path> <xml_directory>"
    echo "Example: $0 jrer xml/"
    exit 1
fi

JOURNAL_PATH=$1
XML_DIR=$2

# Find all XML files
XML_FILES=$(find "$XML_DIR" -name "issue_*.xml" | sort)

if [ -z "$XML_FILES" ]; then
    echo "No XML files found in $XML_DIR"
    exit 1
fi

echo "Found XML files to import:"
echo "$XML_FILES"
echo ""

# Import each file
for xml_file in $XML_FILES; do
    echo "================================================"
    echo "Importing: $xml_file"
    echo "================================================"

    # Use the NativeImportExportPlugin to import
    if php tools/importExport.php NativeImportExportPlugin import "$xml_file" "$JOURNAL_PATH"; then
        echo "✓ Successfully imported: $xml_file"
    else
        echo "✗ Failed to import: $xml_file"
    fi
    echo ""
done

echo "================================================"
echo "Import complete!"
echo "================================================"
