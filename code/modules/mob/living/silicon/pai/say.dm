/mob/living/silicon/pai/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	if(silence_time)
		to_chat(src, "<font color=green>Communication circuits remain uninitialized.</font>")
		return
	return ..()
