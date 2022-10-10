
## What is PECL?

[PECL](https://pecl.php.net) (The **P**HP **E**xtension **C**ommunity **L**ibrary) is a repository for PHP Extensions, providing a directory of all known extensions and hosting facilities for downloading and development of PHP extensions.

The packaging system used by PECL is shared with its sister, [PEAR](https://pear.php.net).

## What is this repository?

The PECL website, created many years before GitHub was created ... and still more years before GitHub's more advanced features, is often slow to respond. In an effort to lighten the load on that website, this repository uses GitHub Actions to check the PECL releases feed and update this repository with a cache of the information contained on the [PECL website](https://pecl.php.net/).

## What do you consider "relevant"?

PHP is changing pretty rapidly these days. If a package hasn't had a release in over 3 years, I'm calling it stale.

### Is everything from PECL cached here?

No. If a package is marked `abandoned` on the PECL website, or has not has a release within the last 3 years, the tools in this repository will ignore it. Basically, PECL listings have been sorted into "relevant" and "irrelevant" buckets. Irrelevant extensions are those that haven't been updated for life after PHP 5.

### Is any data changed from the PECL website?

Some, yes.

#### SPDX License Identifiers

The PECL historically allowed free-form text for indicating software licenses. We've mapped all those onto SPDX license IDs and added a [SPDX-License-Identifier](https://spdx.dev/ids/) key to all packages and releases. (Note: we haven't modified any of the source, and obviously our mappings aren't binding, we're not lawyers, etc. etc. We're just trying to clean up some data.)

You can see the mapping we use in `data/spdx-map.json`. If we couldn't figure out a SPDX Identifier from looking at the source, and if the most recent package release was over 5 years ago, we set the value of `SPDX-License-Identifier` to `false`.

Dual-licensing decisions made were based on the [SPDX FAQ](https://wiki.spdx.org/view/SPDX_FAQ).

#### Hyperlinks

Some of the packages in PECL don't have up-to-date links in the PECL database, despite being actively maintained packages. Some of the hyperlinks for packages deemed "relevant" have been manually tweaked to point to the appropriate places.

### Why is this repo useful?

#### Filtered List

The PECL website lists all extensions, regardless of whether or not they're active, whether they've had releases in the last decade, etc. That can make it difficult to find extensions that you might want to consider using *today*.

#### JSON representation

Much of the PECL website's data is available as XML data feeds, but these days, JSON is a little more convenient. This repository's `/data` directory has JSON representations of data from PECL releases.

### How often is this repository updated?

After assembling the initial data, we check the PECL latest releases RSS feed regularly and update the content here when new releases occur.


## What if my package's information is wrong?

Start with updating it on the PECL website. If your latest release isn't listed here, it may be because you didn't release it on the PECL website.

## What about PHP extensions that aren't in PECL?

Consider adding them to PECL. I may expand this repository to include non-PECL extensions in the future.

## Something wrong? Something right?

Let me know via email or Twitter, or open a ticket on this repo.

