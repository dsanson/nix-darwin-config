{
  description = "David's Darwin system flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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
    nixvim.url = "github:dsanson/nixvim-flake";
    #nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
  };

  outputs = inputs@{ self, home-manager, nix-darwin, lix-module, nixpkgs, nixpkgs-stable, nixvim, nur }:
  let
    pkgs-stable = nixpkgs-stable.legacyPackages.aarch64-darwin;

    configuration = { pkgs, ... }: {

      nix.settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["@admin"];
      };
      
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.permittedInsecurePackages = [
        "olm-3.2.16"
      ];

      users.users.desanso = {
        description = "David Sanson";
        home = "/Users/desanso";
        shell = pkgs.fish;
      };

      environment.shells = [
        pkgs.fish
        pkgs.bashInteractive
        pkgs.zsh
      ];

      environment.variables = {
        EDITOR = "nvim";
      };
     
      environment.systemPackages = with pkgs; [ 

          # shells
          fish
          bashInteractive
          zsh
          
          # editor
          neovim

          # basic stuff
          less
          findutils
          curl
          wget
          fd
          fdupes
          ack
          gawk
          zip
          unar #cli version of theunarchiver
          unrar-wrapper
          openssh
          gnupg
          python311Packages.keyring
          ncdu_1
          netcat
          nmap
          parallel
          dos2unix
          rlwrap
          cachix # nix binary cache tool

          # mac specific cli
          skhd
          mas
          defaultbrowser #should move this to a dependency of the system setup
          dockutil # manage macos dock items from cli
          duti # set default app for file type on macos from cli
          monitorcontrol # control brightness of external monitors
          dark-mode-notify 
          darwin.trash # no longer working reliably for me: refuses to delete directories
          # haskellPackages.macrm # marked as broken---installed via homebrew instead

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
        upliftdesk = {
          enable = false;
          source = ./launchagents/com.davidsanson.upliftdesk.plist;
          target = "com.davidsanson.upliftdesk.plist";
        };
        dark-mode-notify = {
          enable = true;
          source = ./launchagents/ke.bou.dark-mode-notify.plist;
          target = "ke.bou.dark-mode-notify.plist";
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
      #nixpkgs.hostPlatform = "x86_64-darwin";
      nixpkgs.hostPlatform = "aarch64-darwin";
 
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
        ];

        brews = [
          "launch" #macos launcher that is better than open
          "rename" #consider alternatives
          "switchaudio-osx"
          "tag" #macos file tagging
          "lua"
          "luarocks"
          "brightness" #used by upliftdesk to check if monitor is off
          "displayplacer" #for rotating and managing displays"
        ];
        
        caskArgs.no_quarantine = true;
        casks = [
          # Important Apps
          "anylist" # not on nixpkgs
          "calibre" # nixpkgs broken on darwin
          "discord" # available on nixpkgs but poorly behaved
          "firefox" # nixpkgs linux only
          "google-chrome" # nixpkgs has chromium but linux only
          "microsoft-office" # not on nixpkgs
          "obs" # nixkpgs only builds for linux
          "obsidian" # nixpkgs linux only; am I still using this?
          "quicksilver" # not on nixpkgs
          "yacreader" # nixpkgs fails to build
          "zotero@beta" # nixpkgs linux only
          
          # Utilities and Tweaks
          "karabiner-elements" # nixpkgs needs to be updated for 15.0
          "keepingyouawake" # not on nixpkgs; caffeinate app
          "itsycal" # nixpkgs installs, but doesn't work; complains needs to be installed in /Applications
          "the-unarchiver" # nixpkgs has cli version
          "zerotier-one" # nixpkgs linux only
          "djview" # nixpkgs marked as broken
          "satori" # the ancient screensaver
          "aerial@beta" # video screen savers
          "adobe-digital-editions" # for adobe drm pdfs
          "aegisub" # nix build broken
          "dupeguru" # marked as broken in nix
          "raspberry-pi-imager" # nixpkgs#rpi-imager marked as broken
          "sf-symbols"
          "steam"

          # quicklook plugins
          "qlcolorcode"
          "qlmarkdown"
          "qlstephen"
          "qlvideo"
          "quicklook-csv"
          "syntax-highlight"

          # not installed but possibly useful
          # "android-platform-tools" 
          # "fontforge" 
          # "logic-2010"
          # "logitech-camera-settings" 
          # "oracle-jdk" 
          # "tor-browser"
          # "transmission"
          # "devcleaner" # clean out xcode caches and save disk space
        ];

        masApps = {
          "Kindle Classic"         =  405399194;
          "AdGuard for Safari"     =  1440147259;
          "Keynote"                =  409183694;
          "iMovie"                 =  408981434;
          "CamControl"             =  1503271162;
          "Pages"                  =  409201541;
          "Mpix"                   =  1282488470;
          "GarageBand"             =  682658836;
          "Visualizer"             =  1296177026;
          "Numbers"                =  409203825;
          "Prime Video"            =  545519333;
          "TomatoFlex"             =  1500965952;
          # "OneDrive"               =  823766827;
          # "DevCleaner"             =  1388020431;
          # "Paprika Recipe Manager" =  451907568;
        };
      };

      services = {
        ipfs = {
          enable = false;
          # ipfsPath = "/Users/desanso/ipfs";
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
              :: default : bar_colors background
              :: m1 @ : bar_colors 1 
              :: m2 @ : bar_colors 2
             # toggle between modes
             ctrl - s             ; m1 
             m1 < ctrl - s        ; m2
             m2 < ctrl - s    ->  : skhd -k 'escape'
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
             default < cmd - return : kitty-wrapper
             m1, m2 < cmd - return : skhd -k 'escape'; kitty-wrapper
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
             # caffeinate
             m1 < shift - c : skhd -k 'escape'; open "keepingyouawake:///toggle"
             # rotate external monitor
             m1 < r    :  skhd -k "escape"; rotate toggle
             # reload yabai
             m2 < r            : skhd -k 'escape'; launchctl stop org.nixos.yabai
             # q script to replace quicksilver
             default < ctrl -space : yabai -m window --toggle visor || open -a kitty.app -n --args --title "visor" /etc/profiles/per-user/desanso/bin/fish -C 'q -w'
             m1, m2 < ctrl -space : skhd -k "escape"; visor
             #m1 < u : skhd -k "escape"; bash -x uplift sit
             #m1 < shift - u : skhd -k "escape"; bash -x uplift stand
             m1 < u : skhd -k "escape"; echo 1 >> /tmp/com.davidsanson.upliftdesk.in
             m1 < shift - u : skhd -k "escape"; echo 2 >> /tmp/com.davidsanson.upliftdesk.in
          '';
        };

        yabai = {
          enable = true;
          package = pkgs.yabai;
          enableScriptingAddition = true;
          config = {
            external_bar = "all:38:0";
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
              layouts -s "$idx" current
            }

            setup_space 1 BOOK
            for s in 2 3 4 5; do
              setup_space $s
            done 

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
            yabai -m signal --add event=space_changed action='set_theme wallpaper' active=yes

            yabai -m signal --add event=space_created action='sketchybar --reload'
            yabai -m signal --add event=space_destroyed action='sketchybar --reload'
            yabai -m signal --add event=display_removed action='sketchybar --reload'

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
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        lix-module.nixosModules.default
        nur.nixosModules.nur
        {
          # nixpkgs.overlays = [
          # #   nixpkgs-firefox-darwin.overlay
          # ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit pkgs-stable;
            inherit nixvim;
          };
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
