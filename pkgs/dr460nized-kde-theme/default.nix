{ beautyline-icons
, fetchFromGitLab
, fetchurl
, lib
, stdenvNoCC
, sweet-nova
}:
stdenvNoCC.mkDerivation rec {
  pname = "dr460nized-kde-theme";
  version = "unstable-2023-05-18";

  src = fetchFromGitLab {
    owner = "garuda-linux/themes-and-settings/settings";
    repo = "garuda-dr460nized";
    rev = "1bc10cb58a204927f7d5549ef194e9cf2509f07d";
    sha256 = "f1qGdskZADzoHZX6XMA4NDSWuj7L1oHjx3xMUKUzUkk=";
  };

  malefor = fetchurl {
    url = "https://gitlab.com/garuda-linux/themes-and-settings/artwork/garuda-wallpapers/-/raw/master/src/garuda-wallpapers/Malefor.jpg";
    hash = "sha256-hlt3hyPKqn88JryyqegEglf8Tu8rkPv3iARPIuYYy2Q=";
  };

  buildInputs = [ beautyline-icons sweet-nova ];

  installPhase = ''
    runHook preInstall
    install -d $out/skel
    cp -r etc/skel $out/
    install -d $out/share
    cp -r usr/share/* $out/share/
    install -Dm644 $malefor $out/share/wallpapers/garuda-wallpapers/Malefor.jpg
    runHook postInstall
  '';
  postPatch = ''
    for file in $(find ./* \( -type f \( -name "*.profile" -o -name "*.conf" -o ! -name "*.*" \) \) -o -type l ); do
      if [ -h $file ]; then
        ln -fs $(readlink $file | sed -e 's|/usr/share|/run/current-system/sw/share|g') $file
      else
        substituteInPlace $file --replace "/usr/bin" "/run/current-system/sw/bin" --replace "/usr/share" "/run/current-system/sw/share"
      fi
    done
  '';

  meta = with lib; {
    description = "The default Garuda dr460nized theme";
    homepage = "https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-dr460nized";
    license = licenses.gpl3Only;
    maintainers = [ "dr460nf1r3" ];
    platforms = platforms.all;
  };
}
