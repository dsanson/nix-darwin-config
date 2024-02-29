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
    kitty = {
      enable = true;
      darwinLaunchOptions = [
        "--single-instance"
        "--instance-group=1"
      ];
      font = {
        name = "Fira Code";
        size = 18.0;
        #package = pkgs.fira-code;
      };
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

