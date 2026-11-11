#!/usr/bin/env python3
"""
IndiaKart dataset preparation helper.

This script resolves the missing CSV files required by
IndiaKart_Google_Colab.ipynb by:
1) checking the known data locations,
2) searching for ZIP archives in common Colab/workspace locations,
3) extracting the ZIP if needed,
4) validating that all required CSV files are available.

Usage in Colab/Jupyter:
    !python /content/prepare_indiakart_data.py
or, from the repo root:
    python prepare_indiakart_data.py
"""

from __future__ import annotations

import os
import zipfile
from pathlib import Path

REQUIRED_FILES = [
    "customers DA.csv",
    "orders DA.csv",
    "order_items DA.csv",
    "payments DA.csv",
    "returns DA.csv",
    "products DA.csv",
    "inventory DA.csv",
    "suppliers DA.csv",
]

CANDIDATE_DIRS = [
    Path("/workspace/indiakart_project"),
    Path("/content/indiakart_project"),
    Path("/content"),
    Path("./indiakart_project"),
    Path("."),
]


def find_csvs_in_dir(base: Path):
    """Return the directory if all required CSVs exist in it or below it."""
    if not base.exists():
        return None

    names = {p.name.lower() for p in base.rglob("*.csv")}
    if all(file_name.lower() in names for file_name in [f.lower() for f in REQUIRED_FILES]):
        return base

    found = []
    for required in REQUIRED_FILES:
        lowered_required = required.lower()
        for candidate in names:
            if candidate == lowered_required:
                found.append(required)
                break
    if len(found) == len(REQUIRED_FILES):
        return base

    return None


def extract_zip_if_needed() -> Path | None:
    """Search for a zip archive and extract it to /content/indiakart_project."""
    roots = [Path("/content"), Path("/workspace"), Path(".")]

    for root in roots:
        if not root.exists():
            continue
        for zip_path in sorted(root.rglob("*.zip")):
            if not zip_path.is_file():
                continue

            extract_dir = Path("/content/indiakart_project")
            try:
                with zipfile.ZipFile(zip_path, "r") as archive:
                    extract_dir.mkdir(parents=True, exist_ok=True)
                    archive.extractall(extract_dir)
                print(f"Extracted {zip_path} -> {extract_dir}")
                return extract_dir
            except Exception as exc:
                print(f"Warning: failed to extract {zip_path}: {exc}")

    return None


def resolve_data_dir() -> str:
    """Return the directory with all required IndiaKart CSV files."""
    for base in CANDIDATE_DIRS:
        found = find_csvs_in_dir(base)
        if found is not None:
            return str(found)

    extracted_dir = extract_zip_if_needed()
    if extracted_dir is not None:
        for base in CANDIDATE_DIRS:
            found = find_csvs_in_dir(base)
            if found is not None:
                return str(found)

    raise FileNotFoundError(
        "Could not locate the required IndiaKart CSV files. "
        "Please upload or unzip the dataset into /content/indiakart_project."
    )


def main():
    print("Checking for IndiaKart datasets...")
    data_dir = resolve_data_dir()
    print(f"Dataset directory resolved: {data_dir}")

    missing = []
    for required in REQUIRED_FILES:
        if not (Path(data_dir) / required).exists():
            missing.append(required)

    if missing:
        raise FileNotFoundError(f"Missing required CSV files: {missing}")

    print("All required CSV files are present.")
    print("Ready to run IndiaKart_Google_Colab.ipynb")


if __name__ == "__main__":
    main()
