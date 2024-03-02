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

          # basic system stuff
          pkgs.curl
          pkgs.ack
          pkgs.fd
          pkgs.fdupes
          pkgs.gawk
          pkgs.gnupg
          pkgs.less
          pkgs.mosh
          pkgs.pup
          pkgs.wget
          pkgs.zip
          pkgs.unar #cli version of theunarchiver

          # git
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
          
          # pkgs.khal # figure out how to set these up with home manager
          # pkgs.khard

          # email
          pkgs.mu
          
          # mac specific
          pkgs.mas

          # trying out
          pkgs.lazygit
   
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
          AppleMeasurementUnits = "Inches";
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSTableViewDefaultSizeMode = 1; #1 = small; 2 = medium; 3 = large
          _HIHideMenuBar = true;
          "com.apple.sound.beep.volume" = 0.4;
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
          #DisableAllAnimations = true;
          FXPreferredViewStyle = "Nlsv"; # default to list view
          QuitMenuItem = true;
          ShowPathbar = true;
        };
        
        loginwindow = {
          GuestEnabled = true;
        };

        screensaver = {
          askForPassword = true;
        };

        trackpad = {
          Clicking = true;
          Dragging = true;
          TrackpadRightClick = true;
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
            restart_service = "changed";
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
      services = {
        sketchybar = {
          enable = true;
          package = pkgs.sketchybar;
        };
        
        skhd = {
          enable = true;
          package = pkgs.skhd;
        };

        yabai = {
          enable = true;
          package = pkgs.yabai;
          enableScriptingAddition = true;
          config = {
            external_bar = "all:0:27";
            mouse_follows_focus = "on";
            focus_follows_mouse = "off";
            window_placement = "second_child";
            window_topmost = "off";
            window_shadow = "float";
            window_opacity = "off ";
            window_opacity_duration = "0";
            active_window_opacity = "1.0";
            normal_window_opacity = "0.80";
            window_border = "off";
            window_border_width = "2";
            window_border_radius = "0";
            active_window_border_color = "0xff775759 ";
            normal_window_border_color = "0xff505050";
            split_ratio = "0.50";
            auto_balance = "off";
            mouse_modifier = "fn";
            mouse_action1 = "move";
            mouse_action2 = "resize";
            mouse_drop_action = "stack";
            layout = "bsp";
            top_padding = "0";
            bottom_padding = "0";
            left_padding = "5";
            right_padding = "5";
            window_gap = "5";
          };
          extraConfig = ''
            yabai -m window_origin_display               focus

            function setup_space {
              local idx="$1"
              local name="$2"
              local space=
              echo "setup space $idx : $name"

              space=$(yabai -m query --spaces --space "$idx")
              if [ -z "$space" ]; then
                yabai -m space --create
              fi

              yabai -m space "$idx" --label "$name"
            }

            setup_space 1 
            setup_space 2 
            setup_space 3 
            setup_space 4 

            yabai -m rule --add app="^Zotero$" space=2
            yabai -m rule --add app="^Zotero$" title="^Zotero$" manage=on
            yabai -m rule --add app="^Music$" space=4
            yabai -m rule --add app="^iTunes$" title="^MiniPlayer$" manage=off
            yabai -m rule --add app="^TV$" space=4
            yabai -m rule --add app="^Finder$" title="^Trash$" manage=off
            yabai -m rule --add app="^Finder$" title="^Copy$" manage=off
            yabai -m rule --add app="^System Preferences$" manage=off
            yabai -m rule --add app="^Brother MFC-J875DW$" manage=off
            yabai -m rule --add app="^stv412-phil-copier$" manage=off
            yabai -m rule --add app="^Tor Browser$" manage=off
            yabai -m rule --add app="^App Store$" manage=off
            yabai -m rule --add app="^LogicProgram$" title="^Logic 2010: Menu$" manage=off
            yabai -m rule --add app="^LogicProgram$" title="^Not.*$" manage=off
            yabai -m rule --add app="^LogicProgram$" title="^Submit Problems$" manage=off
            yabai -m rule --add app="^LogicProgram$" title="^Problems$" manage=off
            yabai -m rule --add app='^zoom\.us$' manage=off
            yabai -m rule --add app='^choose$' manage=off
            yabai -m rule --add app='^kitty$' title='^visor$' grid=1:1:1:1:1:1 opacity=0.9 layer=above manage=off 
            yabai -m rule --add app='^.kitty-wrapped$' title='^visor$' grid=1:1:1:1:1:1 opacity=0.9 layer=above manage=off 
            yabai -m rule --add app="^Visualizer$" manage=on
            yabai -m rule --add app="^TomatoFlex$" manage=off
            yabai -m rule --add app="^Firefox$" manage=on

          '';
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
