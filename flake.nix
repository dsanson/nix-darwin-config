{
  description = "David's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      #url = "github:wegank/nix-darwin/mddoc-remove";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
  };

  outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs, nur, nixpkgs-firefox-darwin }:
  let
    configuration = { pkgs, ... }: {

      nix.settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["@admin"];
      };
      
      nixpkgs.config.allowUnfree = true;

      users.users.desanso = {
        description = "David Sanson";
        home = "/Users/desanso";
      };

      environment.systemPackages = with pkgs;
        [ 
          # shells
          fish
          zsh
          
          skhd
          # basic system stuff
          curl
          ack
          fd
          fdupes
          gawk
          gnupg
          less
          mosh
          wget
          zip
          unar #cli version of theunarchiver
          unrar-wrapper

          # editing
          neovim

          
          # mac specific stuff
          m-cli # this is so out of date, not sure it is useful
          #shortcat #keyboard selection of macos elements
          defaultbrowser #should move this to a dependency of the system setup
          mas
          darwin.trash
          iina
          grandperspective
          monitorcontrol 
          xquartz 
          #dark-mode-notify #broken; need to create launchagent service
          nowplaying-cli

          # mac apps to check out
          # swiftbar (add scripts to menubar)
          # maccy (clipboard history)


          # email
          mu
          
          # python
          python311Packages.keyring

          # do I even use these?
          a2ps
          ant
          apr
          aria
          asciidoc
          #asdf-vm
          aspell
          atool
          bison
          #buf
          c-ares
          cachix
          #cadaver
          cargo
          catimg
          #ceres-solver
          cjson
          cmake
          cmocka
          #dante
          #dav1d
          delta
          #desktop-file-utils
          devd
          docbook5
          docbook-xsl-ns
          dockutil
          dos2unix
          doxygen
          duktape
          duti
          efm-langserver
          exiftool
          #faac
          #faad
          fftw
          findutils
          gdrive3
          git-lfs
          glyr
          go
          gradle
          groff
          #handbrake
          highlight
          html-tidy
          html-xml-utils
          httpie
          hugo
          hunspell
          hwloc
          intltool
          ispell
          jasper
          lftp
          libheif
          librist
          ltex-ls
          mbedtls
          mercurial
          miller
          mpg123
          msgpack
          msmtp
          mujs
          mupdf
          nasm
          ncdu_1
          ncurses
          neofetch
          netcat
          netpbm
          nmap
          opencv
          openmpi
          openssh
          optipng
          pango
          parallel
          pdf2svg
          pngcrush
          pngquant
          poppler
          pv
          pyenv
          qrencode
          rclone
          ripmime
          rlwrap
          rmlint
          #rnix-lsp unmaintained
          rustc
          samba
          scons
          shared-mime-info
          shellcheck
          socat
          sourceHighlight
          sphinx
          subversion
          tectonic
          terminal-notifier
          #texinfo
          tidy-viewer
          tig
          todo-txt-cli
          vala
          vale
          wcalc #used by bin/q-preview
          xmlto
          zk

        ];
      
      environment.pathsToLink = [ 
        "/share/bash-completion" 
        "/share/zsh" 
      ];

      environment.userLaunchAgents = {
        vdirsyncer = {
          enable = true;
          source = ./launchagents/com.davidsanson.vdirsyncer.plist;
          target = "com.davidsanson.vdirsyncer.plist";
        };
      };


      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;


      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.fish = {
        enable = true;
      };

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
          NSAutomaticWindowAnimationsEnabled = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSTableViewDefaultSizeMode = 1; #1 = small; 2 = medium; 3 = large
          _HIHideMenuBar = true;
          "com.apple.sound.beep.volume" = 0.4;
        };
        
        universalaccess = {
          reduceMotion = true;
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
          "dsanson/tap" #for logic2010
          "homebrew/cask-versions" #for zotero-beta
        ];

        brews = [
          "asdf"
          "launch" #macos launcher that is better than open
          "reminders-cli"
          "rename" #consider alternatives
          "switchaudio-osx"
          "tag" #macos file tagging
        ];

        casks = [
          "microsoft-office"
          "anylist"
          "keepingyouawake"
          "calibre"
          "firefox"
          "hammerspoon" # just for the caps lock key
          "haptickey" # only for macbook with annoying touchbar
          "itsycal" # nixpkg doesn't work complains needs to be installed in /Applications
          "marta" # trying
          "obsidian" # am I still using this?
          "quicksilver"
          "satori"
          "syncthing"
          "the-unarchiver"
          "yacreader"
          "zerotier-one"
          "zoom"
          "zotero-beta"
         
          # occasional use (but good to have on hand)
          "djview"
          "vlc"

          # occasional use (consider not keeping installed)
          "adobe-digital-editions"
          "aegisub" 
          "keycastr"
          "android-platform-tools"
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
          #"devcleaner" to clean out xcode caches and save disk space

          # quicklook plugins
          "qlcolorcode"
          "qlmarkdown"
          "qlstephen"
          "qlvideo"
          "quicklook-csv"
          "syntax-highlight"
          
          # fonts
          "font-awesome-terminal-fonts"
          "font-hack-nerd-font"
          "font-monofur-nerd-font"
          "font-monofur-nerd-font-mono"

        ];

        masApps = {
          #"OneDrive"               =  823766827;
          "Kindle Classic"         =  405399194;
          "AdGuard for Safari"     =  1440147259;
          "Keynote"                =  409183694;
          "iMovie"                 =  408981434;
          #"DevCleaner"             =  1388020431;
          #"Paprika Recipe Manager" =  451907568;
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
        ipfs = {
          enable = true;
          ipfsPath = "/Users/desanso/ipfs";
        };
        karabiner-elements = {
          enable = false;
        };
        sketchybar = {
          enable = true;
          package = pkgs.sketchybar;
          extraPackages = [ pkgs.jq pkgs.yabai pkgs.khal ];
        };
        
        skhd = {
          enable = true;
          package = pkgs.skhd;
          skhdConfig = ''
             # depends on
             #  bar_colors visor layouts opacity kitty-wrapper
             #  yabai
             #  firefox-wrapper fb-rotate 
             #  screenrecording webcam 
             # modes
              :: default : /Users/desanso/bin/bar_colors background
              :: m1 @ : /Users/desanso/bin/bar_colors 1 
              :: m2 @ : /Users/desanso/bin/bar_colors 2
             # toggle between modes
             ctrl - s             ; m1 
             m1 < ctrl - s        ; m2
             m2 < ctrl - s        ; default
             m1, m2 < escape ; default
             m1, m2 < i      ; default
             # tiling mode
             m1 < a            :  yabai -m space --layout bsp
             m1 < s            :  yabai -m space --layout stack
             m1 < d            :  yabai -m space --layout float
             # rotate window tree
             m1 < space		:   yabai -m space --rotate 90  
             # equalize window sizes
             m1 < 0x18   : yabai -m space --balance
             # fullscreen window
             #m1 < z     : skhd -k 'escape'; yabai -m window --toggle zoom-fullscreen
             # zoom-parent toggle
             m1 < p    : yabai -m window --toggle zoom-parent
             # float window
             m1 < f    : yabai -m window --toggle float 
             # pip window
             m2 < p : yabai -m window --toggle pip; yabai -m window --toggle sticky; yabai -m window --toggle topmost
             # cycle layouts
             m2 < c : layouts cycle
             # adjust opacity
             m2 < o : opacity toggle
             # window focus
             m1 < h   : yabai -m window --focus west  
             m1 < l   : yabai -m window --focus east   
             m1 < j   : yabai -m window --focus south   
             m1 < k   : yabai -m window --focus north   
             m1 < n   : yabai -m window --focus next 
             # window swap
             m2 < h   : yabai -m window --swap west   
             m2 < l   : yabai -m window --swap east   
             m2 < j   : yabai -m window --swap south   
             m2 < k   : yabai -m window --swap north   
             # change spaces 
             m1 < left  : yabai -m space --focus prev || yabai -m space --focus last
             m1 < right : yabai -m space --focus next || yabai -m space --focus first
             m1 < 1 : yabai -m space --focus 1
             m1 < 2 : yabai -m space --focus 2
             m1 < 3 : yabai -m space --focus 3
             m1 < 4 : yabai -m space --focus 4
             m1 < 5 : yabai -m space --focus 5
             m1 < 6 : yabai -m space --focus 6
             m1 < 7 : yabai -m space --focus 7
             m1 < 8 : yabai -m space --focus 8
             m1 < 9 : yabai -m space --focus 9
             # send window to space and follow focus
             m2 < left : yabai -m window --space prev; yabai -m space --focus prev
             m2 < right : yabai -m window --space next; yabai -m space --focus next
             m2 < 1 : yabai -m window --space 1; yabai -m space --focus 1
             m2 < 2 : yabai -m window --space 2; yabai -m space --focus 2
             m2 < 3 : yabai -m window --space 3; yabai -m space --focus 3
             m2 < 4 : yabai -m window --space 4; yabai -m space --focus 4
             m2 < 5 : yabai -m window --space 5; yabai -m space --focus 5
             m2 < 6 : yabai -m window --space 6; yabai -m space --focus 6
             m2 < 7 : yabai -m window --space 7; yabai -m space --focus 7
             m2 < 8 : yabai -m window --space 8; yabai -m space --focus 8
             m2 < 9 : yabai -m window --space 9; yabai -m space --focus 9
             # move space to recent display
             m2 < space :  yabai -m space --display next || yabai -m space --display first
             # move focus to other monitor 
             m1 < up    : yabai -m display --focus prev || yabai -m display --focus last
             m1 < down    : yabai -m display --focus next || yabai -m display --focus first
             # # move window to other monitor 
             m2 < up : yabai -m window --display prev; yabai -m display --focus prev
             m2 < down : yabai -m window --display next; yabai -m display --focus next 
             # open kitty
             default, m1, m2 < cmd - return : skhd -k 'escape'; exec kitty-wrapper
             # open quicksilver and spotlight
             m1, m2 < cmd - space : skhd -k 'escape'; skhd -k 'cmd - space'
             m1, m2 < cmd + alt - space : skhd -k 'escape'; skhd -k 'cmd + alt - space'
             # open firefox windows
             m1 < b   :  skhd -k "escape"; firefox-wrapper &
             m2 < b   :  skhd -k "escape"; firefox-wrapper --private-window &
             # screen capture
             m1 < c      :  skhd -k "escape"; /usr/sbin/screencapture -iUgc -J "window"
             # screenrecording
             #m1 < f5 : skhd -k 'escape'; $HOME/bin/screenrecording -d $HOME/Movies/screen -o capture
             #m1 < f6 : skhd -k 'escape'; $HOME/bin/webcam corner
             #m1 < f7 : skhd -k 'escape'; $HOME/bin/webcam doc
             # lock screen
             # rotate external monitor
             m1 < r    :  skhd -k "escape"; fb-rotate -d 1 -r 1
             # reload yabai
             m2 < r            : skhd -k 'escape'; launchctl stop org.nixos.yabai
             # q script to replace quicksilver
             default < ctrl -space : yabai -m window --toggle visor || open -a kitty.app -n --args --title "visor" /etc/profiles/per-user/desanso/bin/fish -C 'q -w'
             m1, m2 < ctrl -space : skhd -k "escape"; visor
          '';
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
            active_window_opacity = "0.95";
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

            setup_space 1 BOOK
            setup_space 2 
            setup_space 3 
            setup_space 4 
            setup_space 5

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
            yabai -m rule --add app='^kitty$' title='^visor$' grid="1:20:2:1:16:1" opacity=0.9 scratchpad="visor"
            yabai -m rule --add app="^Visualizer$" manage=on
            yabai -m rule --add app="^TomatoFlex$" manage=off
            yabai -m rule --add app="^Firefox$" manage=on
            yabai -m rule --add app="sioyek" role="AXWindow" subrole="AXDialog" manage=on
            yabai -m signal --add event=space_changed action='/Users/desanso/bin/set_theme wallpaper' active=yes

            yabai -m signal --add event=space_created action='sketchybar --reload'
            yabai -m signal --add event=space_destroyed action='sketchybar --reload'
            yabai -m signal --add event=display_removed action='sketchybar --reload'
            yabai -m signal --add event=front_app_switched="sketchybar 

            ${pkgs.sketchybar}/bin/sketchybar --reload
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
        nur.nixosModules.nur
        {
          # nixpkgs.overlays = [
          # #   nixpkgs-firefox-darwin.overlay
          # ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.desanso.imports = [
            nur.hmModules.nur ./home.nix 
          ];
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."halibut".pkgs;
  };
}
