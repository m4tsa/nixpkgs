{ pkgs, stdenv, system, dataDir ? "/opt/zigbee2mqtt/data" }:
let
  package = (import ./node.nix { inherit pkgs system; }).package;
in
package.override rec {
  version = "1.14.1";
  reconstructLock = true;

  postInstall = ''
    sed -i '1s;^;#!/usr/bin/env node\n;' $out/lib/node_modules/zigbee2mqtt/index.js
    chmod +x $out/lib/node_modules/zigbee2mqtt/index.js
    mkdir $out/bin
    ln -s $out/lib/node_modules/zigbee2mqtt/index.js $out/bin/zigbee2mqtt

    rm -rf $out/lib/node_modules/zigbee2mqtt/data
    ln -s ${dataDir} $out/lib/node_modules/zigbee2mqtt/data
  '';

  src = pkgs.fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    rev = version;
    sha256 = "1g1j634474m6arr3qyvf2bzmjh4qs02rhnfh0dlm8qz8rh3xj2rk";
  };

  meta = with pkgs.stdenv.lib; {
    description = "Zigbee to MQTT bridge using zigbee-shepherd";
    license = licenses.gpl3;
    homepage = https://github.com/Koenkk/zigbee2mqtt;
    maintainers = with maintainers; [ sweber ];
    platforms = platforms.linux;
  };
}
