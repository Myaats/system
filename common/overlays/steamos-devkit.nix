{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchFromGitHub,
  pkgs,
}: let
  python = pkgs.python310;
  buildPythonPackage = python.pkgs.buildPythonPackage;
  fetchPypi = python.pkgs.fetchPypi;
  # Extra packages
  weakrefmethod = buildPythonPackage rec {
    pname = "weakrefmethod";
    version = "1.0.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-N7wfu1V1rPghctTre2/EQS131aHXDf8sH4pFdDAc2mY=";
    };

    doCheck = false;
  };
  signalslot = buildPythonPackage rec {
    pname = "signalslot";
    version = "0.1.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Z26RPNau+4719e82jMhb2LyIR6EvsANI8r3+eKuw494=";
    };

    propagatedBuildInputs = with python.pkgs; [
      six
      contexter
      weakrefmethod
    ];

    doCheck = false;
  };
  pyimgui = buildPythonPackage rec {
    name = "pyimgui";
    version = "1f095af5886f424ee12f26fa93b108b6420fafa4"; # 2.0 dev
    src = fetchFromGitHub {
      owner = "pyimgui";
      repo = "pyimgui";
      rev = version;
      fetchSubmodules = true;
      sha256 = "sha256-k070ue132m8H1Zm8bo7J7spCS5dSTGOj689ci7vJ+aw=";
    };
    doCheck = false;
    buildPhase = ''
      python setup.py build bdist_wheel
    '';
    nativeBuildInputs = with pkgs;
    with python.pkgs; [
      pkg-config
      setuptools
      wheel
      cython
      pyopengl
      SDL2
      click
    ];
    propagatedBuildInputs = with python.pkgs; [
      pyopengl
      pysdl2
      click
    ];
    buildInputs = with pkgs;
    with pkgs.xorg; [
      libX11.dev
      libXrandr.dev
      libXinerama.dev
      libXcursor.dev
      xinput
      libXi.dev
      libXext
    ];
  };
in
  buildPythonPackage rec {
    pname = "steamos-devkit";
    version = "06959f30c06c2336ae9fe9295c59ed1be4ad2304";

    src = builtins.fetchGit {
      url = "https://gitlab.steamos.cloud/devkit/steamos-devkit.git";
      ref = "main";
      rev = "${version}";
    };

    propagatedBuildInputs = with python.pkgs; [
      pysdl2
      pyopengl
      signalslot
      ifaddr
      appdirs
      bcrypt
      cffi
      cryptography
      idna
      netifaces
      paramiko
      pycparser
      pynacl
      six
      pyimgui
    ];

    # There is no test for devkit
    doCheck = false;

    patchPhase = ''
      cp setup/shiv-linux-setup.py setup.py
      mv client/* .
    '';

    desktopItem = pkgs.makeDesktopItem {
      name = "SteamOS-Devkit";
      exec = "steamos-devkit";
      desktopName = "SteamOS Devkit";
    };

    postInstall = ''
      mkdir -p $out/bin

      cp -R ./devkit-utils $out/lib/python3.10/site-packages/devkit-utils

      cp ${pkgs.writeScript "steamos-devkit" ''
        #!${python}/bin/python3

        import devkit_client.gui2
        devkit_client.gui2.main()
      ''} $out/bin/steamos-devkit
    '';
  }
