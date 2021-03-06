
module Rudy
  module MetaData
    include Rudy::Huxtable
    
    def initialize(*args)
      a, s, r = @@global.accesskey, @@global.secretkey, @@global.region
      @sdb = Rudy::AWS::SDB.new(a, s, r)
      @rinst = Rudy::AWS::EC2::Instances.new(a, s, r)
      @rgrp = Rudy::AWS::EC2::Groups.new(a, s, r)
      @rkey = Rudy::AWS::EC2::KeyPairs.new(a, s, r)
      init(*args)
    end
    
    def init(*args)
    end
    
    # 20090224-1813-36
    def format_timestamp(dat)
      mon, day, hour, min, sec = [dat.mon, dat.day, dat.hour, dat.min, dat.sec].collect { |v| v.to_s.rjust(2, "0") }
      [dat.year, mon, day, Rudy::DELIM, hour, min, Rudy::DELIM, sec].join
    end
    
  private
  
    # Returns a generic zipped Array of metadata
    # (There is region, zone, environment, role, but no rtype)
    def build_criteria(more=[], less=[], local={})
      # TODO: This build_criteria treats "more" differently than the
      # ObjectBase one. Sort it out! (This way is better)
      names = [:region, :zone, :environment, :role].compact
      names -= [*less].flatten.uniq.compact
      values = names.collect do |n|
        local[n.to_sym] || @@global.send(n.to_sym)
      end
      names.zip(values) + more
    end
    
    def to_query(more=[], less=[], local={})
      Rudy::AWS::SDB.generate_query build_criteria(more, less, local)
    end
  
    def to_select(more=[], less=[], local={})
      Rudy::AWS::SDB.generate_select ['*'], Rudy::DOMAIN, build_criteria(more, less, local)
    end
    
  end
end

Rudy::Utils.require_glob(RUDY_LIB, 'rudy', 'metadata', 'objectbase.rb')
Rudy::Utils.require_glob(RUDY_LIB, 'rudy', 'metadata', '*.rb')
