lsb_release -cd  ; getconf LONG_BIT ; hostname ; hostname -I
sudo apt install xfce4 xfce4-goodies tightvncserver novnc websockify python3-numpy build-essential net-tools curl git software-properties-common -y
vncserver
vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
nano ~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
chmod +x ~/.vnc/xstartup
vncserver
vncpasswd  [ StrongPassword ]

cd /etc/ssl ; openssl req -x509 -nodes -newkey rsa:2048 -keyout novnc.pem -out novnc.pem -days 365
chmod 644 novnc.pem
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 6080 localhost:5901
https://192.168.1.50:6080/vnc.html
------------------
1: wget -O bios64.bin "https://github.com/BlankOn/ovmf-blobs..."
2 : wget -O win.iso "https://pixeldrain.com/u/9Bq1Z2NF"
3 : wget -O ngrok.tgz "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
4 : tar -xf ngrok.tgz
5 : rm -rf ngrok.tgz
6 : ./ngrok config add-authtoken 2coWZi6lp6Yvn7QmBhG8Z7Bqc32_2NMWmXTdrGrUxPncJF8sr
7 : ./ngrok tcp 5900
8 : sudo apt update
9 : sudo apt install qemu-kvm -y
10 : qemu-img create -f raw win.img
11 : qemu-img create -f raw win.img 32G
12 :sudo qemu-system-x86_64 -m 4G -cpu host -boot order=c -drive file=win.iso,media=cdrom -drive file=disk.qcow2,format=raw -device usb-ehci,id=usb,bus=pci.0,addr=0x4 -device usb-tablet -vnc :0 -smp cores=4 -device rtl8139,netdev=n0 -netdev user,id=n0 -vga qxl -bios bios64.bin
-------------------
git clone https://github.com/foxytouxxx/freeroot.git
cd freeroot
bash root.sh
apt update
apt install qemu-kvm -y wget -y
wget -O win.iso https://st7.ranoz.gg/pzkKzkEo-AtomOS11%2025h2%20Lite%20006.iso
qemu-img create -f qcow2 disk.qcow2 50G
wget -O "disk.qcow2" https://bit.ly/4qK9pvA
-----------------
qemu-system-x86_64 -M q35 -usb -device qemu-xhci -device usb-tablet -device usb-kbd -cpu qemu64,+sse,+sse2,+sse4.1,+sse4.2,+pae,hv-relaxed -smp sockets=1,cores=2,threads=1 -m 4082M -drive file=disk.qcow2,aio=threads,cache=writeback,if=none,id=hda -device ahci,id=hdaahci -device ide-hd,drive=hda,bus=hdaahci.0 -drive file=win.iso,media=cdrom,if=none,id=cdrom0 -device ide-cd,drive=cdrom0,bus=ide.0 -vga qxl -device ich9-intel-hda -device hda-duplex -device e1000e,netdev=n0 -netdev user,id=n0 -accel tcg,thread=multi -boot d,menu=on -device intel-iommu -vnc :0

qemu-system-x86_64 -smp sockets=1,cores=2,threads=1 -hda disk.qcow2 -m 4096 -vga qxl -display vnc=:0

