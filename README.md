<<<<<<< HEAD
# Building
**1. Clone this repository:**
```bash
git clone https://github.com/spark567/watson.git
```

**2. Build the config on your server:**
```bash
nixos-rebuild switch --flake .#hostname --target-host root@host --build-host root@host --use-remote-sudo
```
  -  By default, `hostname` is set to `watson`. This can be changed in the `flake.nix` and `network.nix` files, though the `network.nix` entry is the network hostname and does not impact build targetting.

  - If you cloned this repository directly to your server **(not recommended)**, move or copy the files to **`/etc/nixos`** and run this instead:
    ```bash
    nixos-rebuild switch --flake /etc/nixos
    ```
=======
# watson
>>>>>>> 4d5c548 (Disabled nftables and made a change to the docker config)
