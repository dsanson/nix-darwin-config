{pkgs, pkgs-stable, nixvim, config, ...}:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      amsmath
      babel-english
      bidi
      bookmark
      booktabs
      caption
      cbfonts-fd
      changepage
      cm-super
      ctex
      doublestroke
      dvisvgm
      enumitem
      eso-pic
      etoolbox
      everysel
      float
      fontawesome5
      fontspec
      footnotehyper
      frcursive
      fundus-calligra
      gitinfo
      gnu-freefont
      graphbox
      hyperref
      jknapltx
      latex-bin
      latexmk
      lineno
      lwarp
      mathastext
      microtype
      count1to
      multitoc
      prelim2e
      ragged2e 
      newunicodechar
      parskip
      pdfcol
      pgf
      physics
      preview
      relsize
      rsfs
      selnolig
      setspace
      sidenotes
      soul
      standalone
      tcolorbox
      textpos
      tikzfill
      tipa
      titlesec
      transparent
      unicode-math
      upquote
      url
      wasy
      wasysym
      xcolor
      xetex
      xkeyval
      xpatch
      xurl
      zref
      ;
  });
  # didn't fetchPypi because the nixOS patched version (2.8.0) is only on PyPI-testing
  # pywalfox = pkgs.python3.pkgs.buildPythonPackage {
  #   pname = "pywalfox";
  #   version = "2.8.0rc1";

  #   src = pkgs.fetchFromGitHub {
  #     owner = "Frewacom";
  #     repo = "pywalfox-native";
  #     rev = "7ecbbb193e6a7dab424bf3128adfa7e2d0fa6ff9";
  #     hash = "sha256-i1DgdYmNVvG+mZiFiBmVHsQnFvfDFOFTGf0GEy81lpE=";
  #   };
  # };

