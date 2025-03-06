{
  hostname,
  config,
  pkgs,
  host,
  ...
}: let
  sharedVariables = import ../../shared_variables.nix;
in {
  home.packages = with pkgs; [
    direnv
    lsd
    thefuck
    tldr
  ];

  programs.command-not-found.enable = true;

  # setup direnvrc so that when we cd into a dir then we load some vars
  home.file.".direnvrc".text = ''
      use_nix() {
        local shell_file="shell.nix"
        if [[ -f "$shell_file" ]]; then
          direnv load <(nix-shell --pure --command "direnv dump")
        else
          log_status "No shell.nix found."
        fi
      }

      use_python_venv() {
        if [ -d ".venv" ]; then
          layout python-venv .venv
        elif [ -f "Pipfile" ]; then
          layout python-pipenv
        elif [ -f "requirements.txt" ]; then
          layout python
        fi
      }

      # Combine use_nix and use_python_venv
      load_env() {
        use_nix
        use_python_venv
      }

      layout_nix_python() {
        load_env
      }

      load_env

    HISTFILE="$HOME/.zsh_history"
    HISTSIZE=1000000000
    SAVEHIST=1000000000
    setopt EXTENDED_HISTORY
  '';

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 1000000000;
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "fzf" "colored-man-pages"];
    };

    initExtraFirst = ''
      DISABLE_MAGIC_FUNCTIONS=true
      export "MICRO_TRUECOLOR=1"
    '';

    initExtra = ''


      function note(){
        take-note "$*"
        }
      function notec(){
        take-note -c "$*"
        }
      eval $(thefuck --alias) # gets fuck command running

      # export TODOIST_API_KEY="$(pass Todoist/API)"
      alias notetaker="neovim ~/notes/"

      __conda_setup="$('/home/matth/.conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/home/matth/.conda/etc/profile.d/conda.sh" ]; then
              . "/home/matth/.conda/etc/profile.d/conda.sh"
          else
              export PATH="/home/matth/.conda/bin:$PATH"
          fi
      fi
      unset __conda_setup


    '';

    shellAliases = {
      record = "wf-recorder --audio=alsa_output.pci-0000_08_00.6.analog-stereo.monitor -f $HOME/Videos/$(date +'%Y%m%d%H%M%S_1.mp4')";

      # Utils
      c = "clear";
      cd = "z";
      tt = "gtrash put";
      cat = "bat";
      code = "codium";
      py = "python";
      icat = "kitten icat";
      dsize = "du -hs";
      findw = "grep -rl";
      pdf = "tdf";
      open = "xdg-open";
      ls = "lsd";
      lst = "lsd --tree --depth";

      n = "nvim";

      word-count = "wl-paste | wc";
      paste-image = "wl-paste -t image/png >";

      # Nixos
      ns = "nix-shell --run zsh";
      nix-shell = "nix-shell --run zsh";

      notetaker = "kitty --title notetaker --name notetaker --start-as=fullscreen";

      # `git add .` is added because if there is a file not staged then nixos-rebuild won't look for it
      rebuild = "pushd ${sharedVariables.rootDirectory} && git add --all . && sudo nixos-rebuild switch --flake ${sharedVariables.rootDirectory}.#${host} && popd";
      rebuildu = "pushd ${sharedVariables.rootDirectory} && cp ${sharedVariables.rootDirectory}flake.lock flake.$(date +%Y-%m-%d).lock && git add --all . && sudo nixos-rebuild switch --upgrade --flake ${sharedVariables.rootDirectory}.#${host} && popd";
      # testing = "echo \"sudo nixos-rebuild switch --flake ${sharedVariables.rootDirectory}.#${host}\"";
      # rebuild = "git add ${sharedVariables.rootDirectory} && sudo nixos-rebuild switch --flake ${sharedVariables.rootDirectory}#${host}";
      # rebuildu = "git add ${sharedVariables.rootDirectory} && sudo nixos-rebuild switch --upgrade --flake ${sharedVariables.rootDirectory}#${host}";
      nix-flake-update = "sudo nix flake update ${sharedVariables.rootDirectory}#";
      nix-clean = "sudo nix-collect-garbage && sudo nix-collect-garbage -d && sudo rm /nix/var/nix/gcroots/auto/* && nix-collect-garbage && nix-collect-garbage -d";

      cum = "echo TEST";
      # Git
      ga = "git add";
      gaa = "git add --all";
      gs = "git status";
      gb = "git branch";
      gm = "git merge";
      gpl = "git pull";
      gplo = "git pull origin";
      gps = "git push";
      gpst = "git push --follow-tags";
      gpso = "git push origin";
      gc = "git commit";
      gcm = "git commit -m";
      gcma = "git add --all && git commit -m";
      gtag = "git tag -ma";
      gch = "git checkout";
      gchb = "git checkout -b";
      gcoe = "git config user.email";
      gcon = "git config user.name";
      glazy = "git add --all ; git commit -am \"This is an automated commit by $USER because they were too lazy\" ; git pull && git push";

      # python
      piv = "python -m venv .venv";
      psv = "source .venv/bin/activate";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
