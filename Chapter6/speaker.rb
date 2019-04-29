class Speaker
    def say(*word)
        puts word
    end
end

speaker = Speaker.new
speaker.say("Good morning")
speaker.say("Hello", "How are you ?", "Good-by")
