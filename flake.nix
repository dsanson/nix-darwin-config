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
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
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
    nixvim.url = "github:dsanson/nixvim-flake";
  };

  outputs = inputs@{ self, home-manager, nix-darwin, lix-module, nixpkgs, nixpkgs-stable, nixvim }:
  let
    pkgs-stable = nixpkgs-stable.legacyPackages.aarch64-darwin;

    configuration = { pkgs, ... }: {

      nix.settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["@admin"];
      };
      
      nixpkgs.config.allowUnfree = true;

      # nixpkgs.config.permittedInsecurePackages = [
      #   "olm-3.2.16" # this is (was?) needed for installing some matrix clients
      # ];

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

      # moved to home.sessionVariables
      # environment.variables = {
      #   EDITOR = "nvim";
      # };
     
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
          openssh
          gnupg
          python311Packages.keyring
          netcat
          nmap
          parallel
          dos2unix
          cachix # nix binary cache tool

          # ncdu # move to home
          # rlwrap # move to home
          # unar #move to home; cli version of theunarchiver
          # unrar-wrapper #move to home

          # mac specific cli
          skhd
          mas
          defaultbrowser #should move this to a dependency of the system setup
          #dockutil # manage macos dock items from cli
          #duti # set default app for file type on macos from cli
          monitorcontrol # control brightness of external monitors
          dark-mode-notify 
          switchaudio-osx
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
      # services.nix-daemon.enable = true;
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

      security.pam.services.sudo_local.touchIdAuth = true;
      security.pam.services.sudo_local.watchIdAuth = true;

      system.primaryUser = "desanso"; # https://mynixos.com/nix-darwin/option/system.primaryUser

      # migrate to targets.darwin.defaults in home manager
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
        onActivation.autoUpdate = false;
        
        # taps = [
        #   "dsanson/tap" #for logic2010
        # ];

        brews = [
          "brightness" #used by upliftdesk to check if monitor is off
          "displayplacer" #for rotating and managing displays"
          "launch" #macos launcher that is better than open
          "pandoc" #nix pandoc is chronically out of date
          "rename" #consider alternatives
          #"switchaudio-osx"
          "tag" #macos file tagging
          "yt-dlp"
          "keith/formulae/reminders-cli" #not sure this will work
        ];

        caskArgs.no_quarantine = true;
        casks = [
          # Important Apps
          "anylist" # not on nixpkgs
          "calibre" # nixpkgs broken on darwin
          "discord" # available on nixpkgs but poorly behaved
          "firefox" # looks like it may now work. But version lags.
          "google-chrome" # nixpkgs has chromium but linux only
          #"microsoft-office" # not on nixpkgs # this breaks because of microsoft defender
          "obs" # nixkpgs only builds for linux
          "obsidian" # nixpkgs linux only; am I still using this?
          "quicksilver" # not on nixpkgs
          "yacreader" # nixpkgs fails to build
          "zotero@beta" # nixpkgs linux only
          "signal"
          "whatsapp" #replace with nixpkgs#whatsapp-for-mac?
          
          # Utilities and Tweaks
          "karabiner-elements" # nixpkgs needs to be updated for 15.0
          "keepingyouawake" # not on nixpkgs; caffeinate app
          "itsycal" # nixpkgs installs, but doesn't work; complains needs to be installed in /Applications
          "the-unarchiver" # nixpkgs has cli version
          "zerotier-one" # nixpkgs linux only
          "maccy" # clipboard manager
          "djview" # nixpkgs marked as broken
          "satori" # the ancient screensaver
          "aerial@beta" # video screen savers
          "adobe-digital-editions" # for adobe drm pdfs
          #"aegisub" # brew marked as deprecated
          "dupeguru" # marked as broken in nix
          "raspberry-pi-imager" # nixpkgs#rpi-imager marked as broken
          "sf-symbols"
          "google-earth-pro"
          "noscribe" # AI transcription
          "atv-remote"
          "homerow" # control MacOS buttons with keyboard

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
          "Xcode"                  =  497799835;
          # "OneDrive"               =  823766827;
          # "DevCleaner"             =  1388020431;
          # "Paprika Recipe Manager" =  451907568;
        };
      };

      services = {
        ipfs = {
          enable = true;
          ipfsPath = "/Users/desanso/.ipfs";
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
          skhdConfig = builtins.readFile ./config/skhd/skhdrc;
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

            # setup_space 1 BOOK 
            setup_space 1
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
            yabai -m rule --add app='^kitty$' title='^visor$' grid="20:20:2:1:16:16" opacity=0.9 scratchpad="visor"
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
    # $ sudo darwin-rebuild build --flake .#halibut
    darwinConfigurations."halibut" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        lix-module.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit pkgs-stable;
            inherit nixvim;
          };
          home-manager.users.desanso.imports = [
            ./home.nix 
          ];
        }
      ];
    };
    
    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."halibut".pkgs;
  };
}