---------------
curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | sudo tee /etc/apt/sources.list.d/playit-cloud.list
sudo apt update
sudo apt install playit
docker run --rm -d --network host --privileged --name nomachine-xfce4 -e PASSWORD=123456 -e USER=user --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:wine
--------------
{ pkgs, ... }: {
  channel = "stable-24.11";

  packages = [
    pkgs.qemu
    pkgs.htop
    pkgs.cloudflared
    pkgs.coreutils
    pkgs.gnugrep
    pkgs.wget
    pkgs.git
    pkgs.python3
  ];

  idx.workspace.onStart = {
    qemu = ''
      set -e

      # =========================
      # One-time cleanup
      # =========================
      if [ ! -f /home/user/.cleanup_done ]; then
        rm -rf /home/user/.gradle/* /home/user/.emu/* || true
        find /home/user -mindepth 1 -maxdepth 1 \
          ! -name 'idx-windows-gui' \
          ! -name '.cleanup_done' \
          ! -name '.*' \
          -exec rm -rf {} + || true
        touch /home/user/.cleanup_done
      fi

      # =========================
      # Paths
      # =========================

      SKIP_QCOW2_DOWNLOAD=0

      VM_DIR="$HOME/qemu"
      RAW_DISK="$VM_DIR/windows.qcow2"
      WIN_ISO="$VM_DIR/automic11.iso"
      VIRTIO_ISO="$VM_DIR/virtio-win.iso"
      NOVNC_DIR="$HOME/noVNC"

     
     OVMF_DIR="$HOME/qemu/ovmf"
     OVMF_CODE="$OVMF_DIR/OVMF_CODE.fd"
     OVMF_VARS="$OVMF_DIR/OVMF_VARS.fd"

     mkdir -p "$OVMF_DIR"

     # =========================
     # Download OVMF firmware if missing
     # =========================
     if [ ! -f "$OVMF_CODE" ]; then
        echo "Downloading OVMF_CODE.fd..."
        wget -O "$OVMF_CODE" \
          https://qemu.weilnetz.de/test/ovmf/usr/share/OVMF/OVMF_CODE.fd
        else
          echo "OVMF_CODE.fd already exists, skipping download."
     fi

     if [ ! -f "$OVMF_VARS" ]; then
       echo "Downloading OVMF_VARS.fd..."
       wget -O "$OVMF_VARS" \
         https://qemu.weilnetz.de/test/ovmf/usr/share/OVMF/OVMF_VARS.fd
     else
       echo "OVMF_VARS.fd already exists, skipping download."
     fi

      mkdir -p "$VM_DIR"

      if [ "$SKIP_QCOW2_DOWNLOAD" -ne 1 ]; then
  if [ ! -f "$RAW_DISK" ]; then
    echo "Downloading QCOW2 disk..."
    wget -O "$RAW_DISK" https://bit.ly/45hceMn
  else
    echo "QCOW2 disk already exists, skipping download."
  fi
else
  echo "SKIP_QCOW2_DOWNLOAD=1 → QCOW2 logic skipped."
fi
      

      # =========================
      # Download Windows ISO if missing
      # =========================
      if [ ! -f "$WIN_ISO" ]; then
        echo "Downloading Windows ISO..."
        wget -O "$WIN_ISO" \
          https://computernewb.com/isos/windows/en-us_windows_10_22h2_x64.iso
      else
        echo "Windows ISO already exists, skipping download."
      fi

      # =========================
      # Download VirtIO drivers ISO if missing
      # =========================
      if [ ! -f "$VIRTIO_ISO" ]; then
        echo "Downloading VirtIO drivers ISO..."
        wget -O "$VIRTIO_ISO" \
          https://github.com/kmille36/idx-windows-gui/releases/download/1.0/virtio-win-0.1.271.iso
      else
        echo "VirtIO ISO already exists, skipping download."
      fi

      # =========================
      # Clone noVNC if missing
      # =========================
      if [ ! -d "$NOVNC_DIR/.git" ]; then
        echo "Cloning noVNC..."
        mkdir -p "$NOVNC_DIR"
        git clone https://github.com/novnc/noVNC.git "$NOVNC_DIR"
      else
        echo "noVNC already exists, skipping clone."
      fi

      # =========================
      # Create QCOW2 disk if missing
      # =========================
      if [ ! -f "$RAW_DISK" ]; then
        echo "Creating QCOW2 disk..."
        qemu-img create -f qcow2 windows.qcow2 60G
      else
        echo "QCOW2 disk already exists, skipping creation."
      fi

      # =========================
      # Start QEMU (KVM + VirtIO + UEFI)
      # =========================
      echo "Starting QEMU..."
      nohup qemu-system-x86_64 \
  -enable-kvm \
  -cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
  -smp 8,cores=8 \
  -M q35,usb=on \
  -device usb-tablet \
  -m 28672 \
  -device virtio-balloon-pci \
  -vga virtio \
  -net nic,netdev=n0,model=virtio-net-pci \
  -netdev user,id=n0,hostfwd=tcp::3389-:3389 \
  -boot c \
  -device virtio-serial-pci \
  -device virtio-rng-pci \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
  -drive if=pflash,format=raw,file="$OVMF_VARS" \
  -drive file=windows.qcow2,format=qcow2,if=virtio \
  -cdrom "$WIN_ISO" \
  -drive file="$VIRTIO_ISO",media=cdrom,if=ide \
  -uuid e47ddb84-fb4d-46f9-b531-14bb15156336 \
  -vnc :0 \
  -display none \
  > /tmp/qemu.log 2>&1 &


      # =========================
      # Start noVNC on port 8888
      # =========================
      echo "Starting noVNC..."
      nohup "$NOVNC_DIR/utils/novnc_proxy" \
        --vnc 127.0.0.1:5900 \
        --listen 8888 \
        > /tmp/novnc.log 2>&1 &

      # =========================
      # Start Cloudflared tunnel
      # =========================
      echo "Starting Cloudflared tunnel..."
      nohup cloudflared tunnel \
        --no-autoupdate \
        --url http://localhost:8888 \
        > /tmp/cloudflared.log 2>&1 &

      sleep 10

      if grep -q "trycloudflare.com" /tmp/cloudflared.log; then
        URL=$(grep -o "https://[a-z0-9.-]*trycloudflare.com" /tmp/cloudflared.log | head -n1)
        echo "========================================="
        echo " 🌍 Windows 11 QEMU + noVNC ready:"
        echo "     $URL/vnc.html"
        echo "     $URL/vnc.html" > /home/user/idx-windows-gui/noVNC-URL.txt
        echo "========================================="
      else
        echo "❌ Cloudflared tunnel failed"
      fi

      # =========================
      # Keep workspace alive
      # =========================
      elapsed=0
      while true; do
        echo "Time elapsed: $elapsed min"
        ((elapsed++))
        sleep 60
      done
    '';
  };

  idx.previews = {
    enable = true;
    previews = {
      qemu = {
        manager = "web";
        command = [
          "bash" "-lc"
          "echo 'noVNC running on port 8888'"
        ];
      };
      terminal = {
        manager = "web";
        command = [ "bash" ];
      };
    };
  };
}
