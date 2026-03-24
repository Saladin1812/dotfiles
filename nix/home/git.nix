{
  config,
  pkgs,
  ...
}:
{
  enable = true;
  lfs.enable = true;
  signing.format = null;

  settings = {
    user.name = "Saladin";
    user.email = "dev@saladin.pro";
    pull = {
      rebase = true;
    };
    init = {
      defaultBranch = "main";
    };
  };
}
