{...}: {
  nix.distributedBuilds = true;
  nix.settings = {
    max-jobs = 0;
    builders-use-substitutes = true;
  };
  nix.buildMachines = [
    {
      hostName = "blahaj.sapphiccode.net";
      systems = ["x86_64-linux"];
      sshUser = "remote-build";
      sshKey = "/root/.ssh/id_ed25519";
      maxJobs = 12;
    }
  ];
}
