# bain - the battery indicator

![Arch Example](example/Arch.png)
<sup>\*green: discharge, yellow: charge, red: battery percentage < 30%</sup>

## How to use?

* Make sure you have these programs installed on your machine: [git](https://git-scm.com/), [imagemagick](https://imagemagick.org), and [feh](https://feh.finalrewind.org).

* Clone the repository into ~/.bain

```bash
git clone https://github.com/amirashabani/bain ~/.bain
```

* Make it executable

```bash
chmod +x ~/.bain/bain
```

* Copy it to `/usr/local/bin`, so that the command is recognized by your terminal. Make sure to run it with `sudo`.
```bash
sudo cp ~/.bain/bain /usr/local/bin
```

* Run the script from your startup file (e.g. `.xinitrc`). Make sure to use `&` at the end of the command as it is a blocking script.
```bash
bain arch &
```

* Restart your X session (log out and log back in).
```bash
pkill X
```
