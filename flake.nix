{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager, nix-doom-emacs, emacs-overlay }: {
    homeConfigurations = {
      "worldofgeese@E0709" = homeManager.lib.homeManagerConfiguration {
        configuration = {pkgs, ...}: {
          imports = [ nix-doom-emacs.hmModule ];
          programs.doom-emacs = {
            enable = true;
            doomPrivateDir = /home/worldofgeese/doom.d;
            emacsPackage = pkgs.emacsPgtkGcc;
	    };
          programs.home-manager.enable = true;
	};

        extraSpecialArgs = {
          inherit nix-doom-emacs;
        };

	pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ emacs-overlay.overlay ];
        };


        system = "x86_64-linux";
        homeDirectory = "/home/worldofgeese";
        username = "worldofgeese";
        stateVersion = "21.11";
      };
    };
  };
}