in
{
  home.username = "desanso";
  home.stateVersion = "24.11";
  home.homeDirectory = "/Users/desanso"; #mac specific
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # home.activation = {
  #   setDefaultBrowser = config.lib.hm.dag.entryAfter ["installPackages"] ''
  #     $DRY_RUN_CMD defaultbrowser firefox
  # '';
  # };

  # this adds to the END of PATH, which is not useful
  # home.sessionPath = [
  #   "$HOME/bin "
  #   "$HOME/.local/bin"
  #   "/opt/homebrew/bin"
  #   "/etc/profiles/per-user/desanso/bin"
  #   "/run/current-system/sw/bin"
  # ];

  home.shellAliases = {
    "..." = "cd ../..";
    #"ls" = "gls --hyperlink=auto";
    "ls" = "eza --hyperlink";
    "l" = "ls -lA";
    "rm" = "echo 'rm disabled; use trash or /bin/rm instead'";  #mac specific for now
    #"addprinter" = "lpadmin -E -p stv412-phil-copier -E -v lpd://cas-papercut.ad.ilstu.edu/stv412-phil-copier -m '/Library/Printers/PPDs/Contents/Resources/Xerox WorkCentre 5325.gz'";
    #"rmprinter" = "lpadmin -x stv412-phil-copier";
    "wanip" = "dig +short myip.opendns.com @resolver1.opendns.com";
    "latest_download" = "ls -tU $HOME/Downloads | head -n 1";
    "preview" = "open -a Preview"; #mac specific
    "reveal" = "open -R"; #mac specific
    "firefox" = "firefox-wrapper";
    "wttr" = "curl -s \"wttr.in/{$(dig +short myip.opendns.com @resolver1.opendns.com),Carmel%20CA,Paso%20Robles,Tenakee%20AK,Rimrock%20AZ,Libby%20MT}?format=4&u\" | sed 's/, Illinois, United States//'";
    "serve" = "devd -l";
    "mc" = "masterychecks";
    "lynx" = "lynx --vikeys";
    "play" = "nowplaying-cli play"; #mac specific
    "pause" = "nowplaying-cli pause"; #mac specific
    "next" = "nowplaying-cli next"; #mac specific
    "volume" = "m volume"; #mac specific
    #"sit" = "echo 1 >> /tmp/com.davidsanson.upliftdesk.in";
    #"stand" = "echo 2 >> /tmp/com.davidsanson.upliftdesk.in";
    "safari" = "open -a Safari";
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -r";
    LESSOPEN = "|lesspipe.sh %s";
    BROWSER = "open"; #mac specific
    MANPAGER = "nvim +Man!";
    MANWIDTH = 999;
    #FFSEND_HOST = "https://send.zcyph.cc";
    FFSEND_COPY = "";
    FFSEND_EXPIRY_TIME = "7d";
    FFSEND_DOWNLOAD_LIMIT = "20";
  };

  home.packages = (with pkgs; [
    
    coreutils-prefixed
    ed

    nixvim.packages.${system}.default

    ncdu
    rlwrap 
    unar # mac specific cli version of theunarchiver
    unrar-wrapper
    devd # simple cli webserver; consider just using nix shell
    qrencode
    aria # downloading tool
    gdrive3 
    samba 
    shared-mime-info
    socat # 
    wcalc #used by bin/q-preview # 
    lesspipe
    manix # search nix documentation
    fontconfig

    # ffsend # use nix shell nixpkgs#ffsend instead
    # uni # unicode lookup use nix shell nixpkgs#uni instead

    lua54Packages.lua
    lua54Packages.luarocks
    lua54Packages.penlight
    lua54Packages.luafilesystem

    # git
    delta # git highlighting 
    lazygit
    #hub # github cli tool
    git-lfs # git extension for large files  #git
    gh # github cli tool

    # webdev
    dart-sass # move to dev specific flake
    html-tidy # 
    html-xml-utils # 
    xmlto # 
    httpie # 

    # tui apps
    lynx
    w3m
    chawan # a modern tui browser?
    #epr # terminal epub reader
    bk # terminal epub reader
    timg #terminal image viewer
    newsraft #rss reader
    #toot #tui mastodon client
    jrnl

    # document generation
    biber
    bibtool
    mermaid-cli
    tectonic # modern tex wrapper 
    tex
    typst

    # pandoc filters
    pandoc-eqnos
    pandoc-secnos
    pandoc-fignos
    pandoc-tablenos
    pandoc-include
    pandoc-imagine
    haskellPackages.pandoc-sidenote
    haskellPackages.pandoc-crossref
    python313Packages.pandoc-xnos
    # mermaid-filter # not available on darwin

    # data processing
    R
    csvkit #broken build
    miller # awk for data formats #csv 
    pup
    python313Packages.pyexcel
    sc-im
    tidy-viewer # csv pretty printer
    visidata 
    xan
    yq
    jq
    jqp

    # pdf and images
    cairo
    djvu2pdf
    djvulibre
    djview
    ghostscript
    imagemagick
    ocrmypdf 
    pdf2svg 
    pdfcpu
    pdfgrep
    poppler_utils # provides pdftocairo
    qpdf
    scantailor
    tesseract
    unpaper
    yacreader
    tdf #terminal pdf viewer

    # media
    ffmpeg
    srt-to-vtt-cl
    nowplaying-cli #mac specific

    # games
    angband
    figlet
    nsnake
    maelstrom

    # ricing and theming
    wallust
    pywalfox-native
    
    # fonts
    amiri #arabic font
    andika # for for beginning readers
    charis-sil #another multilingual font
    dejavu_fonts
    nerd-fonts.dejavu-sans-mono
    doulos-sil #another multilingual font
    fira-code # fira-mono with coding ligatures
    nerd-fonts.fira-code
    fira-go #fira sans with multilingual support
    font-awesome
    gentium # good for diacritics
    kawkab-mono-font # arabic monospace font
    monoid
    nerd-fonts.monoid
    mononoki
    nerd-fonts.mononoki
    open-dyslexic
    nerd-fonts.open-dyslexic
    source-code-pro
    victor-mono # has all arabic transliteration diacritics
    nerd-fonts.victor-mono # has all arabic transliteration diacritics
    xits-math
    cardo # font specifically designed for the needs of classicists, Biblical scholars, medievalists, and linguists
    libertinus # recommended math font to pair with cardo
    crimson-pro

    # gui apps
    #firefox #works but syncing was irritating.
    # android-file-transfer # install if needed
    anki-bin # flashcards
    # audacity # was building from source; use brew instead
    musescore
    vlc-bin 

    # mac specific gui apps
    grandperspective
    iina
    keycastr
    terminal-notifier
    choose-gui
    whatsapp-for-mac

    (writeShellApplication {
      name = "bib2path2";
      runtimeInputs = [ coreutils gnused gnugrep pandoc jq ];
      text = (builtins.readFile ./bin/bib2path2);
    })

    (writeShellApplication {
      name = "noise";
      text = (builtins.readFile ./bin/noise); 
    })

    (writeShellApplication {
      name = "opacity";
      runtimeInputs = [ yabai bc ];
      text = (builtins.readFile ./bin/opacity);
    })

    (writeShellApplication {
      name = "layouts";
      runtimeInputs = [ yabai ];
      text = (builtins.readFile ./bin/layouts);
    })

    (writeShellApplication {
      name = "set_theme";
      runtimeInputs = [ yabai jq gnused kitty wallust ];
      text = (builtins.readFile ./bin/set_theme);
    })

    (writeShellApplication {
      name = "bar_colors";
      runtimeInputs = [ sketchybar ];
      text = (builtins.readFile ./bin/bar_colors);
    })

    (writeShellApplication {
      name = "rotate";
      text = (builtins.readFile ./bin/rotate);
    })

    (writeShellApplication {
      name = "scores";
      runtimeInputs = [ pandoc gnused ack iconv curl coreutils-prefixed];
      text = (builtins.readFile ./bin/scores);
    })

    (writeShellApplication {
      name = "firefox-wrapper";
      text = (builtins.readFile ./bin/firefox-wrapper);
    })

    (writeShellApplication {
      name = "kitty-wrapper";
      runtimeInputs = [ jq kitty yabai ]; 
      text = (builtins.readFile ./bin/kitty-wrapper);
    })

    (writeShellApplication {
      name = "uplift";
      runtimeInputs = [ gnused gawk ];
      text = (builtins.readFile ./bin/uplift);
    })

  ])

  ++

  (with pkgs-stable; [
    #hello
  ]);

  xdg.enable = true;
  xdg.configFile = {
    mdnotes = {
      source = ./config/mdnotes;
      recursive = true;
    };
    markdownlint = {
      source = ./config/markdownlint;
      recursive = true;
    };
    visidata = {
      source = ./config/visidata;
      recursive = true;
    };
    "fd/ignore".text = "**/*.app/**";
  };

  xdg.dataFile = {
    pandoc = {
      source = ./share/pandoc;
      recursive = true;
    };
  };

  home.file.kitty-launch-actions = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/kitty/launch-actions.conf";
    target = ".config/kitty/launch-actions.conf";
  };

  home.file.skhdrc = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/skhd/skhdrc";
    target = ".config/skhd/skhdrc";
  };

  home.file.sioyek = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/sioyek";
    target = ".config/sioyek";
  };

  home.file.wallust = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/wallust";
    target = "Library/Application Support/wallust";
  };

  home.file.chawan = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/chawan";
    target = ".config/chawan";
  };

  home.file.newsraft = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/newsraft";
    target = ".config/newsraft";  
  };

  home.file.sketchybar = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/sketchybar";
    target = ".config/sketchybar";
  };

  home.file.tridactyl = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/tridactyl";
    target = ".config/tridactyl";
  };

  home.file.presenterm = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-darwin-config/config/presenterm";
    target = ".config/presenterm";
  };

  accounts.calendar = {
    basePath = ".calendars";
    accounts.icloud = {
      
      primaryCollection = "home";
      local.fileExt = ".ics";
      local.type = "filesystem";

      remote.passwordCommand = [ "security" "find-generic-password" "-l" "caldav" "-w" ];
      remote.type = "caldav";
      remote.url = "https://caldav.icloud.com/";
      remote.userName = "dsanson@gmail.com";

      vdirsyncer.enable = true;
      vdirsyncer.collections = [
        ["home" "home" "home"] 
        ["work" "work" "work"]
      ];
      vdirsyncer.itemTypes = ["VEVENT"];
      vdirsyncer.metadata = ["displayname" "color"];

      khal.enable = true;
      khal.color = "dark cyan";
      khal.type = "discover";
    }; 
  };

  accounts.contact = {
    basePath = ".contacts";
    accounts.icloud = {

      local.fileExt = ".vcf";
      local.type = "filesystem";

      remote.passwordCommand = [ "security" "find-generic-password" "-l" "caldav" "-w" ];
      remote.type = "carddav";
      remote.url = "https://contacts.icloud.com/";
      remote.userName = "dsanson@gmail.com";
      
      vdirsyncer.enable = true;
      vdirsyncer.metadata = ["displayname"];
      # vdirsyncer.collections = ["from a" "from b"];
    };
    accounts."icloud/card" = {
      khard.enable = true;
      local.fileExt = ".vcf";
      local.type = "filesystem";
    };
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = false;
      historyControl = [ "erasedups" ];
      historyIgnore = [ "ls" "cd" "exit" "z" ];
      bashrcExtra = ''
        export PATH="$HOME/bin:$HOME/.local/bin:/etc/profiles/per-user/desanso/bin:/run/current-system/sw/bin:$PATH"
      '';
      initExtra = ''
        set -o vi
      '';
    };

    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableVteIntegration = false;
      autosuggestion.enable = true;
      history.ignoreAllDups = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        export PATH="$HOME/bin:$HOME/.local/bin:/etc/profiles/per-user/desanso/bin:/run/current-system/sw/bin:$PATH"
        bindkey -v
      '';
    };
    fish = {
      enable = true;
      functions = {
        retakes = "carnap hiddens $argv | sort";
        playlist = "osascript -e 'tell app \"Music\" to play the playlist named \"'$argv'\"'";
        fish_title = ''
          function fish_title
              # If we're connected via ssh, we print the hostname.
              set -l ssh
              set -q SSH_TTY
              and set ssh "["(prompt_hostname | string sub -l 10 | string collect)"]"
              # An override for the current command is passed as the first parameter.
              # This is used by `fg` to show the true process name, among others.
              if set -q argv[1]
                  echo -- $ssh (string sub -l 20 -- $argv[1]): (prompt_pwd -d 0 -D 0)
              else
                  # Don't print "fish" because it's redundant
                  set -l command (status current-command)
                  if test "$command" = fish
                      set command
                  end
                  echo -- $ssh (string sub -l 20 -- $command): (prompt_pwd -d 1 -D 1)
              end
          end
          '';
      };
      interactiveShellInit = ''
        set -g fish_key_bindings fish_vi_key_bindings
        set -g fish_greeting ""
        if type -q luarocks
          eval (luarocks path)
        end
        fish_add_path /run/current-system/sw/bin
        fish_add_path /etc/profiles/per-user/desanso/bin
        fish_add_path $HOME/.local/bin
        fish_add_path $HOME/bin 
        fish_add_path /opt/homebrew/bin
        defaultbrowser firefox >/dev/null
        if type -q kitty
          kitty @ set-colors -c ~/.cache/wal/colors-kitty.conf
        end
      '';
      plugins = [
        # { name = "bass"; src = pkgs.fishPlugins.bass; }
        # { name = "foreign-env"; src = pkgs.fishPlugins.foreign-env; }
        {
          name = "fish-completion-pandoc";
          src = pkgs.fetchFromGitHub {
            owner = "dsanson";
            repo = "fish-completion-pandoc";
            rev = "7195da6fc4bcbdd49ea63d47c27e4bfec2135660";
            hash = "sha256-pVobe3JsJWCaVyn+c3Y6+ibxlGTCCD1fj2u9LjEmAPg=";
          };
        }
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      #enableFishIntegration = true; appears to be already set
      enableZshIntegration = true;
    };
    
    ripgrep = {
      enable = true;
      #package = pkgs-stable.ripgrep;
    };
    sioyek = {
      enable = true;
      package = pkgs-stable.sioyek;
    };
    tealdeer.enable = true;
    pandoc = {
      package = pkgs.pandoc;
      enable = false;
      citationStyles = [
        ./share/csl/oxford-university-press-humsoc.csl
        ./share/csl/oxford-university-press-note.csl
      ];
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      options = [
        #"--cmd cd" #replace cd
      ];
    };
    tmux = {
      enable = true;
      prefix = "C-a";
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      focusEvents = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        mode-indicator
      ];
      extraConfig = ''
        set -g allow-passthrough on
        set -g status-right '#{tmux_mode_indicator}'
      '';
    };
    vdirsyncer.enable = true;
    khal = {
      enable = true;
      settings = {
        default = {
          default_calendar = "work";
          highlight_event_days = true;
        };
        locale = {
          timeformat = "%I:%M %p";
          dateformat = "%Y-%m-%d";
          longdateformat = "%Y-%m-%d";
          datetimeformat = "%Y-%m-%d %I:%M %p";
          longdatetimeformat = "%Y-%m-%d %I:%M %p";
          firstweekday = 6;
        };
        view = {
          frame = "color";
        };
      };
    };
    khard.enable = true;
    eza = { # ls replacement
      enable = true; 
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    todoman.enable = true;
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd -t d . $HOME";
      defaultCommand = "fd . $HOME";
      fileWidgetCommand = "fd . $HOME";
      defaultOptions = [
        "--cycle" 
        "--layout=default" 
        "--border=none" 
        "--height=~100%" 
        "--preview-border=none"
        "--preview-window=wrap" 
        "--marker='»'" 
        "--ansi"
      ];
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    git = {
      enable = true;
      userEmail = "dsanson@gmail.com";
      userName = "David Sanson"; 
      # settings = {
      #   user.email = "dsanson@gmail.com";
      #   user.name = "David Sanson";
      # };
      ignores = [
        "**/.DS_Store"
        "tags"
      ];
    };
    # delta = {
    #   enable = true;
    #   enableGitIntegration = true;
    # };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };
    kitty = {
      enable = true;
      #package = pkgs-stable.kitty;
      darwinLaunchOptions = [
        "--single-instance"
        "--instance-group=1"
        "--allow-remote-control=socket-only"
        "--listen-on=unix:/tmp/mykitty"
      ];
      font = {
        #name = "Victor Mono";
        name = "Fira Mono";
        size = 18.0;
        package = pkgs.fira-mono;
      };
      settings = {
        editor = "nvim"; # this is a kludge until I get nixvim properly integrated into home manager
        bold_font = "auto";
        italic_font = "auto"; #"Source Code Pro Italic"
        #font_features = "FiraCode +zero +ss03 +cv30";
        force_ltr = "yes";
        visual_bell_duration = "0.01";
        window_border_width = "1.0";
        window_padding_width = "5.0";
        inactive_text_alpha = "0.9";
        hide_window_decorations = "titlebar-only";
        tab_title_template = "{title}";
        dim_opacity = "0.75";
        env = "TERM_PROGRAM=kitty";
        clipboard_control = "write-clipboard write-primary";
        shell_integration = "no-sudo";
        macos_option_as_alt = "yes";
        kitty_mod = "super";
        allow_remote_control = "socket-only";
        cursor_trail = 10;
        scrollback_fill_enlarged_window = "yes";
      };
      extraConfig = ''
        include ~/.cache/wal/colors-kitty.conf
      '';
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      settings = {
        add_newline = false;
        git_branch = {
          symbol = "";
          truncation_length = 4;
          truncation_symbol = "";
          ignore_branches = ["master" "main"];
        };
        nodejs.disabled = true;
        shell.disabled = false;
        shell.fish_indicator = "";
        shell.bash_indicator = "\\$";
        shell.zsh_indicator = "%";
        shell.format = "[$indicator]($style)";
      };
    };

    mpv = {
      enable = true; 
      scripts = [ 
        pkgs.mpvScripts.videoclip
        pkgs.mpvScripts.sponsorblock-minimal 
        pkgs.mpvScripts.autosub
      ];
    };
  };
  
  fonts.fontconfig.enable = true;

  services = {
    syncthing.enable = true;
  };
 
  targets.darwin.defaults = {
    NSGlobalDomain.AppleLanguages = [
      "en-US"
      "ar-US"
    ];
    NSGlobalDomain.AppleLocale = "en-US";
  };

  targets.darwin.search = "DuckDuckGo";

  nix.gc.automatic = true;
}

