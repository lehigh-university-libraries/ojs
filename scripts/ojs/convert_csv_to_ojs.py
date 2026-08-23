#!/usr/bin/env python3

import pandas as pd
import os
import base64
import xml.etree.ElementTree as ET
from xml.dom import minidom
import argparse
from datetime import datetime
from collections import defaultdict


def base64_encode_file(file_path):
    """Read a file and return its base64 encoded content."""
    try:
        with open(file_path, "rb") as f:
            return base64.b64encode(f.read()).decode("utf-8")
    except FileNotFoundError:
        print(f"Warning: File not found: {file_path}")
        return None
    except Exception as e:
        print(f"Error encoding file {file_path}: {e}")
        return None


def get_file_size(file_path):
    """Get file size in bytes."""
    try:
        return os.path.getsize(file_path)
    except:
        return 0


def parse_authors(author_string):
    """Parse author string into list of (givenname, familyname) tuples."""
    if pd.isna(author_string) or not author_string.strip():
        return []

    authors = []
    # Split by semicolon or comma
    for author in author_string.split(";"):
        author = author.strip()
        if not author:
            continue

        # Try to split by comma (Last, First format)
        if "," in author:
            parts = author.split(",", 1)
            familyname = parts[0].strip()
            givenname = parts[1].strip() if len(parts) > 1 else ""
        else:
            # Try to split by space (First Last format)
            parts = author.rsplit(" ", 1)
            if len(parts) == 2:
                givenname = parts[0].strip()
                familyname = parts[1].strip()
            else:
                # Single name, treat as family name
                givenname = ""
                familyname = parts[0].strip()

        authors.append((givenname, familyname))

    return authors


