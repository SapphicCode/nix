{pkgs, ...}: {
  # Hardware > Printing
  services.avahi.enable = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
    epson-escpr2
  ];
}
