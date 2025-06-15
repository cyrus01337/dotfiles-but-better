#!/usr/bin/env fish
if command -q ffmpeg
    function ffmpeg-concat --wraps ffmpeg
        set input $argv[1]
        set output $argv[2]

        ffmpeg -f concat -safe 0 -i $input -c copy $output
    end

    function ffmpeg-to-mp4 --wraps ffmpeg
        set input $argv[1]
        set output $argv[2]

        ffmpeg -i $input -codec copy $output
    end

    function ffmpeg-generate-inputs
        set count $argv[1]

        for number in (seq 1 $count)
            echo "file '$PWD/$number.mkv'" >> inputs.txt
        end
    end
end

return 0
