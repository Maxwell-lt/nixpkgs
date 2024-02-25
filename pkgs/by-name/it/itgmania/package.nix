{ lib
, stdenv
, fetchFromGitHub
, cmake
, yasm
, alsa-lib
, ffmpeg_6
, glew
, glib
, gtk2
, libmad
, libogg
, libpulseaudio
, libusb-compat-0_1
, libvorbis
, udev
, xorg
, gcc12
, makeDesktopItem
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "itgmania";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "itgmania";
    repo  = "itgmania";
    rev   = "v${version}";
    hash = "sha256-GzpsyyjR7NhgCQ9D7q8G4YU7HhV1C1es1C1355gHnV8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    yasm
    gcc12
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    ffmpeg_6
    glew
    glib
    gtk2
    libmad
    libogg
    libpulseaudio
    libusb-compat-0_1
    libvorbis
    udev
    xorg.libXtst
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  desktop = makeDesktopItem {
    name = "itgmania";
    desktopName = "ITGmania";
    genericName = "Rhythm and dance game";
    exec = "itgmania";
    tryExec = "itgmania";
    icon = "itgmania";
    categories = [ "Game" "ArcadeGame" ];
  };

  postInstall = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/48x48/apps $out/share/icons/hicolor/scalable/apps

    makeWrapper $out/itgmania/itgmania $out/bin/itgmania --argv0

    rm $out/setup.sh

    cp $src/Data/icon.png $out/share/icons/hicolor/48x48/apps/itgmania.png
    cp $src/Data/logo.svg $out/share/icons/hicolor/scalable/apps/itgmania.svg
    ln -s ${desktop}/share/applications/itgmania.desktop $out/share/applications/itgmania.desktop
  '';

  meta = with lib; {
    homepage = "https://www.itgmania.com";
    description = "Fork of StepMania 5.1, improved for the post-ITG community";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxwell-lt ];
    mainProgram = "itgmania";
  };
}
