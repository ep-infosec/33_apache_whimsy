#
# Monitor status of board minutes
#

=begin
The code checks the collate_minutes log file and the file
    www/board/minutes/index.html

Possible status level responses:
Danger - log contains an Exception message
Info - Log contains some other content
Success - Log is present, but empty
Fatal - log or index are not present/readable (status level is generated by caller)

=end

require 'time'

def Monitor.board_minutes(previous_status)
  index = File.expand_path('../../www/board/minutes/index.html')
  log = File.read(File.expand_path('../../www/logs/collate_minutes'))

  if log =~ /\*\*\* (Exception.*) \*\*\*/
    {
      level: 'danger',
      data: $1,
      href: '../logs/collate_minutes'
    }
  elsif log.length > 0
    {
      level: 'info',
      data: "Last updated: #{File.mtime(index)}",
      href: '../logs/collate_minutes'
    }
  else
    {mtime: File.mtime(index).gmtime.iso8601, level: 'success'} # to agree with normalise
  end
end

# for debugging purposes
if __FILE__ == $0
  require_relative 'unit_test'
  runtest('board_minutes') # must agree with method name above
end