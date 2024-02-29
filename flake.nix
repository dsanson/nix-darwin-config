{
  description = "David's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      nix.settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["@admin"];
      };

      users.users.desanso = {
        name = "desanso";
        home = "/Users/desanso";
      };

      environment.systemPackages =
        [ 
          # shells
          pkgs.fish
          pkgs.zsh
          pkgs.starship

          # basic system stuff
          pkgs.curl
          pkgs.ack
          pkgs.eza #improved version of ls
          pkgs.fd
          pkgs.fdupes
          pkgs.fzf
          pkgs.gawk
          pkgs.gnupg
          pkgs.jq
          pkgs.mosh
          pkgs.pup
          pkgs.ripgrep
          pkgs.tealdeer #fast tldr client
          pkgs.tmux
          pkgs.wget
          pkgs.zoxide
          pkgs.zip
          pkgs.unar #cli version of theunarchiver

          # git
          pkgs.git
          pkgs.gh
          pkgs.hub

          # editing
          pkgs.neovim
          pkgs.tree-sitter
          pkgs.universal-ctags

          # data
          pkgs.R
          pkgs.visidata
          pkgs.xsv
 
          # web dev
          pkgs.dart-sass

          # pdf and images
          pkgs.imagemagick
          pkgs.ghostscript
          pkgs.psutils
          pkgs.cairo
          pkgs.djvu2pdf
          pkgs.djvulibre
          pkgs.ocrmypdf
          pkgs.pdfcpu
          pkgs.pdfgrep
          pkgs.qpdf
          pkgs.scantailor
          pkgs.tesseract
        
          # media
          pkgs.ffmpeg
          pkgs.mpv
          pkgs.yt-dlp

          # document generation
          pkgs.biber
          pkgs.bibtool
          pkgs.typst

          # games
          pkgs.angband
          pkgs.figlet
          pkgs.nsnake

          # fonts
          pkgs.fira-code-nerdfont
          pkgs.font-awesome
          pkgs.monoid
          pkgs.mononoki
          pkgs.open-dyslexic
          pkgs.source-code-pro

          # unicode lookup
          pkgs.uni

          # calendar and contacts
          pkgs.khal
          pkgs.khard

          # email
          pkgs.aerc
          pkgs.mu
          
          # mac specific
          pkgs.mas

          # trying out
          pkgs.lazygit
          pkgs.btop

          # do I even use these?
          pkgs.a2ps
          pkgs.ant
          pkgs.asciidoc
          pkgs.c-ares
          pkgs.cachix
          pkgs.cargo
          pkgs.cjson
          pkgs.docbook5
          pkgs.dockutil
          pkgs.dos2unix
          pkgs.exiftool
          pkgs.fftw
          pkgs.go
          pkgs.gradle
          pkgs.groff
          pkgs.httpie
          pkgs.hugo
          pkgs.hunspell
          pkgs.hwloc
          pkgs.intltool
          pkgs.ispell
          pkgs.jasper
          pkgs.libheif
          pkgs.librist
          pkgs.lynx
          pkgs.mbedtls
          pkgs.mercurial
          pkgs.miller
          pkgs.mpg123
          pkgs.msgpack
          pkgs.mujs
          pkgs.nasm
          pkgs.ncdu_1
          pkgs.neofetch
          pkgs.netcat
          pkgs.netpbm
          pkgs.nmap
          pkgs.opencv
          pkgs.openmpi
          pkgs.openssh
          pkgs.optipng
          pkgs.pango
          pkgs.parallel
          pkgs.pdf2svg
          pkgs.pngcrush
          pkgs.pngquant
          pkgs.pv
          pkgs.qrencode
          pkgs.rclone
          pkgs.ripmime
          pkgs.rmlint
          pkgs.rnix-lsp
          pkgs.rustc
          pkgs.samba
          pkgs.scons
          pkgs.shared-mime-info
          pkgs.shellcheck
          pkgs.socat
          pkgs.sphinx
          pkgs.subversion
          #pkgs.texinfo
          pkgs.tidy-viewer
          pkgs.tig
          pkgs.todo-txt-cli
          pkgs.unpaper
          pkgs.vala
          pkgs.vale
          pkgs.w3m
          pkgs.wcalc
          pkgs.xmlto
          pkgs.zk

        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;


      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
 
      networking = {
        computerName = "halibut";
        hostName = "halibut";
      };

      security.pam.enableSudoTouchIdAuth  = true;

      system.defaults = {

        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          AppleInterfaceStyleSwitchesAutomatically = true;
          AppleScrollerPagingBehavior = true; #jump to position clicked on scrollbar
          AppleShowScrollBars = "WhenScrolling";
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          _HIHideMenuBar = true;
        };

        dock = {
          appswitcher-all-displays = true;
          autohide = true;
          show-process-indicators = false;
          static-only = true; #show only open apps in dock
          wvous-tr-corner = 12; #top-right hot corner activates notification center
        };

        finder = {
          CreateDesktop = false; # don't show items on desktop
          FXPreferredViewStyle = "Nlsv"; # default to list view
          QuitMenuItem = true;
          ShowPathbar = true;
        };
        
        loginwindow = {
          GuestEnabled = true;
        };


      };

      system.keyboard = {
        enableKeyMapping = true;
        nonUS.remapTilde = true;
        remapCapsLockToControl = true;
      };

      homebrew = {
        enable = true;
        onActivation.autoUpdate = true;
        
        taps = [
          "dsanson/tap"
        ];

        brews = [
          "launch" #macos launcher that is better than open
          "reminders-cli"
          "rename" #consider alternatives
          "switchaudio-osx"
          "tag" #macos file tagging
          "trash" #consider finding crossplatform option
          {
            name = "vdirsyncer"; # figure out how to set this up via nix
            restart_service = true;
          }
        ];

        casks = [
          "anki" # have not been using
          "anylist"
          "caffeine"
          "calibre"
          "firefox"
          "hammerspoon" # just for the caps lock key
          "haptickey"
          "itsycal"
          "marta" # trying
          "monitorcontrol"
          "obsidian" # am I still using this?
          "quicksilver"
          "rar"
          "satori"
          "syncthing"
          "the-unarchiver"
          "yacreader"
          "zerotier-one"
          "zoom"
          "zotero"
         
          # occasional use (but good to always have on hand)
          "djview"
          "grandperspective"
          "iina"
          "vlc"

          # occasional use (consider not keeping installed)
          "adobe-digital-editions"
          "aegisub" 
          "keycastr"
          "android-file-transfer"
          "android-platform-tools"
          "audacity"
          "discord"
          "dupeguru"
          "fontforge"
          "google-chrome"
          "logic-2010"
          "logitech-camera-settings"
          "musescore"
          "oracle-jdk"
          "raspberry-pi-imager"
          "sf-symbols"
          "tor-browser"
          "transmission"
          "xquartz"

          # quicklook plugins
          "qlcolorcode"
          "qlmarkdown"
          "qlstephen"
          "qlvideo"
          "quicklook-csv"
          "syntax-highlight"
          
          # fonts
          "font-awesome-terminal-fonts"
          "font-dejavu-sans"
          "font-hack-nerd-font"
          "font-kawkab-mono"
          "font-monofur-nerd-font"
          "font-monofur-nerd-font-mono"
          "font-xits"

        ];

        masApps = {
          "OneDrive"               =  823766827;
          "Kindle Classic"         =  405399194;
          "AdGuard for Safari"     =  1440147259;
          "Keynote"                =  409183694;
          "iMovie"                 =  408981434;
          "DevCleaner"             =  1388020431;
          "Paprika Recipe Manager" =  451907568;
          "CamControl"             =  1503271162;
          "Pages"                  =  409201541;
          "Mpix"                   =  1282488470;
          "GarageBand"             =  682658836;
          "Visualizer"             =  1296177026;
          "Numbers"                =  409203825;
          "Prime Video"            =  545519333;
          "TomatoFlex"             =  1500965952;
        };
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#halibut
    darwinConfigurations."halibut" = nix-darwin.lib.darwinSystem {
      #modules = [ configuration ];
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.desanso = import ./home.nix; 
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."halibut".pkgs;
  };
}
