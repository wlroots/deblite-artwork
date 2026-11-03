# DebLite artwork

Wallpapers shipped with the DebLite live ISOs.

Artwork is kept out of the main ISO repository so that releases are small and
wallpapers can change independently. The ISO build downloads a pinned release
tarball and verifies it against the release `SHA256SUMS`.

## Layout

```
wallpapers/            images copied into /usr/share/backgrounds/deblite
scripts/               archive builder
VERSION                current release, must match artwork-vX.Y.Z tags
```

## Adding or changing a wallpaper

1. Add an image to `wallpapers/`. Supported formats are JPEG, PNG, WebP and
   SVG; use at least 2560x1440 for desktop photos.
2. Choose the default:
   - rename the file so it sorts first, or
   - set `DEBLITE_WALLPAPER` in the ISO build to the file name.
3. Bump `VERSION`, commit and tag `artwork-vX.Y.Z`.
4. Publish the release. The workflow produces
   `deblite-artwork-X.Y.Z.tar.gz` and `SHA256SUMS`.
5. Bump `DEBLITE_ARTWORK_VERSION` in the ISO repository's
   `artwork-release.env`.

Every image in `wallpapers/` is installed into the ISO; only the selected one
is made the default. The distro build copies the whole directory for each
edition.

## Local builds

```sh
make dist VERSION=0.1.0
```

The archive is written to `out/`. ISO builds can use it directly with
`DEBLITE_ARTWORK_ARCHIVE=/path/to/deblite-artwork-0.1.0.tar.gz`, or point at a
checkout with `DEBLITE_ARTWORK_DIR=/path/to/deblite-artwork/wallpapers`.

## License

See [`LICENSE`](LICENSE).
