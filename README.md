# Eyedle - Overlay for Eye Breaks

## Features

* **Customizable Timer**
* **Overlay**
* **Pre/Post Scripting**: Automate actions before and after the break notifications.

---

## Key Design Goals

**Eyedle** was built with efficiency in mind:

* Low Resource Usage
* Minimal Design
* Optimized Performance

> Keep these goals in mind for any future updates or changes.

---

## Screenshots

[screenshot 1](https://github.com/2qp/eyedle/raw/master/md/media/screenshot_ol_01.png)

---

## Installation

### Prerequisites

To run **Eyedle**, you’ll need the following:

* macOS 15 (Sequoia) or higher

### Installation Steps

```bash
# 

```

---

## Usage



### Scripting

**Eyedle** supports the following file extensions for automation scripts:

* `.scpt` (AppleScript)
* `.sh` (Shell Script)

**Script directories** for pre- and post-notification actions:

```bash
USER_PRE_NOTIFY_SCRIPTS_DIR="$HOME/documents/eyedle/pre"
USER_POST_NOTIFY_SCRIPTS_DIR="$HOME/documents/eyedle/post"
```

### Automation Phases

**Eyedle** provides two main automation phases: **PRE\_NOTIFY** and **POST\_NOTIFY**.

1. **PRE\_NOTIFY**:

   * **Purpose**: Executes before the notification is triggered.
   * **Functionality**: You can prevent the overlay from showing (e.g., with conditions), or prepare system states before the notification occurs.
   * **Script Directory**:
   
   > Place your **PRE\_NOTIFY** scripts in the following directory:

     ```bash
     $HOME/documents/eyedle/pre/
     ```

   **Example**: Preventing:

   ```bash
   echo "skip"  # Prevent notification/overlay
   ```

   In AppleScript:

   ```applescript
   return "skip"  # Skip notification/overlay
   ```

2. **POST\_NOTIFY**:

   * **Purpose**: Executes after the notification and right on break time starts.
   * **Functionality**: Perform post-notification actions, such as pausing music or adjusting system settings.
   * **Script Directory**:
   
   > Place your **POST\_NOTIFY** scripts in the following directory:

     ```bash
     $HOME/documents/eyedle/post/
     ```

   **Example**: Pausing music after a notification:

   **Shell Script**:

   ```bash
   # pause_music.sh
   osascript -e 'tell application "Music" to pause'
   ```

   **AppleScript**:

   ```applescript
   tell application "Music"
       if player state is playing then
           pause
       end if
   end tell
   ```
---

## Configuration

* Notify Duration
* Break Interval
* Break Duration

---

## Contributing

```bash
#
```

---

## License

This project is licensed under the [MIT License](LICENSE). See the LICENSE file for details.