def create_article_xml(row, article_id, file_id, pdf_path, seq):
    """Create an article element with all its sub-elements."""

    locale = str(row.get("locale", "en_US"))
    if pd.isna(row.get("locale")):
        locale = "en_US"

    date_published = str(row.get("Date", "2025-11-20"))
    if pd.isna(row.get("Date")):
        date_published = "2025-11-20"

    # Create article element
    article = ET.Element(
        "article",
        {
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "locale": locale,
            "date_submitted": date_published,
            "status": "3",  # STATUS_PUBLISHED
            "submission_progress": "",
            "current_publication_id": str(article_id),
            "stage": "production",
            "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
        },
    )

    # Internal ID
    id_elem = ET.SubElement(article, "id", {"type": "internal", "advice": "ignore"})
    id_elem.text = str(article_id)

    # Submission file (the PDF)
    if pdf_path and os.path.exists(pdf_path):
        submission_file = ET.SubElement(
            article,
            "submission_file",
            {
                "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
                "id": str(file_id),
                "created_at": date_published,
                "file_id": str(file_id),
                "stage": "proof",
                "updated_at": date_published,
                "viewable": "false",
                "genre": "Article Text",
                "uploader": "admin",
                "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
            },
        )

        # File name
        name_elem = ET.SubElement(submission_file, "name", {"locale": locale})
        name_elem.text = os.path.basename(pdf_path)

        # File element with embedded PDF
        file_size = get_file_size(pdf_path)
        _, ext = os.path.splitext(pdf_path)
        ext = ext.lstrip(".") if ext else "pdf"

        file_elem = ET.SubElement(
            submission_file,
            "file",
            {"id": str(file_id), "filesize": str(file_size), "extension": ext},
        )

        # Base64 encoded file content
        encoded_content = base64_encode_file(pdf_path)
        if encoded_content:
            embed_elem = ET.SubElement(file_elem, "embed", {"encoding": "base64"})
            embed_elem.text = encoded_content

    # Publication
    publication = ET.SubElement(
        article,
        "publication",
        {
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "version": "1",
            "status": "3",
            "primary_contact_id": "1",
            "url_path": "",
            "seq": str(seq),
            "access_status": "0",
            "date_published": date_published,
            "section_ref": "ART",
            "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
        },
    )

    # Publication ID
    pub_id = ET.SubElement(publication, "id", {"type": "internal", "advice": "ignore"})
    pub_id.text = str(article_id)

    # Title
    title = str(row.get("title", ""))
    if title and not pd.isna(row.get("title")):
        title_elem = ET.SubElement(publication, "title", {"locale": locale})
        title_elem.text = title

    # Abstract
    abstract = str(row.get("abstract", ""))
    if abstract and not pd.isna(row.get("abstract")):
        abstract_elem = ET.SubElement(publication, "abstract", {"locale": locale})
        abstract_elem.text = f"<p>{abstract}</p>"

    # Copyright
    copyright_holder = ET.SubElement(publication, "copyrightHolder", {"locale": "en"})
    copyright_holder.text = "Journal of Public Knowledge"

    copyright_year = ET.SubElement(publication, "copyrightYear")
    copyright_year.text = date_published.split("-")[0]

    # Authors
    authors_elem = ET.SubElement(
        publication,
        "authors",
        {
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
        },
    )

    authors = parse_authors(str(row.get("authorString", "")))
    for idx, (givenname, familyname) in enumerate(authors, 1):
        author = ET.SubElement(
            authors_elem,
            "author",
            {
                "include_in_browse": "true",
                "user_group_ref": "Author",
                "seq": str(idx - 1),
                "id": str(idx),
            },
        )

        if givenname:
            given_elem = ET.SubElement(author, "givenname", {"locale": locale})
            given_elem.text = givenname

        if familyname:
            family_elem = ET.SubElement(author, "familyname", {"locale": locale})
            family_elem.text = familyname

        # Dummy email
        email_elem = ET.SubElement(author, "email")
        email_elem.text = f"{familyname.lower().replace(' ', '')}@example.com"

    # Article galley (PDF)
    if pdf_path and os.path.exists(pdf_path):
        galley = ET.SubElement(
            publication,
            "article_galley",
            {
                "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
                "locale": locale,
                "approved": "false",
                "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
            },
        )

        galley_id = ET.SubElement(
            galley, "id", {"type": "internal", "advice": "ignore"}
        )
        galley_id.text = str(file_id)

        galley_name = ET.SubElement(galley, "name", {"locale": locale})
        galley_name.text = "PDF"

        galley_seq = ET.SubElement(galley, "seq")
        galley_seq.text = "0"

        galley_file_ref = ET.SubElement(
            galley, "submission_file_ref", {"id": str(file_id)}
        )

    # Pages
    pages = str(row.get("Pages", ""))
    if pages and not pd.isna(row.get("Pages")):
        pages_elem = ET.SubElement(publication, "pages")
        pages_elem.text = pages

    return article


