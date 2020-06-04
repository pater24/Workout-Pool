require 'JSON'
require 'time'

class Fixnum
  def day
    self * (60 * 60 * 24) # seconds * minutes * hours
  end

  def ago
    Time.now - self
  end
end

file_location = ARGV[0]
chat_name     = ARGV[1]
start_time    = ARGV[2] ? Time.parse(ARGV[1]) : 7.day.ago
end_time      = ARGV[3] ? Time.parse(ARGV[2]) : Time.now

if file_location == nil
  raise 'Invalid file location'
end

if chat_name == nil
  raise 'Invalid chat name'
end

a = File.open(file_location)
hangouts = JSON.parse(a.read) ; 0
b = nil

hangouts["conversations"].each do |conversation|
  if conversation["conversation"]["conversation"]["name"] == chat_name
    b = conversation
  end
end ; 0

participants = {}
messages = {}

b["conversation"]["conversation"]["participant_data"].each do |participant|
  participants[participant["id"]["chat_id"]] = participant["fallback_name"]
  messages[participant["id"]["chat_id"]] = []
end ; 0

b["events"].each do |x|
  if messages[x["sender_id"]["chat_id"]]
    messages[x["sender_id"]["chat_id"]].push(x)
  end
end ; 0

messages.each do |person, messages|
  messages.sort! do |a, b|
    Time.at(a["timestamp"].to_f / 1000000) <=> Time.at(b["timestamp"].to_f / 1000000)
  end
end ; 0

workout_count = {}

messages.each do |person, messages|
  workout_count[person] = 0

  messages.each do |m|
    timestamp = Time.at(m["timestamp"].to_f / 1000000)

    # if timestamp > Time.parse('2017-01-07') && timestamp < Time.parse('2017-01-15')
    if timestamp > start_time && timestamp < end_time
      if m["chat_message"] && m["chat_message"]["message_content"] && m["chat_message"]["message_content"]["segment"]
        m["chat_message"]["message_content"]["segment"].each do |y|
          if y['text'] && (matchedString = y['text'].match(/(^|\s)(\d)\/\d/)) && matchedString[2].to_i > workout_count[person]
            workout_count[person] += 1
          end
        end
      end
    end
  end
end ; 0

participants.each do |id, name|
  puts "#{name}: #{workout_count[id]}"
end ; 0
