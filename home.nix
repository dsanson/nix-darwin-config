{pkgs, ...}: 
{
  home.username = "desanso";
  home.stateVersion = "23.11";
  home.homeDirectory = "/Users/desanso";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.shellAliases = {
    "..." = "cd ../..";
    "addprinter" = "lpadmin -E -p stv412-phil-copier -E -v lpd://cas-papercut.ad.ilstu.edu/stv412-phil-copier -m '/Library/Printers/PPDs/Contents/Resources/Xerox WorkCentre 5325.gz'";
    "rmprinter" = "lpadmin -x stv412-phil-copier";
  };

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };

  # home.packages = with pkgs; [
  #   curl
  #   ack
  #   fd
  #   fdupes
  #   gawk
  #   gnupg
  #   less
  #   mosh
  #   pup
  #   wget
  #   zip
  # ];
 
  accounts.calendar = {
    basePath = ".calendars";
    accounts.home = {

      local.fileExt = ".ics";
      local.type = "filesystem";

      # remote.passwordCommand = [ "security" "find-generic-password" "-l" "caldav" "-w" ];
      # remote.type = "caldav";
      # remote.url = "https://caldav.icloud.com/";
      # remote.username = "dsanson@gmail.com";

      vdirsyncer.enable = false;
      vdirsyncer.itemTypes = ["VEVENT"];

      khal.enable = true;
      khal.color = "dark cyan";
      khal.type = "calendar";
    }; 
    accounts.work = {

      local.fileExt = ".ics";
      local.type = "filesystem";

      # remote.passwordCommand = [ "security" "find-generic-password" "-l" "caldav" "-w" ];
      # remote.type = "caldav";
      # remote.url = "https://caldav.icloud.com/";
      # remote.username = "dsanson@gmail.com";

      vdirsyncer.enable = false;
      vdirsyncer.itemTypes = ["VEVENT"];

      khal.enable = true;
      khal.color = "dark green";
      khal.type = "calendar";
    }; 
  };

  accounts.contact = {
    basePath = ".contacts";
    accounts.card = {

      local.fileExt = ".vcf";
      local.type = "filesystem";

      # remote.passwordCommand = [ "security" "find-generic-password" "-l" "caldav" "-w" ];
      # remote.type = "carddav";
      # remote.url = "https://contacts.icloud.com/";
      # remote.userName = "dsanson@gmail.com";
      
      vdirsyncer.enable = false;
      khard.enable = true;
    };
  };

  programs = {
    aerc.enable = true;
    btop.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    mpv.enable = true;
    mu.enable = false;
    pywal.enable = true;
    ripgrep.enable = true;
    sioyek.enable = false;
    tealdeer.enable = true;
    yt-dlp.enable = true;
    pandoc = {
      enable = false;
    };
    texlive = {
      enable = false;
      #packageSet = basic;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
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
    # vdirsyncer.enable = true;
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
      enableAliases = true;
    };
    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd -t d . $HOME";
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
      fileWidgetCommand = "fd . $HOME";
    };
    git = {
      enable = true;
      userEmail = "dsanson@gmail.com";
      userName = "David Sanson";
      ignores = [
        "**/.DS_Store"
        "tags"
      ];
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
      #theme = "Gruvbox Material Light Hard";
      font = {
        name = "Fira Code";
        size = 18.0;
        package = pkgs.fira-code;
      };
      settings = {
        bold_font = "auto";
        italic_font = "auto"; #"Source Code Pro Italic"
        font_features = "FiraCode-Retina +zero";
        force_ltr = "yes";
        visual_bell_duration = "0.01";
        window_border_width = "1.0";
        window_padding_width = "5.0";
        inactive_text_alpha = "0.9";
        hide_window_decorations = "yes";
        tab_title_template = "{title}";
        dim_opacity = "0.75";
        env = "TERM_PROGRAM=kitty";
        clipboard_control = "write-clipboard write-primary";
        shell_integration = "no-sudo";
        macos_option_as_alt = "yes";
        kitty_mod = "super";
        allow_remote_control = "socket-only";
      };
      # extraConfig = ''
      #   include ~/Library/Preferences/kitty/current-theme.conf";
      # '';
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
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
  
  # services = {
  #   vdirsyncer.enable = true;
  # };
  
  targets.darwin.defaults = {
    NSGlobalDomain.AppleLanguages = [
      "en-US"
      "ar-US"
    ];
    NSGlobalDomain.AppleLocale = "en-US";
  };

}

