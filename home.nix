{pkgs, config, ...}:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      amsmath
      babel-english
      bidi
      cbfonts-fd
      changepage
      cm-super
      ctex
      doublestroke
      dvisvgm
      enumitem
      everysel
      fontspec
      frcursive
      fundus-calligra
      gitinfo
      gnu-freefont
      graphbox
      jknapltx
      latex-bin
      latexmk
      lineno
      mathastext
      microtype
      ms
      newunicodechar
      parskip
      pgf
      physics
      preview
      ragged2e
      relsize
      rsfs
      selnolig
      setspace
      sidenotes
      soul
      standalone
      tipa
      titlesec
      transparent
      wasy
      wasysym
      xcolor
      xetex
      xkeyval
      xpatch
      zref
      ;
  });
in
{
  home.username = "desanso";
  home.stateVersion = "24.05";
  home.homeDirectory = "/Users/desanso"; #mac specific
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # home.activation = {
  #   setDefaultBrowser = config.lib.hm.dag.entryAfter ["installPackages"] ''
  #     $DRY_RUN_CMD defaultbrowser firefox
  # '';
  # };


  home.shellAliases = {
    "..." = "cd ../..";
    "l" = "ls -lA";
    "z" = "cd";
    "rm" = "echo 'rm disabled; use trash or /bin/rm instead'";  #mac specific for now
    "addprinter" = "lpadmin -E -p stv412-phil-copier -E -v lpd://cas-papercut.ad.ilstu.edu/stv412-phil-copier -m '/Library/Printers/PPDs/Contents/Resources/Xerox WorkCentre 5325.gz'";
    "rmprinter" = "lpadmin -x stv412-phil-copier";
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
    "liar" = "z liar; nvim -c 'Telescope find_files'";
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PAGER = "less -r";
    BROWSER = "open"; #mac specific
    FFSEND_HOST = "https://send.zcyph.cc";
    FFSEND_COPY = "";
    FFSEND_EXPIRY_TIME = "7d";
    FFSEND_DOWNLOAD_LIMIT = "20";
  };

  home.packages = with pkgs; [
    tex
    # dev
    lazygit
    hub
    # webdev
    dart-sass # move to dev specific flake
    # document readers
    epr
    # editor
    tree-sitter
    universal-ctags
    nil
    marksman #zettlekasten style lsp 
    lua-language-server
    # data
    R
    visidata
    xsv
    yq
    pup
    #sc-im #build is broken
    # web browsing
    lynx
    w3m
    # pdf and images
    imagemagick
    ghostscript
    cairo
    djvu2pdf
    djvulibre
    ocrmypdf
    pdfcpu
    pdfgrep
    qpdf
    scantailor
    tesseract
    unpaper
    # media
    ffmpeg
    # document generation
    biber
    bibtool
    typst
    # games
    angband
    figlet
    nsnake
    # flashcards
    anki-bin 
    # fonts
    dejavu_fonts
    victor-mono # has all arabic transliteration diacritics
    fira-code # fira-mono with coding ligatures
    fira-code-nerdfont
    fira-go #fira sans with multilingual support
    font-awesome
    kawkab-mono-font # arabic monospace font
    monoid
    mononoki
    open-dyslexic
    source-code-pro
    xits-math
    gentium # good for diacritics
    andika # for for beginning readers
    charis-sil #another multilingual font
    doulos-sil #another multilingual font
    amiri #arabic font

    uni # unicode lookup
    ffsend
    wallust #pywall replacement

    # gui apps
    
    #adobe-digital-editions		
    #aegisub	        			
    android-file-transfer		
    #android-platform-tools		
    #anki                        
    #anylist #mac only            
    audacity                    
    #calibre                     
    #discord                     
    #djview                      
    #dupeguru                    
    #firefox                     
    #font-awesome-terminal-fonts	
    #font-hack-nerd-font		    
    #font-monofur-nerd-font		
    #font-monofur-nerd-font-mono	
    #fontforge                   
    #google-chrome               
    #hammerspoon #mac only            
    #haptickey #mac only                  
    #itsycal #mac only            
    #keepingyouawake #mac only          
    #keycastr #mac only                    
    #logic-2010                  
    #logitech-camera-settings
    #marta # mac only
    #musescore
    #obsidian
    #oracle-jdk
    #quicksilver # mac only
    #rar
    #raspberry-pi-imager
    #satori # mac only
    #sf-symbols 
    #syncthing
    #syntax-highlight #mac only
    #the-unarchiver #mac only
    #tor-browser
    #transmission #mac only
    #vlc
    #yacreader
    #zerotier-one
    #zoom
    #zotero
  ];

  xdg.enable = true;
  xdg.configFile = {
    nvim = {
      source = ./config/nvim;
      recursive = true;
    };
    mdnotes = {
      source = ./config/mdnotes;
      recursive = true;
    };
    markdownlint = {
      source = ./config/markdownlint;
      recursive = true;
    };
    sioyek = {
      source = ./config/sioyek;
      recursive = true;
    };
    tridactyl = {
      source = ./config/tridactyl;
      recursive = true;
    };
    visidata = {
      source = ./config/visidata;
      recursive = true;
    };
    sketchybar = {
      source = ./config/sketchybar;
      recursive = true;
    };
    "fd/ignore".text = "**/*.app/**";
  };

  home.file.hammerspoon = {
    source = ./config/hammerspoon;
    recursive = true;
    target = ".hammerspoon";
  };

  home.file.wallust = {
    source = ./config/wallust;
    target = "Library/Application Support/wallust";
  };

  home.file.pandoc = {
    source = ./config/pandoc;
    recursive = true;
    target = ".pandoc";
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
      vdirsyncer.collections = [["home" "home" "home"] ["work" "work" "work"]];
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
      enableVteIntegration = true;
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
      enableVteIntegration = true;
      autosuggestion.enable = true;
      history.ignoreAllDups = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        export PATH="$HOME/bin:$HOME/.local/bin:/etc/profiles/per-user/desanso/bin:/run/current-system/sw/bin:$PATH"
        bindkey -v
      '';
    };
    fish = {
      enable = true;
      functions = {
        retakes = "carnap hiddens $argv | sort";
        playlist = "osascript -e 'tell app \"Music\" to play the playlist named \"'$argv'\"'";
      };
      interactiveShellInit = ''
        set -g fish_key_bindings fish_vi_key_bindings
        set -g fish_greeting ""
        if type -q brew
          set -x HOMEBREW_CASK_OPTS "--appdir=$HOME/Applications"
          set -x ASDF_DIR (brew --prefix asdf)/libexec
          source $ASDF_DIR/asdf.fish
        end
        eval (luarocks path)
        fish_add_path /run/current-system/sw/bin
        fish_add_path /etc/profiles/per-user/desanso/bin
        fish_add_path $HOME/.cargo/bin
        fish_add_path $HOME/.go/bin
        fish_add_path $HOME/.pub-cache/bin
        fish_add_path $HOME/.luarocks/bin 
        fish_add_path $HOME/.local/bin
        fish_add_path $HOME/bin 
        defaultbrowser firefox >/dev/null
        if type -q kitty
          #kitty @ set-colors -c ~/.cache/wal/colors-kitty.conf
        end
      '';
      plugins = [
        {
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "pure-fish";
            repo = "pure";
            rev = "28447d2e7a4edf3c954003eda929cde31d3621d2";
            hash = "sha256-8zxqPU9N5XGbKc0b3bZYkQ3yH64qcbakMsHIpHZSne4=";
          };
        }
        {
          name = "bass";
          src = pkgs.fetchFromGitHub {
            owner = "edc";
            repo = "bass";
            rev = "79b62958ecf4e87334f24d6743e5766475bcf4d0";
            hash = "sha256-3d/qL+hovNA4VMWZ0n1L+dSM1lcz7P5CQJyy+/8exTc=";
          };
        }
        {
          name = "fishopts";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "fishopts";
            rev = "4b74206725c3e11d739675dc2bb84c77d893e901";
            hash = "sha256-9hRFBmjrCgIUNHuOJZvOufyLsfreJfkeS6XDcCPesvw=";
          };
        }
        {
          name = "reljump";
          src = pkgs.fetchFromGitHub {
            owner = "anordal";
            repo = "reljump.fish";
            rev = "a91fbaf84f1c5c7c00561bdad818c06b5e820436";
            hash = "sha256-/krwAOuaiZ7HsXdmVxqjg4G2NbtX3TVwOj/xAq/HDHA=";
          };
        }
        {
          name = "fish-completion-pandoc";
          src = pkgs.fetchFromGitHub {
            owner = "dsanson";
            repo = "fish-completion-pandoc";
            rev = "7195da6fc4bcbdd49ea63d47c27e4bfec2135660";
            hash = "sha256-pVobe3JsJWCaVyn+c3Y6+ibxlGTCCD1fj2u9LjEmAPg=";
          };
        }
        {
          name = "foreign-env";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-foreign-env";
            rev = "7f0cf099ae1e1e4ab38f46350ed6757d54471de7";
            hash = "sha256-4+k5rSoxkTtYFh/lEjhRkVYa2S4KEzJ/IJbyJl+rJjQ=";
          };
        }
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "dfdf69369bd3a3c83654261f90363da2aa1db8c9";
            hash = "sha256-x/q7tlMlyxZ1ow2saqjuYn05Z1lPOVc13DZ9exFDWoU=";
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
    
    # see https://github.com/bandithedoge/nixpkgs-firefox-darwin
    # firefox = {
    #   enable = true;
    #   package = pkgs.firefox-bin; # Or pkgs.librewolf if you're using librewolf
    # };

    # firefox = {
    #   enable = true;
    #   package = null;
    #   policies = {
    #     DefaultDownloadDirectory = "\${home}/Downloads";
    #     DisableBuiltinPDFViewer = true;
    #     EnableTrackingProtection = true;
    #   };
    #   profiles.default = {
    #     id = 0;
    #     isDefault = true;
    #     extensions = with config.nur.repos.rycee.firefox-addons; [
    #       privacy-badger
    #       tridactyl
    #       facebook-container
    #       #bypass-pwalls-clean
    #       multi-account-containers
    #       ublock-origin
    #       darkreader
    #       ipfs-companion
    #     ];
    #   };
    # };

    aerc.enable = true;
    btop.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    mpv.enable = true;
    mu.enable = false;
    ripgrep.enable = true;
    sioyek.enable = false;
    tealdeer.enable = true;
    translate-shell.enable = true;
    watson = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    yt-dlp.enable = true;
    pandoc = {
      enable = false;
    };
    texlive = {
      enable = false;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      options = [
        "--cmd cd" #replace cd
      ];
    };
    newsboat = {
      enable = true;
      urls = [
        { url = "https://www.logicmatters.net/feed/"; }
        { url = "https://diaryofdoctorlogic.wordpress.com/feed/"; }
        { url = "https://richardzach.org/feed/"; }
        { url = "https://robertpaulwolff.blogspot.com/feeds/posts/default?alt=rss"; }
        { url = "https://objectionable.net/feed/"; }
        { url = "https://aestheticsforbirds.com/feed/"; }
      ];
    };
    tmux = {
      enable = true;
      prefix = "C-a";
      aggressiveResize = true;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      newSession = true;
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
    };
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd -t d . $HOME";
      defaultCommand = "fd . $HOME";
      fileWidgetCommand = "fd . $HOME";
      defaultOptions = [
        "--cycle" 
        "--layout=reverse" 
        "--border" 
        "--height=90%" 
        "--preview-window=wrap" 
        "--marker='*'" 
        "--ansi"
      ];
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    git = {
      enable = true;
      userEmail = "dsanson@gmail.com";
      userName = "David Sanson";
      ignores = [
        "**/.DS_Store"
        "tags"
      ];
      delta.enable = true;
    };
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
      package = pkgs.kitty;
      darwinLaunchOptions = [
        "--single-instance"
        "--instance-group=1"
        "--listen-on=unix:/tmp/mykitty"
      ];
      font = {
        #name = "Victor Mono";
        name = "Fira Mono";
        size = 18.0;
        package = pkgs.fira-mono;
      };
      settings = {
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
      };
      extraConfig = ''
        include ~/.cache/wal/colors-kitty.conf
      '';
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = [ 
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        #pkgs.vimPlugins.which-key-nvim
        #pkgs.vimPlugins.nvim-lspconfig
        #pkgs.vimPlugins.nvim-lastplace
        #pkgs.vimPlugins.twilight-nvim
        #pkgs.vimPlugins.tcomment_vim
        #pkgs.vimPlugins.vim-gutentags
        #pkgs.vimPlugins.vim-easy-align
        #pkgs.vimPlugins.vim-speeddating
        #pkgs.vimPlugins.utl-vim
        #pkgs.vimPlugins.vim-gitgutter
        #pkgs.vimPlugins.conflict-marker-vim
        #pkgs.vimPlugins.csv-vim
      ];
      withPython3 = true;
      extraPython3Packages = ps: with ps; [ pynvim ];
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
      };
    };
    
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

