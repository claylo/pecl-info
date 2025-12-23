# Repository Guidelines

## Project Overview

This repository maintains an opinionated, cached dataset of PHP Extension Community Library (PECL) packages. It automatically monitors PECL releases via GitHub Actions and generates a comprehensive README with package information categorized by maintenance status.

The project operates on a scheduled basis (every 6 hours) to check for new PECL releases and automatically creates pull requests with updated data when changes are detected.

## Core Architecture

### Data Flow Pipeline

1. **Data Collection** (`bin/cache-*` scripts):
   - Fetches XML feeds from PECL's static API
   - Caches raw XML responses in `rest/` directory
   - Uses eTags in `.etags/` for efficient cache management
   - Scrapes package pages from PECL website into `pkg-pages/`

2. **Data Transformation** (`bin/expand-*` scripts):
   - PHP scripts that convert XML to JSON
   - Aggregates package metadata into `data/packages.json`
   - Enriches with extra metadata in `data/packages-extra.json`
   - Maps licenses to SPDX identifiers using `data/spdx-map.json`

3. **Opinion Application** (`bin/apply-opinions`):
   - Categorizes packages based on last release date:
     - **active**: < 180 days
     - **recent**: 180-1095 days (3 years)
     - **stale**: > 1095 days
     - **unmaintained**: explicitly marked as abandoned
     - **zero-releases**: no releases available
   - Opinions stored in `data/opinion.json`
   - Identifies PHP 8 compatibility mentions in release notes

4. **README Generation** (`bin/generate-readme`):
   - Assembles from `partials/readme-header.md` + opinions + `partials/readme-footer.md`
   - Creates expandable `<details>` sections for each package
   - Includes metadata: licenses, latest releases, links

### Key Scripts

**Primary data collection workflow:**
```bash
bin/cache-all-package-info      # Fetches package list and info/releases XML
bin/expand-package-info         # Converts package info to JSON
bin/expand-package-releases     # Converts release data to JSON
```

**Additional enrichment:**
```bash
bin/cache-package-pages         # Scrapes HTML pages
bin/expand-package-extra        # Extracts additional metadata
```

**Automated release monitoring:**
```bash
bin/update-latest-releases      # Main automation script (used by GitHub Actions)
```

## Development Commands

### Build/Update Data

**Full rebuild from scratch:**
```bash
make clean
make pecl-cache
make pecl-cache-extra
bin/apply-opinions
make readme
```

**Incremental update (faster, only new data):**
```bash
bin/update-latest-releases
```

**Regenerate README from existing data:**
```bash
make readme
```

### Individual Operations

**Pull core package data:**
```bash
make pecl-cache
```

**Pull extra metadata (HTML pages):**
```bash
make pecl-cache-extra
```

**Refresh single package:**
```bash
bin/refresh-package <package-name>
```

## Technology Stack

- **PHP 8.3+**: All `bin/` scripts (except bash wrappers) are PHP CLI scripts
- **Bash**: Wrapper scripts for orchestration
- **jq**: JSON processing in bash scripts
- **cURL**: HTTP requests (with compression support)
- **SimpleXML**: XML parsing in PHP
- **GitHub Actions**: Automation via `.github/workflows/recent-pecl-releases.yaml`

## Important Patterns

### Cache Management

The project uses eTags to avoid re-downloading unchanged resources:
- `.etags/` directory stores eTag values from previous requests
- `bin/cache-req` script handles conditional requests

### Data Directories

- `data/packages/`: Individual JSON files per package
- `data/packages.json`: Aggregated package list
- `data/packages-extra.json`: Additional metadata from HTML pages
- `data/opinion.json`: Package categorization (active/recent/stale/etc.)
- `rest/p/`: Cached package XML feeds
- `rest/r/`: Cached release XML feeds
- `pkg-pages/`: Cached HTML pages

### Release Automation

The GitHub Actions workflow (`.github/workflows/recent-pecl-releases.yaml`):
1. Runs every 6 hours on cron schedule
2. Executes `bin/update-latest-releases`
3. If changes detected, creates branch named `releases-YYYY-MM-DD_HHMM`
4. Commits with message from `commit.txt`
5. Creates and auto-merges PR
6. Uses GPG signing for commits

### Semantic Release Configuration

Uses semantic-release with conventional commits (`.releaserc.json`):
- Tracks `README.md`, `CHANGELOG.md`, data files, rest cache
- Custom release rules: docs/refactor trigger patch releases
- Automated changelog generation

## License Handling

The project normalizes PECL's freeform license text to SPDX identifiers:
- Mapping defined in `data/spdx-map.json`
- Applied during `bin/expand-package-*` scripts
- Packages with unknown licenses (>5 years old) get `SPDX-License-Identifier: false`

## Testing

No formal test suite exists. Validation is implicit:
- Successful README generation indicates valid JSON
- GitHub Actions workflow serves as integration test
- Manual inspection of generated README
