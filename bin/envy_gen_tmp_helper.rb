# this is the proper method
# however we judge envy to be very low risk
# in terms of clashes, so just do the silly thing
# require 'securerandom'
# fname = SecureRandom.uuid

# silly thing
fname = "envy-" + Time.now.to_i.to_s(16) + '-' + rand(1_000_000).to_s(16) + ".bat"
# yes, simply always add the .bat extension. Linux doesn't care anyway

# the ultimate multi-platform temp dir finder
# again, the proper way would be to require 'rbconfig'
# find the os, and use OS-specific ways, but we're trying to be fast here

def temp_dirs(&block)
  yield 'C:/windows/system32'
  yield '/tmp' # most unixes
  yield ENV['TMP'] # good guess for windows
  yield '/var/tmp'
  yield ENV['TEMP']
  yield ENV['TEMPDIR']
  yield Dir.home
  yield __dir__ # why not
  yield Dir.pwd # last resort
end

def existing_temp_dirs(&block)
  temp_dirs do |dir|
    yield dir if dir && File.exist?(dir)
  end
end

existing_temp_dirs do |dir|
  path = File.join(dir, fname)

  begin
    File.open(path, 'w') {}
    puts path
    exit 0
  rescue
    # just try the next entry
  end
end

STDERR.puts "ERROR: Could not create envy temp file"
# write something just so the rest can continue up to the point where this file needs to be written
puts 'error.bat'
exit 1
