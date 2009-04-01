require 'rubygems' if defined? Gem
 
libdir = File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)
 
require 'test/unit'
require 'shoulda'

require 'rudy'


puts Rudy.make_banner("THIS IS RUBY #{RUBY_VERSION}")

# +should_stop+ should the test be stopped?
# +str+ The message to print when +should_stop+ is true
def stop_test(should_stop, str)
  return unless should_stop
  str ||= "Test stopped for unknown reason"
  abort str.color(:red).bright
end

def skip(msg)
  puts "%s (%s)" % ["SKIP".color(:blue).bright, msg]
  :skip # this doesn't do anything, but I would like it to!
end

def xshould(*args, &ignore)
  puts %q(Skipping test: "%s") % args.first.color(:blue).bright
end
def xcontext(*args, &ignore)
  puts %q(Skipping context: "%s") % args.first.color(:blue).bright
end