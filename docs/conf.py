# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import json
from pathlib import Path

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "EPNix test"
copyright = "2024, myself"
author = "myself"
release = "nixos-24.05"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = []

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "furo"
html_static_path = ["_static"]
html_baseurl = f"https://minijackson.github.io/test-sphinx-multiversion/{release}/"

html_sidebars = {
    "**": [
        "sidebar/brand.html",
        "sidebar/search.html",
        "sidebar/scroll-start.html",
        "sidebar/navigation.html",
        "sidebar/scroll-end.html",
        "multi-version.html",
    ]
}

html_css_files = ["multi-version.css"]

# Multi versions
html_context = {}

versions = Path("./versions.json")
if versions.exists():
    with versions.open() as f:
        html_context["versions"] = json.load(f)

    # Mark current version as current
    current_version = next(
        el for el in html_context["versions"] if el["name"] == release
    )
    current_version["current"] = True
