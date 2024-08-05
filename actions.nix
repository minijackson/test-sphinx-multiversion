{ pkgs, ... }:
{
  buildMultiversionDocs =
    let
      stable = "nixos-24.05";
      versions = [
        "dev"
        "nixos-24.05"
      ];
      baseurl = "https://minijackson.github.io/test-sphinx-multiversion";

      # Make a redirection using the <meta> tag,
      # with a delay of 1 second, because Google considers them not permanent
      #
      # We need non-permanent redirections, because the redirection will change
      # when a new stable version is released
      redirect = pkgs.writeText "stable-redirect.html" ''
        <meta http-equiv=refresh content="1;url=${stable}/">
      '';

      versions_json = pkgs.writers.writeJSON "versions.json" (
        map (ver: {
          name = ver;
          url = "${baseurl}/${ver}/";
        }) versions
      );
    in
    pkgs.writeShellApplication {
      name = "build-multiversion-docs";
      text = ''
        for version in ${toString versions}; do
          mkdir -p "./book/$version"
          cp ${versions_json} "./$version/docs/versions.json"
          git -C "$version" add docs/versions.json
          nix build "./$version#docs" --print-build-logs
          cp -LrT --no-preserve=mode,ownership ./result/share/doc/epnix/html "./book/$version"
        done
        cp ${redirect} ./book/index.html
      '';
    };
}
