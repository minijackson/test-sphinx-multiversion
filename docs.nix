{
  stdenvNoCC,
  python3,
  installShellFiles,
}:
stdenvNoCC.mkDerivation {
  pname = "epnix-docs";
  version = "24.05";

  src = ./docs;

  nativeBuildInputs =
    (with python3.pkgs; [
      furo
      myst-parser
      sphinx
      sphinx-copybutton
    ])
    ++ [ installShellFiles ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    make html man

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/doc/epnix/

    cp -r _build/html $out/share/doc/epnix/
    installManPage _build/man/*.?

    runHook postInstall
  '';
}
