#!/usr/bin/env python3

from html.parser import HTMLParser


class LinkExtractor(HTMLParser):
    def __init__(self, class_attr):
        super().__init__()
        self.class_attr = class_attr
        self.links = []

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            attrs_dict = dict(attrs)
            if not self.class_attr or (
                    "class" in attrs_dict and
                    self.class_attr in attrs_dict["class"].split()):
                if "href" in attrs_dict:
                    self.links.append(attrs_dict["href"])

    def __str__(self):
        return "\n".join(self.links)


if __name__ == "__main__":
    import sys
    import argparse

    parser = argparse.ArgumentParser(
        prog="extract-links",
        description="Extract links from an HTML document")
    parser.add_argument("filename", nargs="?",
                        type=argparse.FileType("r"), default=sys.stdin,
                        help="Read HTML from file or stdin (-)")
    parser.add_argument("-c", "--class-name", help="Filter by class attribute")

    args = parser.parse_args()
    html = LinkExtractor(args.class_name)
    html.feed(args.filename.read())
    print(html)
