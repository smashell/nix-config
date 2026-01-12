_:

[
  # Development Tools
  # "homebrew/cask/docker"
  # "visual-studio-code"

  # # Communication Tools
  # "discord"
  # "notion"
  # "slack"
  # "telegram"
  # "zoom"
  # "feishu"

  # Utility Tools
  # "syncthing"
  "input-source-pro"


  # # Entertainment Tools
  # "vlc"

  # Productivity Tools
  "raycast"

  # # Browsers
  # "google-chrome"

  ## IM & audio & remote desktop & meeting
  #"telegram"
  #"discord"
  "wechat"
  # "baidunetdisk"
  "dingtalk"

  #"anki"
  #"iina" # video player
  #"raycast" # (HotKey: alt/option + space)search, caculate and run scripts(with many plugins)
  #"stats" # beautiful system monitor
  #"eudic" # 欧路词典

  ## Development
  #"insomnia" # REST client
  #"wireshark" # network analyzer
  
  ##### tap then install
  # brew tap farion1231/ccswitch #   # https://github.com/farion1231/homebrew-ccswitch
  # brew install --cask cc-switch
  # step: 
  #     1. in flake.nix: add  ccswitch github in input 
  #     2. in flake.nix: tap it in  darwin.lib.darwinSystem {
  #     3.  add cask here as follows
  {name="cc-switch"; greedy = true;}
  "antigravity"

  # Office
  "picgo"
  # "libreoffice" # for office.yazi plugin
  "microsoft-edge"
  "wpsoffice-cn"
  "tencent-meeting"
  "xmind"
  "pronotes"

  # Utilities
  "paper"
  "jordanbaird-ice"
  # "sunloginclient"
  "orbstack"
  "tencent-lemon"
  #"deskflow" # share mouse and keyboard
  # "daisydisk"
  "pixpin"
  # "logi-options+" # for logi mouse
  "warp"
]
