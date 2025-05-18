{
    disko.devices = {
        disk.main = {
            content = {
                partitions = {
                    ESP = {
                        content = {
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = ["umask=0077"];
                            type = "filesystem";
                        };
                        size = "1G";
                        type = "EF00";
                    };
                    plainSwap = {
                        content = {
                            discardPolicy = "both";
                            resumeDevice = true;
                            type = "swap";
                        };
                        size = "12G";
                    };
                    root = {
                        content = {
                            format = "ext4";
                            mountpoint = "/";
                            type = "filesystem";
                        };
                        size = "100%";
                    };
                };
                type = "gpt";
            };
            device = "/dev/sda";
            type = "disk";
        };
    };
}
