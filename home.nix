{pkgs, ...}: 
{
  home.username = "desanso";
  home.stateVersion = "23.11";
  home.homeDirectory = "/Users/desanso";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
 
  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };
  
  programs = {
    pywal.enable = true;
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


}

