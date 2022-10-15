{
  outputs = { self, nixpkgs } : {
    nixosModule = import ./nix/service.nix;
  };
}