def create_issue_xml(volume, issue_num, year, articles_data, pdf_dir):
    """Create an issue XML with all its articles."""

    # Create issue element
    issue = ET.Element(
        "issue",
        {
            "xmlns": "http://pkp.sfu.ca",
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "published": "1",
            "current": "1",
            "access_status": "1",
            "url_path": "",
            "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
        },
    )

    # Internal ID
    id_elem = ET.SubElement(issue, "id", {"type": "internal", "advice": "ignore"})
    id_elem.text = "1"

    # Issue identification
    issue_id = ET.SubElement(issue, "issue_identification")

    vol_elem = ET.SubElement(issue_id, "volume")
    vol_elem.text = str(volume)

    num_elem = ET.SubElement(issue_id, "number")
    num_elem.text = str(issue_num)

    year_elem = ET.SubElement(issue_id, "year")
    year_elem.text = str(year)

    # Publication date
    date_pub = ET.SubElement(issue, "date_published")
    date_pub.text = f"{year}-01-01"

    last_mod = ET.SubElement(issue, "last_modified")
    last_mod.text = f"{year}-01-01"

    # Sections
    sections = ET.SubElement(issue, "sections")
    section = ET.SubElement(
        sections,
        "section",
        {
            "ref": "ART",
            "seq": "0",
            "editor_restricted": "0",
            "meta_indexed": "1",
            "meta_reviewed": "1",
            "abstracts_not_required": "0",
            "hide_title": "0",
            "hide_author": "0",
            "abstract_word_count": "500",
        },
    )

    sect_id = ET.SubElement(section, "id", {"type": "internal", "advice": "ignore"})
    sect_id.text = "1"

    abbrev = ET.SubElement(section, "abbrev", {"locale": "en"})
    abbrev.text = "ART"

    policy = ET.SubElement(section, "policy", {"locale": "en"})
    policy.text = "<p>Section default policy</p>"

    sect_title = ET.SubElement(section, "title", {"locale": "en"})
    sect_title.text = "Articles"

    # Issue galleys (empty)
    issue_galleys = ET.SubElement(
        issue,
        "issue_galleys",
        {
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
        },
    )

    # Articles
    articles = ET.SubElement(
        issue,
        "articles",
        {
            "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation": "http://pkp.sfu.ca native.xsd",
        },
    )

    # Add each article
    for idx, row_data in enumerate(articles_data, 1):
        row = row_data["row"]
        filename = row.get("filename")

        if pd.isna(filename):
            continue

        pdf_path = os.path.join(pdf_dir, str(filename))
        article_elem = create_article_xml(row, idx, idx, pdf_path, idx - 1)
        articles.append(article_elem)

    return issue


def prettify_xml(elem):
    """Return a pretty-printed XML string."""
    rough_string = ET.tostring(elem, "utf-8")
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ", encoding="utf-8").decode("utf-8")


def main():
    parser = argparse.ArgumentParser(
        description="Convert CSV to OJS Native XML format."
    )
    parser.add_argument("csv_file", help="Path to the input CSV file.")
    parser.add_argument("pdf_dir", help="Path to the directory containing PDF files.")
    parser.add_argument(
        "--output_dir", default="xml", help="Output directory for XML files."
    )
    args = parser.parse_args()

    # Read CSV
    try:
        df = pd.read_csv(args.csv_file)
    except FileNotFoundError:
        print(f"Error: CSV file not found at {args.csv_file}")
        return

    # Group articles by volume and issue
    issues = defaultdict(list)

    for index, row in df.iterrows():
        volume = row.get("Volume")
        issue = row.get("Issue")
        year = row.get("year")

        if pd.isna(volume) or pd.isna(issue):
            print(f"Skipping row {index+2}: missing Volume or Issue")
            continue

        volume = int(volume)
        issue = int(issue)
        year = int(year) if not pd.isna(year) else 2010

        issues[(volume, issue, year)].append({"row": row, "index": index})

    # Create output directory
    os.makedirs(args.output_dir, exist_ok=True)

    # Generate XML for each issue
    for (volume, issue_num, year), articles_data in sorted(issues.items()):
        print(
            f"Processing Volume {volume}, Issue {issue_num}, Year {year} ({len(articles_data)} articles)"
        )

        # Create issue XML
        issue_elem = create_issue_xml(
            volume, issue_num, year, articles_data, args.pdf_dir
        )

        # Save to file
        filename = f"issue_v{volume}_i{issue_num}.xml"
        output_path = os.path.join(args.output_dir, filename)

        xml_string = prettify_xml(issue_elem)

        with open(output_path, "w", encoding="utf-8") as f:
            f.write(xml_string)

        print(f"  Created: {output_path}")

    print(f"\nConversion complete! Generated {len(issues)} issue XML files.")
    print(f"\nTo import, use:")
    print(
        f"  php tools/importExport.php NativeImportExportPlugin import {args.output_dir}/issue_v1_i1.xml [journal_path]"
    )


if __name__ == "__main__":
    main()
