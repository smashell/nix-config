{ config, pkgs, lib, ... }:

let name = "%NAME%";
    user = "%USER%";
    email = "%EMAIL%"; in
{

  zoxide = {
    enable = true;
    # enableFishIntegration = true;
    enableZshIntegration = true;
  };

  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    cdpath = [ "~/.local/share/src" ];
    plugins = [
      {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./config;
          file = "p10k.zsh";
      }
    ];
#    initExtraFirst = ''
     initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Ripgrep alias
      alias search=rg -p --glob '!node_modules/*'  $@

      export EDITOR="nvim"
      # # Emacs is my editor
      # export ALTERNATE_EDITOR=""
      # export EDITOR="emacsclient -t"
      # export VISUAL="emacsclient -c -a emacs"

      # e() {
      #     emacsclient -t "$@"
      # }

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # pnpm is a javascript package manager
      alias pn=pnpm
      alias px=pnpx

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'
      alias ll='ls -l --color=auto'
      alias la='ls -la --color=auto'

      # Yazi shell wrapper
      function y() {
	      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	      yazi "$@" --cwd-file="$tmp"
	      IFS= read -r -d "" cwd < "$tmp"
	      [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	      rm -f -- "$tmp"
      }
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    settings = {
      # 必须建立 user 这一层级（对应 Git 配置中的 [user]）
      user = {
        name = name;   # 对应原 userName
        email = email;  # 对应原 userEmail
      };
      # 原来的 extraConfig 内容
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      commit = {
        gpgsign = false;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
    };

    lfs = {
      enable = true;
    };
  };


  ssh = {
    enable = true;
    enableDefaultConfig = false; 
    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Users/${user}/.ssh/config_external"
      )
    ];
    matchBlocks = {
      "*" = {
        # 对所有主机生效
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        identitiesOnly = true;
        identityFile = [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
            "/home/${user}/.ssh/id_github"
          )
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
            "/Users/${user}/.ssh/id_ed25519"
          )
        ];
      };
    };
  };

  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
           set -g @tmux_power_theme 'gold'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    terminal = "screen-256color";
    prefix = "C-x";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Remove Vim mode delays
      set -g focus-events on

      # Enable full mouse support
      set -g mouse on

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Unbind default keys
      unbind C-b
      unbind '"'
      unbind %

      # Split panes, vertical or horizontal
      bind-key x split-window -v
      bind-key v split-window -h

      # Move around panes with vim-like bindings (h,j,k,l)
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # Smart pane switching with awareness of Vim splits.
      # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
      '';
    };

    # terminal file manager
    # https://mynixos.com/home-manager/options/programs.yazi
    # https://github.com/jacopone/nixos-config/blob/master/docs/tools/yazi-file-associations.md
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      # for yazi.toml
      settings = {
        mgr = {
          ratio            = [1 3 2];
          sort_by          = "mtime";   
          sort_dir_first   = true;
          show_hidden      = false;
          scrolloff        = 5;                # 光标上下预留行数
        };
        preview = {
          max_size        = 10 * 1024 * 1024;  # 10 MB 以下才预览
          wrap            = "no";
          image_delay     = 30;                # 30 ms 内完成缩略图
          ueberzug_scale  = 1.0;
        };
        opener = {
          # Markdown files - direct glow usage (no nested terminal)
          markdown = [
            { run = "glow -p \"$@\""; desc = "View with Glow (pager)"; block = true; }
            { run = "glow \"$@\""; desc = "View with Glow"; block = true; }
            { run = "hx \"$@\""; desc = "Edit with Helix"; block = true; }
          ];
          edit = [
            { run = "nvim \"$@\""; desc = "nvim"; block = true; }
            { run = "code \"$@\""; desc = "vscode"; orphan = true; }
          ];
        };
        plugin = {
          # prepend_preloaders = [
          #   { name = "*.csv"; run = "rich-preview"; }
          #   { name = "*.md"; run = "rich-preview"; }
          #   { name = "*.markdown"; run = "rich-preview"; }
          #   { name = "*.rst"; run = "rich-preview"; }
          #   { name = "*.ipynb"; run = "rich-preview"; }
          #   { name = "*.json"; run = "rich-preview"; }
          # # # # Office Documents
          # # #           { mime = "application/openxmlformats-officedocument.*"; run = "office"; }
          # # #           { mime = "application/oasis.opendocument.*"; run = "office"; }
          # # #           { mime = "application/ms-*"; run = "office"; }
          # # #           { mime = "application/msword"; run = "office"; }
          # # #           { name = "*.docx"; run = "office"; }
          # ];
          # #
          # #           prepend_previewers = [
          # # # Office Documents
          # #           { mime = "application/openxmlformats-officedocument.*"; run = "office"; }
          # #           { mime = "application/oasis.opendocument.*"; run = "office"; }
          # #           { mime = "application/ms-*"; run = "office"; }
          # #           { mime = "application/msword"; run = "office"; }
          # #           { name = "*.docx"; run = "office"; }
          # #           ];
        }; # plugin
        # open = {
        #   rules = [
        #     # Markdown files
        #     { name = "*.md"; use = "markdown"; }
        #     { name = "*.markdown"; use = "markdown"; }
        #     # Images
        #     { name = "*.jpg"; use = "image"; }
        #     { name = "*.jpeg"; use = "image"; }
        #     { name = "*.png"; use = "image"; }
        #     { name = "*.gif"; use = "image"; }
        #     { name = "*.bmp"; use = "image"; }
        #     { name = "*.svg"; use = "image"; }
        #     { name = "*.webp"; use = "image"; }
        #     # PDFs
        #     { name = "*.pdf"; use = "pdf"; }
        #     # CSV files
        #     { name = "*.csv"; use = "csv"; }
        #     # Office documents  
        #     { name = "*.doc"; use = "office"; }
        #     { name = "*.docx"; use = "office"; }
        #     { name = "*.xls"; use = "office"; }
        #     { name = "*.xlsx"; use = "office"; }
        #     { name = "*.ppt"; use = "office"; }
        #     { name = "*.pptx"; use = "office"; }
        #     { name = "*.odt"; use = "office"; }
        #     { name = "*.ods"; use = "office"; }
        #     { name = "*.odp"; use = "office"; }
        #
        #     # Text and code files - all open with Helix by default
        #     { name = "*.txt"; use = "edit"; }
        #     { name = "*.py"; use = "edit"; }
        #     { name = "*.js"; use = "edit"; }
        #     { name = "*.ts"; use = "edit"; }
        #     { name = "*.tsx"; use = "edit"; }
        #     { name = "*.jsx"; use = "edit"; }
        #     { name = "*.rs"; use = "edit"; }
        #     { name = "*.go"; use = "edit"; }
        #     { name = "*.c"; use = "edit"; }
        #     { name = "*.cpp"; use = "edit"; }
        #     { name = "*.cc"; use = "edit"; }
        #     { name = "*.cxx"; use = "edit"; }
        #     { name = "*.h"; use = "edit"; }
        #     { name = "*.hpp"; use = "edit"; }
        #     { name = "*.hxx"; use = "edit"; }
        #     { name = "*.css"; use = "edit"; }
        #     { name = "*.scss"; use = "edit"; }
        #     { name = "*.sass"; use = "edit"; }
        #     { name = "*.html"; use = "edit"; }
        #     { name = "*.htm"; use = "edit"; }
        #     { name = "*.xml"; use = "edit"; }
        #     { name = "*.yaml"; use = "edit"; }
        #     { name = "*.yml"; use = "edit"; }
        #     { name = "*.toml"; use = "edit"; }
        #     { name = "*.json"; use = "edit"; }
        #     { name = "*.jsonc"; use = "edit"; }
        #     { name = "*.json5"; use = "edit"; }
        #     { name = "*.ini"; use = "edit"; }
        #     { name = "*.conf"; use = "edit"; }
        #     { name = "*.cfg"; use = "edit"; }
        #     { name = "*.nix"; use = "edit"; }
        #     { name = "*.sh"; use = "edit"; }
        #     { name = "*.bash"; use = "edit"; }
        #     { name = "*.zsh"; use = "edit"; }
        #     { name = "*.fish"; use = "edit"; }
        #     { name = "*.vim"; use = "edit"; }
        #     { name = "*.lua"; use = "edit"; }
        #     { name = "*.rb"; use = "edit"; }
        #     { name = "*.php"; use = "edit"; }
        #     { name = "*.java"; use = "edit"; }
        #     { name = "*.kt"; use = "edit"; }
        #     { name = "*.swift"; use = "edit"; }
        #     { name = "*.dart"; use = "edit"; }
        #     { name = "*.sql"; use = "edit"; }
        #     { name = "*.dockerfile"; use = "edit"; }
        #     { name = "Dockerfile*"; use = "edit"; }
        #     { name = "*.env"; use = "edit"; }
        #     { name = "*.gitignore"; use = "edit"; }
        #     { name = "*.gitconfig"; use = "edit"; }
        #   ];
        # }; # open
      };
      # # for keymap.toml
      # keymap = {
      #   # for compress.yazi
      #   prepend_keymap = [
      #     {on = ["C" "A"]; run = "compress"; desc = "Archve selected files with compress.yazi plugin";}
      #   ];
      # };
      # https://github.com/sxyazi/yazi/discussions/1276
      #       plugins = {
      # # https://github.com/macydnah/office.yazi?tab=readme-ov-file
      #         # office = pkgs.fetchFromGitHub {
      #         #   owner = "macydnah";
      #         #   repo = "office.yazi";
      #         #   rev = "main";
      # # sha256 = lib.fakeSha256; 
      #           # sha256 = "sha256-ORcexu1f7hb7G4IyzQIfGlCkH3OWlk4w5FtZrbXkR40=";
      #         };
      # };
      plugins = {
        # https://github.com/KKV9/compress.yazi
        # https://github.com/boydaihungst/compress.yazi
        compress = pkgs.fetchFromGitHub {
          owner = "boydaihungst";
          repo = "compress.yazi";
          rev = "main";
        # sha256 = lib.fakeSha256;  # get real sha256
        sha256 = "sha256-EZVUftvEfyGIoBW/O81PeffDg4BhgsGlwfZL1RF85UA=";
      }; # plugins.compress

      #rich-preview = pkgs.yaziPlugins.rich-preview;
    }; 
  }; # yazi

  # vscode = {
  #   enable = true;
  #   profiles = {
  #     default = {
  #       extensions = with pkgs.vscode-extensions; [
  #         dracula-theme.theme-dracula
  #         vscodevim.vim
  #         yzhang.markdown-all-in-one
  #       ];
  #     };
  #   };
  # }; # vscode
}
