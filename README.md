## Description
A script written for Bash with the purpose to rename the files and add id3tags to the audio downloaded with youtube-dl.  
The artist and title is first based on the data that the video site provides and if not available the title of the video.
## Dependencies
* kid3-cli
* youtube-dl
## Usage
* Download audio files using youtube-dl:
> youtube-dl -x --audio-format mp3 --audio-quality 0 ADDRESS --abort-on-error --restrict-filenames -o './%(artist)s_-_%(track)s{{%(title)s}}_[%(id)s].%(ext)s' --output-na-placeholder '#NA#'

NOTE: **ADDRESS** needs to be changed to an actual address to a video or playlist.

* Put the script **rename.sh** in the same directory as the downloaded mp3 files.  
* Make the script executable.  
* Run the script.