### The original, discontinued project and README.md can be found [here](https://github.com/abstractfoundry/lumicube-daemon/blob/main/README.md)

---

**Update 2024-03-05**  
* Build v2 runs without virtual microphone errors.
* Will add build and install instructions. Until then, please find my notes below.


#### What I've done so far
- [x] Extracted and added `build_redis.sh` from sources, added aarch64 (arm64). 
- [x] Bump Daemon version from 1.9-SNAPSHOT to 2.0 in `pom.xml`
- [x] Updated a frew dependencies in `pom.xml`
- [x] Added compiled redis for aarch64 in `src/main/resources/META-INF/resources/redis/aarch64`. 
- [x] Added compiled AppImages for `arm`, `aarch64` and `x64`. 
- [x] Added `requirements.txt` for the python environment. 
- [x] `install.py`: removed calls to absent domain abstractfoundry.com.
- [x] Added support for non-wifi interfaces for fetching the ip address.


#### Notes
* Daemon and redis only seem to compile well on x86_64
* `pipewire-pulse` provides a **pulseaudio-compatible daemon** in deb12
* `pulseaudio-utils` might be needed in default installs for `pactl`
* if run in a shell with `sudo`, `su` or as `root` you'll get audio/connection errors. 
  * I guess this is also the reason for the systemd-service in userland
* python requirements need to be installed with `--break-system-packages` in deb12. :(
* a python virtualenv could be used but would have to be sourced through a users .profile . This should not be done for a regular user as it can break system utilities. You'd have to create an extra user for running the daemon.
* `werkzeug` and the rest of the python libraries in `requirements.txt` need to be pinned to these versions. 
* my build-commands for the daemon (issued from the root of this repo):
  * `rm Daemon-2.0*` 
  * `rm -R target/`
  * `echo "--- cleanup done ---"`
  * `mvn clean`
  * `mvn compile`
  * `mvn package`
  * `cp target/Daemon-2.0.zip ./`
  * `./build.sh Daemon-2.0`

#### ToDo
- [ ] build a docker container, then don't care about `pip install --break-system-packages`
- [ ] publish the dockerimage.
- [ ] writeup all changes, do more testing. 
- [ ] `install.py`: do more cleanup
- [ ] remove updatecheck calling out to `abstractfoundry.com`

#### Dream of..
* a daemon based on python. More documentation would help.