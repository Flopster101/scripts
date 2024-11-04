## How to use?

Set a workspace with the **$WP** env var, this could be the directory above your kernel directory.

Call the ckbuild script from inside the kernel directory. I recommend putting the script in your **$WP** dir.

<ins>**Example**</ins>:

`bash ../ckbuild.sh`

If you want to use the Telegram channel feature, provide these two files in your workspace:

* **bot_token**: token for your Telegram bot.
* **chat_ci**: ID of your channel.

and see below how to call a build with the Telegram feature.

## Parameters

They can be passed one after another without any spaces in between.

- **c** = Will produce a clean build by cleaning the output directory first.
- **k** = Will produce a build using the KSU-specific defconfig.
- **m** = Will call `make menuconfig` right before the build.
- **t** = Will upload the build to a Telegram channel. Needs the files above to be present.
- **o** = Will upload the build to file sharing site oshi.at.
- **R** = Will add the "Release" label to the build.
- **d** = Will label the build as for dynamic partitions where necessary.

<ins>**Example**</ins>:

 `bash ../ckbuild.sh tkc`

Will make a clean build with KSU and upload it to the Telegram channel.

## Picking a toolchain

Currently, this is set inside the script. If you want to change the toolchain, see this section of the script:

`
CLANG_TYPE=aosp
`

Current valid values for this variable are: aosp, proton, sdclang, lolz.

The default AOSP Clang toolchain should be fine most of the time.